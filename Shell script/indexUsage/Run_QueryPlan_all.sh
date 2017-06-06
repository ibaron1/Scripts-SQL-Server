#!/bin/ksh
#set -x
#PS4='line $LINENO: '
#############################################################################
### Script Name: Run_All_Sql.sh                                           ###
### Author: Eli Baron                                                     ###
### Date: 05/04/2006                                                      ###
### Purpose: get query plans for all procs & views                        ###
#############################################################################
. ENV
. INIT

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

grep -H Msg *|grep -h Level|grep -h State|grep -v 'There is already an object'|grep -v -f $ProcNotFoundOn|cut -d':' -f1|sort -u > $ExecProcErr

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
echo "PROC EXEC SQL STRINGS IN $ProcDir" >> $LogDir/tmp
echo "" >>  $LogDir/tmp

echo "DEPENDENT PROCS: `wc -l $ProcList|tr -s ' '`  IN $ProcList" >> $LogDir/tmp
echo "----------------" >> $LogDir/tmp

echo "DEPENDENT VIEWS: `wc -l $ViewList|tr -s ' '`   IN $ViewList" >> $LogDir/tmp
echo "----------------" >> $LogDir/tmp

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
if exists (select * from sysobjects where name='execSql')
  drop table execSql
go
create table execSql (procname varchar(50), RunTime_ms int)
go
!

if [[ -d $CreaTmpTbl ]];then
  rm -r $CreaTmpTbl
fi
mkdir $CreaTmpTbl

for procnm in `cat $ProcList`
do
#
$SYBASE/bin/defncopy -S$SRV -U$UserName -P$PW out $ProcWith_tmptbl/$procnm ${Db} $procnm

awk '/#define temp table/,/#enddef/' $ProcWith_tmptbl/$procnm|sed '/#define temp table/d;/#enddef/d' > $CreaTmpTbl/$procnm
GenerateProcExec.sh $procnm

$SYB/isql -D$Db -S$SRV -U$UserName -P$PW <<! > $RunDir/$procnm
`cat $CreaTmpTbl/$procnm`
go
set showplan on
go
set fmtonly on
go
`cat $ProcDir/$procnm`
go
!

done

##########################################################################
###    Error handling: identify and process run time exceptions        ###
##########################################################################

ERROR_HANDLER 1

######################################################################
### Procs failed to run with issues other then #tbl or tempdb..tbl ###
######################################################################
test -f $LogDir/noTmpTblProcs && rm $LogDir/noTmpTblProcs

for procnm in `cat $LogDir/ExecProcErr_tempdb`
do

awk '/#define temp table/,/#enddef/' $RootDir/ProcDef/$procnm|sed '/#define temp table/d;/#enddef/d' > $LogDir/tmp6
mv $LogDir/tmp6 $crtempdbtbl/$procnm

if [[ -s $crtempdbtbl/$procnm ]];then
$SYB/isql -D$Db -S$SRV -U$UserName -P$PW <<! > $RunDir/$procnm
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

crtbl=`grep tempdb $RunDirerr/$procnm|cut -d' ' -f1`

$SYB/isql -D$Db -S$SRV -U$UserName -P$PW <<! >/dev/null
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

$SYB/isql -S$SRV -U$UserName -P$PW <<! > $RunViewDir/$view
use $Db
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

echo "RE-RUN FAILED SQL RUN THRU ManualSqlExecRun.sh" >> $LogDir/tmp

#$LogDir/Get_sql_w_index_utilization.sh

mail -s 'Procs/views query plans generated' $MailList < $LogDir/tmp
