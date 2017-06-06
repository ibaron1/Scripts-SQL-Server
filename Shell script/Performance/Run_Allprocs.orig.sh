#!/bin/ksh
#set -x
#PS4='line $LINENO: '
#############################################################################
### Script Name: Run_Allprocs.sh                                          ###
### Author: Eli Baron                                                     ###
### Date: 05/18/2006                                                      ###
### Purpose: Log exec time for all procs                                  ###
#############################################################################
. RUN_ENV
. RUN_INIT

###=========================================================================###
###                             FUNCTION STARTS                             ###
###=========================================================================###
ERROR_HANDLER()
{
###########################################################################
###    Procs w exec errors because of temp tbls: #tmp or tempdb..tbl    ###
###########################################################################
cd $RunDir

grep -H 'Stored procedure' *|grep -h 'not found'|cut -d':' -f1|sort -u > $ProcNotFoundOn

grep -H Msg *|grep -h Level|grep -h State|grep -v -f $ProcNotFoundOn|cut -d':' -f1|sort -u > $ExecProcErr

test -s $LogDir/ExecProcErr && cp `cat $LogDir/ExecProcErr` $RunDirerr

##########################################################################################
### Get procs with reference to tempdb..tbl, they require manual exec proc preparation ###
##########################################################################################

cd $RunDirerr

grep -l tempdb * > $LogDir/ExecProcErr_tempdb

test -s $LogDir/ExecProcErr_tempdb && test $1 -eq 2 && echo "`cat $LogDir/ExecProcErr_tempdb|wc -l` PROCS FAILED TO RUN BECAUSE OF REFERENCE TO TEMPDB..TBL CREATED OUT OF A PROC SCOPE, PREPARE and RE-RUN THRU RunDir" >> $LogDir/tmp && cat $LogDir/ExecProcErr_tempdb  >>  $LogDir/tmp && echo "" >>  $LogDir/tmp
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
echo "" >>  $LogDir/tmp

######## Get all procs & views ####

$SYB/isql -b -S$SRV -U$UserName -P$PW <<! >$ProcList
set nocount on
select name 
from a2query..sysobjects where type='P'
go
!

$SYB/isql -b -S$SRV -U$UserName -P$PW <<! >$ProcFromTestCaseList
set nocount on
select procname from tempdb..testcase
go
!

$SYB/isql -b -S$SRV -U$UserName -P$PW <<! >$ProcExecGenerated
set nocount on
select name 
from a2query..sysobjects o
where not exists 
(select * from  tempdb..testcase 
where procname =o.name)  and o.type='P'
go
!

$SYB/isql -b -S$SRV -U$UserName -P$PW <<! >$ViewList
set nocount on
select name
from a2query..sysobjects where type='V'
go
!

####################################
###           PROCS              ###
####################################

$SYB/isql -S$SRV -U$UserName -P$PW <<! >/dev/null
use tempdb
go
if exists (select * from sysobjects where name='execproc')
  drop table execproc
go
create table execproc (execsql varchar(8000))
go
if exists (select * from sysobjects where name='TestCaseID')
  drop table TestCaseID
go
create table TestCaseID (testCaseID int)
go
use a2query
go
if exists (select * from sysobjects where name='execSql')
   sp_rename execSql, execSql_befIndDrop
go
create table a2query..execSql (testCaseID int null, procname varchar(50), RunTime_ms int)
go
!

for procnm in `cat $ProcFromTestCaseList`
do

$SYB/isql -b -Dtempdb -S$SRV -U$UserName -P$PW <<! >/dev/null
truncate table TestCaseID

insert TestCaseID
select testCaseID from testcase where procname="$procnm"

truncate table execproc

insert execproc
select SQLText from testcase where procname="$procnm"
go
!

bcp tempdb..execproc out $ProcDir/$procnm -S$SRV -U$UserName -P$PW -c > /dev/null

sqlstring=`cat $ProcDir/$procnm`

$SYB/isql -b -D$Db -S$SRV -U$UserName -P$PW <<! > $RunDir/$procnm
declare @t datetime
select "$sqlstring"
select @t = getdate()

$sqlstring

insert a2query..execSql
select testCaseID, "$procnm", datediff(ms, @t, getdate())
from tempdb..TestCaseID

go
!

done

if [[ -d $CreaTmpTbl ]];then
  rm -r $CreaTmpTbl
fi
mkdir $CreaTmpTbl

for procnm in `cat $ProcExecGenerated`
do

$SYBASE/bin/defncopy -S$SRV -U$UserName -P$PW out $ProcWith_tmptbl/$procnm ${Db} $procnm

awk '/#define temp table/,/#enddef/' $ProcWith_tmptbl/$procnm|sed '/#define temp table/d;/#enddef/d' > $CreaTmpTbl/$procnm

### exec string in $ProcDir/$procnm

GenerateProcExec.sh $procnm

sqlstring=`cat $ProcDir/$procnm`

$SYB/isql -D$Db -S$SRV -U$UserName -P$PW <<! > $RunDir/$procnm
`cat $CreaTmpTbl/$procnm`
go
select "$sqlstring"
go
declare @t datetime

select @t = getdate()

$sqlstring

insert a2query..execSql
select null, "$procnm", datediff(ms, @t, getdate())
from tempdb..TestCaseID

go
!

done
