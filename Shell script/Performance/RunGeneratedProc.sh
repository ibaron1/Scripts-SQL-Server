#!/bin/ksh
#set -x
#PS4='line $LINENO: '

. RUN_ENV
. RUN_INIT

for procnm in `cat $RootDir/ProcList`
do

$SYBASE/bin/defncopy -S$SRV -U$UserName -P$PW out $ProcWith_tmptbl/$procnm ${Db} $procnm

awk '/#define temp table/,/#enddef/' $ProcWith_tmptbl/$procnm|sed '/#define temp table/d;/#enddef/d' > $CreaTmpTbl/$procnm

$RootDir/GenerateProcExec.sh $procnm

sqlstring=`cat $ProcDir/$procnm`

$SYB/isql -D$Db -S$SRV -U$UserName -P$PW <<! > $RunDir/$procnm
`cat $CreaTmpTbl/$procnm`
go
select "$sqlstring"
go
declare @t datetime

select @t = getdate()

$sqlstring

insert a2query..execSql_w_indDropped
select null, "$procnm", datediff(ms, @t, getdate())

go
!

done
