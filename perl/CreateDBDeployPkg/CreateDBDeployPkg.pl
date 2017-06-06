use Win32;
use Sys::Hostname;
use XML::Simple;
use File::Path;
use File::Copy;
use File::Find;
use File::Basename; 
use Encode;
use Encode::Guess;

if (!(($#ARGV == 1 ) or ($#ARGV == 2))) {
 print "usage: " . basename($0) . " Label Environment UserPassInfo(optional)\n";
 exit;
}
$label = $ARGV[0];
$environment = $ARGV[1];
$userpass = $ARGV[2];

$depotbasedir = "CreateDBDeployPkgDepot";
$deploypkgbasedir = "CreateDBDeployPkg";
$tempclientfile = "$depotbasedir.client.p4";
$username = Win32::LoginName;
$hostname = hostname;
$client = "$hostname" . "_" . $username . "_" . $depotbasedir;
@phaserelease = qw();

&CreateClientFile("//depot/SRF/branches");
$status = `p4 client -i < $tempclientfile 2>&1`;
chomp $status;
if (( $status ne "Client " . $client . " saved." ) && ( $status ne "Client " . $client . " not changed." ))
 { die "p4 client command failed --> " . $status; }
 
if ($label =~ m/\@/) { $label =~ s/\@//g; }
@status = `p4 files \@$label 2>&1`;
foreach (@status) 
  {
    if ($_ =~ m/Invalid changelist/) { die "Error: " , join("\n",@status) , "\n"; }
    if ($_ =~ m/not in client view/) { die "Error: " , join("\n",@status) , "\n"; }
    my @out = split(/\//,$_);
	if (!((@out[2] eq "depot") && (@out[3] eq "SRF") && (@out[4] eq "branches") && (@out[6] eq "srf") && (@out[7] eq "PRODReleaseArtifacts") && (@out[9] eq "DB") )) 
	  { print "Invalid label. Must have //depot/SRF/branches/*/srf/PRODReleaseArtifacts/*/DB \n";
        print "Current label has path: " . join("/",@out[0],@out[1],@out[2],@out[3],@out[4],@out[5],@out[6],@out[7],@out[8],@out[9]) . "\n"; 
        exit;
   	  }
    push(@phaserelease,join("/",@out[0],@out[1],@out[2],@out[3],@out[4],@out[5],@out[6],@out[7],@out[8],@out[9]));
  } 

my @unique = &Uniq(@phaserelease);
if ( scalar(@unique) != 1) { die "Multiple phase/release paths or no files for label $label --> " . "\n" . join("\n", @unique) . "\n"; }
$phaserelease = @unique[0];
&CreateClientFile($phaserelease);

if (-d $depotbasedir) { rmtree($depotbasedir) || die "Cannot remove folder $depotbasedir --> $! \n"; }
mkdir $depotbasedir || die "Unable to create directory $depotbasedir --> $! \n";

$status = `p4 client -i < $tempclientfile 2>&1`;
chomp $status;
if (( $status ne "Client " . $client . " saved." ) && ( $status ne "Client " . $client . " not changed." ))
 { die "p4 client command failed --> " . $status; }

$status = `p4 set p4client=$client 2>&1`;
chomp $status;
if ( $status ne "" )
 { die "p4 set p4client=$client command failed --> " . $status; }

$status = `p4 sync -f -q \@$label 2>&1`;
chomp $status;
if (( $status ne "File(s) up-to-date.") && ( $status ne "" ))
 { die "p4 sync command failed --> " . $status; }

find(\&ChangeAttrib, $depotbasedir);

if (-d $deploypkgbasedir) { rmtree($deploypkgbasedir) || die "Cannot remove folder $deploypkgbasedir --> $! \n"; }
mkdir $deploypkgbasedir || die "Unable to create directory $deploypkgbasedir --> $! \n";

&CreatePkgFiles("COMMON");
&CreatePkgFiles("RATES");
&CreatePkgFiles("FX");
&CreatePkgFiles("CREDIT");
&CreatePkgFiles("EQ");

$status = `p4 set p4client= 2>&1`;
chomp $status;
if ( $status ne "" )
 { die "p4 set p4client= command failed --> " . $status; }

$status = `p4 client -d $client 2>&1`;
chomp $status;
if ((! $status =~ m/Client (.*?)deleted/ ) && (! $status =~ m/Client (.*?)doesn(.*?)exist/)) { die "p4 client -d command failed --> " . $status . "\n"; }

if (-d $depotbasedir) { rmtree($depotbasedir) || die "Cannot remove folder $depotbasedir --> $! \n"; }
if ( -e $tempclientfile) { unlink($tempclientfile) or die "Cannot delete file: $tempclientfile --> $!\n"; }


#####
##### Subroutine CreateClientFile
#####
sub CreateClientFile()
{
    my($phaserelease) = ($_[0]);
	open(my $fc,">$tempclientfile") || die "Cannot create file $tempclientfile --> $! \n";
	print $fc <<FOO;
Client:	$client

Owner:	$username

Host:	$hostname

Root:	null

Options:	noallwrite noclobber nocompress unlocked nomodtime rmdir

SubmitOptions:	revertunchanged

LineEnd:	local

View:
	$phaserelease/... //$client/$depotbasedir/...

FOO
close($fc);
}


#####
##### Subroutine Uniq
#####
sub Uniq 
{ 
my %seen;  
return grep { !$seen{$_}++ } @_;
}


#####
##### Subroutine GetManifestList
#####
sub GetManifestList()
{
  my($assetclass) = ($_[0]);
  my $xml = new XML::Simple;
  my $data = $xml->XMLin($depotbasedir . "\\manifest.xml",ForceArray=>1,KeyAttr=>['AssetClass'], SuppressEmpty=>undef);
  my @do = @{$data->{Objects}->{$assetclass}->{DeployObject}};
  my @ro = @{$data->{Objects}->{$assetclass}->{RollbackObject}};
  for (@do) { s/^\s+|\s+$//g; }
  for (@ro) { s/^\s+|\s+$//g; }
  for(my $i=$#do;$i>=0;$i--) {  
    if (length($do[$i]) == 0) {splice(@do,$i,1);}
  }
  for(my $i=$#ro;$i>=0;$i--) {  
    if (length($ro[$i]) == 0) {splice(@ro,$i,1);}
  }
  return (\@do,\@ro);
}


#####
##### Subroutine CreatePkgFile
#####
sub CreatePkgFiles()
{
  my($assetclass) = ($_[0]);
  my($deploylist_ref,$rollbacklist_ref) = &GetManifestList($assetclass);
  my @deploylist = @$deploylist_ref;
  my @rollbacklist = @$rollbacklist_ref;
  my $assetpkgbasedir = $deploypkgbasedir . "\\" . $assetclass;
  my $assetpkgrollbackdir = $assetpkgbasedir . "\\Rollback";  
  my $assetdepotbasedir = $depotbasedir . "\\" . $assetclass . "\\";
  my $assetdepotrollbackbasedir = $depotbasedir . "\\" . $assetclass . "\\Rollback\\";
  my $deploymanifestfile = $assetpkgbasedir . "\\" . "Manifest.txt";
  my $rollbackmanifestfile = $assetpkgrollbackdir . "\\" . "Manifest.txt";
  my $deploypkgmainfile = $deploypkgbasedir . "\\" . "DeployPkg.cmd";
  my $rollbackpkgmainfile = $deploypkgbasedir . "\\" . "RollbackPkg.cmd";
  my $runpackagecmdfile = $assetpkgbasedir . "\\" . "RunPackage.cmd";
  my $rollbackrunpackagecmdfile = $assetpkgrollbackdir . "\\" . "RunPackage.cmd";
  my $err;
  if ($assetclass ne "COMMON") 
    { 
	  ($servername,$dbname,$cachedbname,$portnumber) = &GetConnInfo($assetclass,$environment);
      if (length($servername) == 0) { die "Invalid servername for environment=$environment and assetclass=$assetclass\n"; }
      if (length($dbname) == 0) { die "Invalid dbname for environment=$environment and assetclass=$assetclass\n"; }
	}
  if (scalar(@deploylist) > 0) 
  {
    $err = 0;
    if (! -d $assetpkgbasedir) { mkdir $assetpkgbasedir || die "$assetclass: Unable to create directory $assetpkgbasedir --> $! \n"; }
	foreach my $p (@deploylist)
	  {
	    my $fr = $assetdepotbasedir . $p;
		my $to = $assetpkgbasedir . "\\" . $p;
	    if (-e $fr) 
		  { CopyFile($fr,$to); }
		else
		  { $err = 1; print "Error $assetclass(<DeployObject>): File specified in the manifest file but does not exists in the perforce depot/label --> $p\n"; }		
	  }
	&CheckIfExistsInManifest($assetdepotbasedir,\@deploylist,$assetclass,"<DeployObject>");
    if ($err == 0)
	  {
        open $fh, '>', $deploymanifestfile or die "$assetclass: Cannot create file $deploymanifestfile: $!\n";
        print $fh join("\n",@deploylist),"\n";
        close $fh;
		&CreateRunPackageCmdFile($runpackagecmdfile);
		if (!-e $deploypkgmainfile) { &CreateFileWithEcho($deploypkgmainfile); }
        if ($assetclass eq "COMMON")
		  {
		    my @assets = ("FX", "CREDIT","EQ","RATES");
            foreach my $lassetclass (@assets)
			  {
			    my($lservername,$ldbname,$lcachedbname,$lportnumber) = &GetConnInfo($lassetclass,$environment);
                if (length($lservername) == 0) { die "Invalid servername for environment=$environment and assetclass=$lassetclass\n"; }
                if (length($ldbname) == 0) { die "Invalid dbname for environment=$environment and assetclass=$lassetclass\n"; }
			    &WritePkgMainFile($deploypkgmainfile, $lservername, $ldbname, $assetclass, "common","");
			  }
          }
		else
		  { &WritePkgMainFile($deploypkgmainfile, $servername, $dbname, $assetclass, "",""); }
	  }
  }
  
  if (scalar(@rollbacklist) > 0) 
  {
    $err = 0;
    if (! -d $assetpkgbasedir) { mkdir $assetpkgbasedir || die "$assetclass: Unable to create directory $assetpkgbasedir --> $! \n"; }
    if (! -d $assetpkgrollbackdir) { mkdir $assetpkgrollbackdir || die "$assetclass: Unable to create directory $assetpkgrollbackdir --> $! \n"; }
	foreach my $p (@rollbacklist)
	  {
	    my $fr = $assetdepotrollbackbasedir . $p;
		my $to = $assetpkgrollbackdir . "\\" . $p;
	    if (-e $fr) 
		  { &CopyFile($fr,$to); }
		else 
		  { $err = 1; print "Error $assetclass(<RollbackObject>): File specified in the manifest file but does not exists in the perforce depot/label --> $p\n"; }		
	  }
	&CheckIfExistsInManifest($assetdepotbasedir,\@rollbacklist,$assetclass,"<RollbackObject>");
    if ($err == 0)
	  {
        open $fh, '>', $rollbackmanifestfile or die "$assetclass: Cannot create file $rollbackmanifestfile: $!\n";
        print $fh join("\n",@rollbacklist),"\n";
        close $fh;
		&CreateRunPackageCmdFile($rollbackrunpackagecmdfile);
		if (!-e $rollbackpkgmainfile) { &CreateFileWithEcho($rollbackpkgmainfile); }
        if ($assetclass eq "COMMON")
		  {
		    my @assets = ("FX", "CREDIT","EQ","RATES");
            foreach my $lassetclass (@assets)
			  {
			    my($lservername,$ldbname,$lcachedbname,$lportnumber) = &GetConnInfo($lassetclass,$environment);
                if (length($lservername) == 0) { die "Invalid servername for environment=$environment and assetclass=$lassetclass\n"; }
                if (length($ldbname) == 0) { die "Invalid dbname for environment=$environment and assetclass=$lassetlass\n"; }
			    &WritePkgMainFile($rollbackpkgmainfile, $lservername, $ldbname, $assetclass,"common","rollback");
			  }
          }
		else
		  { &WritePkgMainFile($rollbackpkgmainfile, $servername, $dbname, $assetclass,"","rollback"); }		
      }
  }

}

#####
##### Subroutine CreateFileWithEcho
#####
sub CreateFileWithEcho 
{ 
  open my $fh, '>', $_[0] or die "Cannot create $_[0]: $!\n"; 
  print $fh "\@echo off\n";
  close $fh; 
  return $@; 
} 

#####
##### Subroutine GetConnInfo
#####
sub GetConnInfo()
{
  my($assetclass,$environment) = ($_[0], $_[1]);
  my $xml = new XML::Simple;
  my $data = $xml->XMLin("ConnectionInfo.xml",ForceArray=>1,KeyAttr=>['AssetClass','Environment']);
  my $servername = $data->{ConnectionInfo}->{$assetclass}->{Conn}->{$environment}->{ServerName};
  my $dbname = $data->{ConnectionInfo}->{$assetclass}->{Conn}->{$environment}->{DBName};
  my $cachedbname = $data->{ConnectionInfo}->{$assetclass}->{Conn}->{$environment}->{CacheDBName};
  my $portnumber = $data->{ConnectionInfo}->{$assetclass}->{Conn}->{$environment}->{PortNumber};
  return (&Trim($servername),&Trim($dbname),&Trim($cachedbname),&Trim($portnumber))
}

#####
##### Subroutine Trim
#####
sub Trim 
{
  (my $s = $_[0]) =~ s/^\s+|\s+$//g;
  return $s;        
}

#####
##### Subroutine WritePkgMainFile
#####
sub WritePkgMainFile 
{
  my($deploypkgmainfile,$servername,$dbname,$assetclass,$common,$rollback) = ($_[0], $_[1],$_[2], $_[3], $_[4], $_[5]);
  open my $fh, '>>', $deploypkgmainfile or die "Cannot open file $deploypkgmainfile: $!\n";
  if ($rollback eq "rollback")
    { print $fh "cd " . $assetclass . "\\Rollback\n"; }
  else
    { print $fh "cd " . $assetclass . "\n"; }
  if ($common eq "common")
    { print $fh "call RunPackage.cmd " . $servername . " " . $dbname . " >> RunPackage_" . $common . "_$dbname.log 2>&1\n"; }
	else 
	{ print $fh "call RunPackage.cmd " . $servername . " " . $dbname . " >> RunPackage_$dbname.log 2>&1\n"; }
  if ($rollback eq "rollback")
    { print $fh "cd ..\\..\n"; }
  else
    { print $fh "cd ..\n"; }
  print $fh "\n";
  close $fh; 
}

#####
##### Subroutine CreateRunPackageCmdFile
#####
sub CreateRunPackageCmdFile()
{
  open(my $fc,">$_[0]") || die "Cannot create file $_[0] --> $! \n";
  print $fc <<FOO;
\@echo off
set SQLInstance=%1
set DBName=%2

echo.***********************************************************************************************
echo.***********************************************************************************************
echo.***********************************************************************************************
echo SQLInstance=%SQLInstance% DBName=%DBName% CurrentDirectory=%CD%
echo.

sqlcmd -h -1 -S%SQLInstance% -d%DBName% $userpass -Q"SET NOCOUNT ON SELECT '%DBName% Release Started :' + CONVERT(varchar,getdate(),126)"

FOR /F "tokens=*" %%T in (Manifest.txt) DO (
  echo.
  echo.
  echo.***********************************************************************************************
  sqlcmd -h -1 -S%SQLInstance% -d%DBName% $userpass -Q"SET NOCOUNT ON SELECT ' Started SQL Script %%T :' + CONVERT(varchar,getdate(),126)"
  REM echo GO >> %%T
  sqlcmd -S%SQLInstance% -d%DBName% $userpass -i%%T -w 2000
  sqlcmd -h -1 -S%SQLInstance% -d%DBName% $userpass -Q"SET NOCOUNT ON SELECT '   Ended SQL Script %%T :' + CONVERT(varchar,getdate(),126)"
)

echo.
sqlcmd -h -1 -S%SQLInstance% -d%DBName% $userpass -Q"SET NOCOUNT ON SELECT '%DBName% Release Ended :' + CONVERT(varchar,getdate(),126)"
echo.
echo.
echo.
echo.
echo.
FOO
close($fc);
}

#####
##### Subroutine ChangeAttrib
#####
sub ChangeAttrib()
{
chmod 0700, $_ || die "chmod failed on file:" . $_ . "--> $! \n";
}

#####
##### Subroutine CopyFile
#####
sub CopyFile()
{
  my($fr,$to) = ($_[0], $_[1]);
  open INPFILE, '<', $fr or die "Cannot open input file $fr: $!\n";
  open OUTFILE, '>', $to or die "Cannot open output file $to: $!\n";
  binmode(OUTFILE,":utf8");
  $output = do {local $/; <INPFILE> };
  my $decoder = guess_encoding($output);
  if ($decoder =~ m/Unicode=HASH/)
    {
      my $o = decode("utf16", $output);
	  $o =~ s/\r//g;
	  print OUTFILE $o;
    }
  else
    {
      print OUTFILE  $output;
    }
  print OUTFILE "\nGO\n";
  close INPFILE;
  close OUTFILE;
}

#####
##### Subroutine CheckIfExistsInManifest
#####
sub CheckIfExistsInManifest()
{
my ($dir,$arr_ref,$assetclass,$type) = ($_[0],$_[1],$_[2],$_[3]);
opendir (DIR, $dir) or die $!;
while (my $file = readdir(DIR)) 
 {
	if (!(( -d $dir . $file ) or ($file eq "placeholder.txt")))
	{ 
	  if (!( grep (/^$file$/,@$arr_ref) ))
             { print "Error $assetclass($type): File exists in the perforce depot but does not exists in manifest file --> $file\n"; }
    }
	closedir(DIR);
 }
}

