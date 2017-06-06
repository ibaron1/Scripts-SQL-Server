#!/bin/ksh
#set -x
#PS4='line $LINENO: '
#############################################################################
### Script Name: Run_Showplan_All.sh                                      ###
### Author: Eli Baron                                                     ###
### Date: 03/27/2006                                                      ###
### Purpose: Generates the table dependent procs/views exec stmt          ###
###          and run them thru showplan                                   ###
#############################################################################
if [[ $# -ne 1 ]];then
  echo "Usage: $0 Table_name"
  exit
fi

Table=$1

. ENV $Table
. INIT

###=========================================================================###
###                             FUNCTION STARTS                             ###
###=========================================================================###
ERROR_HANDLER()
{
###########################################################################
###    Procs w exec errors because of temp tbls: #tmp or tempdb..tbl    ###
###########################################################################
cd $ShowplanDir

grep -H 'Stored procedure' *|grep -h 'not found'|cut -d':' -f1|sort -u > $ProcNotFoundOn

grep -H Msg *|grep -h Level|grep -h State|grep -v -f $ProcNotFoundOn|cut -d':' -f1|sort -u > $ExecProcErr

cp `cat $LogDir/ExecProcErr` $showplanerr

##########################################################################################
### Get procs with reference to tempdb..tbl, they require manual exec proc preparation ###
##########################################################################################

cd $showplanerr

grep -l tempdb * > $LogDir/ExecProcErr_tempdb

test -s $LogDir/ExecProcErr_tempdb && test $1 -eq 2 && echo "`cat $LogDir/ExecProcErr_tempdb|wc -l` PROCS FAILED TO RUN BECAUSE OF REFERENCE TO TEMPDB..TBL CREATED OUT OF A PROC SCOPE, PREPARE and RE-RUN THRU SHOWPLAN" >> $LogDir/tmp && cat $LogDir/ExecProcErr_tempdb  >>  $LogDir/tmp && echo "" >>  $LogDir/tmp
}
###=========================================================================###
###                              FUNCTION ENDS                              ###
###=========================================================================###



#######################################
###               MAIN              ###
################################### ###

echo "RUN WAS ON $SRV DATASERVER" > $LogDir/tmp
echo "------------------------" >> $LogDir/tmp
echo "SCRIPT $0 IN $LogDir" >>  $LogDir/tmp
echo "PROC EXEC SQL STRINGS IN $ProcDir" >> $LogDir/tmp
echo "SHOWPLANS IN $ShowplanDir" >> $LogDir/tmp
echo "" >>  $LogDir/tmp

######## Copy all dependent on table/index procs and views from source to target server ####
######## Get Procs & Views from TEST SERVER DB                                          ####
CopyMissedProcsViews.sh

$SYB/isql -b -S$SRV -U$UserName -P$PW1 <<! >$ProcList
set nocount on

select object_name(d.id)
from sysdepends d join sysobjects o 
on d.id=o.id and o.type='P' and d.depid=object_id("$Table") and object_name(d.id) not like 'rs_%'
go
!

echo "DEPENDENT PROCS: `cat $ProcList|wc -l|tr -s ' '`  IN $ProcList" >> $LogDir/tmp
echo "----------------" >> $LogDir/tmp

$SYB/isql -b -S$SRV -U$UserName -P$PW1 <<! >$ViewList
set nocount on

select object_name(d.id)
from sysdepends d join sysobjects o
on d.id=o.id and o.type='V' and d.depid=object_id("$Table")
go
!

echo "DEPENDENT VIEWS: `cat $ViewList|wc -l|tr -s ' '`   IN $ViewList" >> $LogDir/tmp
echo "----------------" >> $LogDir/tmp

####################################
###           PROCS              ###
####################################

$SYB/isql -S$SRV -U$UserName -P$PW1 <<! >/dev/null
use tempdb
go
if exists (select * from sysobjects where name='execproc')
  drop table execproc
go
create table execproc (execsql varchar(8000))
go
!

for procnm in `cat $ProcList`
do
Run_Showplan.sh $procnm
done

for procnm in `cat $ProcList`
do

sqlstring=`cat $ProcDir/$procnm`
$SYB/isql -S$SRV -U$UserName -P$PW1 <<! > $ShowplanDir/$procnm
use $Db
go
select "$sqlstring"
go
set showplan on
go
set fmtonly on
go
$sqlstring
go
!

done

##########################################################################
###    Error handling: identify and process run time exceptions        ###
##########################################################################

ERROR_HANDLER 1

### Prepare procs with #tbl access for exec ###
###############################################

grep -v -f $LogDir/ExecProcErr_tempdb $LogDir/ExecProcErr > $LogDir/ExecProcErr_tmptbl

if [[ -d $CreaTmpTbl ]];then
  rm -r $CreaTmpTbl
fi
mkdir $CreaTmpTbl

for procnm in `cat $LogDir/ExecProcErr_tmptbl`
do

$SYBASE/bin/defncopy -S$SRV -U$UserName -P$PW1 out $ProcErr_tmptbl/$procnm ${Db} $procnm

awk '/#define temp table/,/#enddef/' $ProcErr_tmptbl/$procnm|sed '/#define temp table/d;/#enddef/d' > $CreaTmpTbl/$procnm

done

for procnm in `ls $CreaTmpTbl`
do

sqlstring=`cat $ProcDir/$procnm`

$SYB/isql -S$SRV -U$UserName -P$PW1 <<! > $ShowplanDir/$procnm

`cat $CreaTmpTbl/$procnm`
go
use $Db
go
select "$sqlstring"
go
set showplan on
go
set fmtonly on
go
$sqlstring
go
!

done

######################################################################
### Procs failed to run with issues other then #tbl or tempdb..tbl ###
######################################################################

test -f $LogDir/noTmpTblProcs && rm $LogDir/noTmpTblProcs

$SYB/isql -b -S$SRV -U$UserName -P$PW <<! >> $LogDir/tmp
use tempdb
go
if exists (select * from sysobjects where name='procusage')
 drop table procusage
go
create table procusage
(procname varchar(40), cnt int, sqlstring varchar(8000),
 unique nonclustered (procname))
go
!

echo "ProcedureUsage_H imported"
$SYB/bcp tempdb..procusage in /ms/user/b/baroneli/ProcUsage/ProcedureUsage_H.bcp -S$SRV -U$UserName -P$PW -c -t'|' -r\\n

for nm in `find $CreaTmpTbl -size 0`
do

mdaproc=`basename $nm`

$SYB/isql -b -S$SRV -U$UserName -P$PW1 <<! > $getExecFromMDA/$mdaproc
set nocount on
select sqlstring from tempdb..procusage where procname=ltrim("$mdaproc")
go
!

if [[ -s $getExecFromMDA/$mdaproc ]];then
$SYB/isql -D$Db -S$SRV -U$UserName -P$PW1 <<! > $ShowplanDir/$mdaproc
set showplan on
go
set fmtonly on
go
`cat $ShowplanDir/$mdaproc`
go
!
else
rm $getExecFromMDA/$mdaproc
echo $mdaproc >> $LogDir/noTmpTblProcs
fi

done

echo "`ls $getExecFromMDA|wc -l|tr -s ' '` PROCS WITH DYNAMIC SQL, EXEC STRING FOUND in MDA tbl ProcedureUsage:" >> $LogDir/tmp
echo "------------------------------------------------------------------------------------------------" >> $LogDir/tmp
ls $getExecFromMDA >> $LogDir/tmp
echo "" >> $LogDir/tmp
echo "`cat $LogDir/noTmpTblProcs|wc -l|tr -s ' '` PROCS WITH DYNAMIC SQL, EXEC STRING NOT FOUND in MDA tbl ProcedureUsage:" >> $LogDir/tmp
echo "---------------------------------------------------------------------------------------------" >> $LogDir/tmp
cat $LogDir/noTmpTblProcs >> $LogDir/tmp 
echo "" >> $LogDir/tmp

for procnm in `cat $LogDir/ExecProcErr_tempdb`
do

$SYBASE/bin/defncopy -S$SRV -U$UserName -P$PW1 out $crtempdbtbl/$procnm ${Db} $procnm > /dev/null

awk '/#define temp table/,/#enddef/' $crtempdbtbl/$procnm|sed '/#define temp table/d;/#enddef/d' > $LogDir/tmp6
mv $LogDir/tmp6 $crtempdbtbl/$procnm

if [[ -s $crtempdbtbl/$procnm ]];then
$SYB/isql -D$Db -S$SRV -U$UserName -P$PW1 <<! > $ShowplanDir/$procnm
`cat $crtempdbtbl/$procnm`
go
set showplan on
go
set fmtonly on
go
`cat $ProcDir/$procnm`
go
!
fi

crtbl=`grep tempdb $showplanerr/$procnm|cut -d' ' -f1`

$SYB/isql -D$Db -S$SRV -U$UserName -P$PW1 <<! >/dev/null
drop table $crtempdbtbl/$procnm
go
!

done

ERROR_HANDLER 2

###############
###  Views  ###
###############
for view in `cat $ViewList`
do

$SYB/isql -S$SRV -U$UserName -P$PW1 <<! > $ShowplanViewDir/$view
use $Db
go
set nocount on
go
set showplan on 
go
set noexec on
go
select * from $view
go
!

done

echo "" >> $LogDir/tmp

echo "RE-RUN FAILED SQL RUN THRU ManualSqlExec.sh" >> $LogDir/tmp

#$LogDir/Get_sql_w_index_utilization.sh

mail -s "$Table table dependent procs/views query plans generation details" $MailList < $LogDir/tmp
