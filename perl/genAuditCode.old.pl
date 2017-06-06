#!/ms/dist/perl5/bin/perl5.8




use MSDW::Version
 "DBD::Sybase" => "1.04",
  "DBI" => "1.47",
"Hash-NoVivify" => '0.01.2',
  "MSDW-MSLog"        => "1.8.1",
  "TimeDate"          => "1.16",
  "Compress-Zlib"     => "1.31",
  "entmgt/perlProbe"  => "3.0",
  "entmgt/perlconfig" => "2.0",
  "MSDW-Platform"     => "1.1",
  "MSDW-Sysloc"       => "1.3",
  "MSDW-NetMap"       => "1.1",
  "Time-HiRes"        => "1.55",
;
use DBI;
use MSDW::MSLog;
use Text::ParseWords;
use Data::Dumper;
use strict;
use warnings;
use Hash::NoVivify qw(Defined Exists);

$|=1;

my $logdir = "./generator";

my $statementBuffer;
my $textBuffer;

my $log = new MSDW::MSLog ("./generator/logfile", 1)   or die $@;

#$log->destination (MSLogFile,"100", { Path    => "$logdir", Pattern => "logfile.%Y%m%d.%H%M%S.&p", RotateOnStartup  => 10000, RotateInFlight => 10000 })                    or die $@;

#$log->destination(MSLogNetcool,MSLogAlert) or die $@;


$log->log(MSLogNotice, "Starting ");



my $DBServer = "NYT_RDG_INTERNAL"; 
my $DBUserID = "neeraju";
my $DBPassword = $ARGV[0];

my $DB = "rdgvat";
my $verDB = "rdgvat";
my $baseTable = "account";
my $pkColumns = "accountId";
my $features = "noRev"; # noRev, noFutureDated, all
my $optimizeForLarge = "false"; # if optimized than 2 tables for inserted 
			# and deleted are created and busEndTS is updated later
my $tsColumn = "none"; # lastUpdTS
my $versionCol = "none"; # versionId


my $i;

my $sql =<<ENDSQL;
select convert(char(32),b.name) name, 
convert(char(15),case         
when c.name in ('float','numeric') and b.scale > 0 then
c.name ||'(' 
||convert(varchar,isnull(b.prec,b.length))||','||
convert(varchar,b.scale)||')' 
when c.name in ('float','numeric') and b.scale = 0 then c.name 
||'(' 
||convert(varchar,isnull(b.prec,b.length)) ||')'  
when c.name in ('char','varchar','varbinary' ) then c.name||'(' 
||convert(varchar,b.length)||')' 
else convert(char(15),c.name) 
end )
|| case
when (b.status & 8) = 8     then 'NULL' 
when (b.status & 0 ) = 0    then 'NOT NULL' 
else 'NOT NULL' 
end  datatyp 
from $DB..sysobjects a,
$DB..syscolumns b,$DB..systypes c  
where a.name = '${baseTable}'
and   a.type='U'  
and   a.id = b.id 
and   b.usertype = c.usertype  
order by a.name,b.colid  
ENDSQL
my $DBHandle = &connectToDbServer($DBServer,$DBUserID,$DBPassword);
my $rows = $DBHandle->selectall_arrayref($sql,  { Slice => {} });
my $rownum = 0;
foreach my $row ( @$rows )
{
	$rownum++;
	if ( $rownum == 1 )
	{
	print<<EOF;
use $verDB
go
create table baseTableVer (
	versionId	integer identity,
EOF
	} 
	print "	".$row->{name}."	".$row->{datatyp}.",\n";
}
print<<EOF;
	busEffectiveTS datetime null,
	busEndTS	datetime null,
	versionEffectiveTS datetime null,
	versionEndTS	datetime null,
	dbOperationCd	char(1),
	auditId		int
)
go
create unique index ${baseTable}VerPkIdx on ${baseTable}Ver(versionId)
go
EOF
# to call sql with hadler use following
#&execSQL($sql,$DBHandle,\&print_data);


my $time = time();


sub connectToDbServer {
my ( $DBServer,$DBUserID,$DBPassword) = @_;

  $log->log(MSLogNotice,"Connecting to $DBServer using $DBUserID...");
  $DBHandle = DBI->connect(
    "dbi:Sybase:$DBServer",
    $DBUserID,
    $DBPassword,
    {
    AutoCommit => 0
    }
  ) 
  or 
    fatalError("Could not connect to $DBServer using $DBUserID " . $DBI::errstr);
  $log->log(MSLogNotice,"Connected to $DBServer using $DBUserID");
return $DBHandle;
 

}
$DBHandle->disconnect;


sub execSQL{
    my($sql,$DBHandle,$callback,@callbackParams)=@_;

    my $sth =  $DBHandle->prepare($sql)
       or fatalError("Prepare failed for reading execSQL server".$DBI::errstr);
    $sth->execute() or fatalError ("Execute failed execute ".$DBI::errstr);
    $log->log(MSLogNotice,"Read execSQL");
    if ( defined $callback )
    {
	return  &$callback($DBHandle,$sth,@callbackParams);
    }
    $sth->finish();
}

sub print_data {
    my($DBHandle,$sth)=@_;
    my $resultSet;
    my $rows;
print join("\n");
    while ($resultSet = $sth->fetchrow_hashref) {
        print "$resultSet->{spid} \n" ;
        ++$rows;
    }
    $log->log(MSLogNotice,"query returned $rows rows");
}


sub fatalError {

  my $errorMessage = shift;

  $log->log(MSLogEmerg, "$errorMessage");
  exit 1;

}
