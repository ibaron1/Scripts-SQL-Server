#!/bin/ksh
#PS4='line $LINENO: '
#set -x
##########################################
### Script Name: GetTblScanAll.sh
### Author: Eli Baron
### Date: 04/19/2006
### Purpose: Table scan in query plans details 
#################################################################################################################
. ENV 

echo "RUN WAS ON $SRV DATASERVER" > $LogDir/tmp
echo "------------------------" >> $LogDir/tmp
echo "SHOWPLANS IN $RunDir" >> $LogDir/tmp
echo "" >>  $LogDir/tmp
echo "Table scan in query plans details for $Db procs & views are in $GetTblScan directory" >> $LogDir/tmp
echo "" >>  $LogDir/tmp

if [[ -d  $GetTblScan ]];then
  rm -r  $GetTblScan
fi
mkdir $GetTblScan

cd $RunDir

$SYB/isql -b -Dtempdb -S$SRV -U$UserName -P$PW <<!
if exists (select * from sysobjects where name='queryplan')
  drop table queryplan
go
create table queryplan(line varchar(1900) null)
go
if exists (select * from sysobjects where name='queryplan1')
  drop table queryplan1
go
create table queryplan1(linenum int identity, line varchar(1900) null)
go
if exists (select * from sysobjects where name='tblscan')
  drop table tblscan
go
create table tblscan(line varchar(1900))
go
if exists (select * from sysobjects where name='tblscan1')
  drop table tblscan1
go
create table tblscan1(procname varchar(50),tblScanCnt int)
go
!

cp $RunViewDir/* $RunDir

for procnm in `ls $RunDir`
do

if [[ `grep 'Table Scan' $RunDir/$procnm` ]]; then
$SYB/bcp tempdb..queryplan in $RunDir/$procnm -S$SRV -U$UserName -P$PW -c -r\\n >/dev/null
$SYB/isql -b -Dtempdb -S$SRV -U$UserName -P$PW -i${RootDir}/tblScan.sql
$SYB/bcp tempdb..tblscan out $GetTblScan/$procnm -S$SRV -U$UserName -P$PW -c -r\\n >/dev/null
fi

$SYB/isql -b -Dtempdb -S$SRV -U$UserName -P$PW<<!>/dev/null
truncate table queryplan
truncate table queryplan1
truncate table tblscan
go
!

done

echo "Execution count from NYQ_A2_INT2.RDGaudit..ProcExecutionSummaryByMonth and table scan count for $Db procs & views" >> $LogDir/tmp
cd $RunDir
grep -c -H 'Table Scan' * >$LogDir/tmp1
$SYB/bcp tempdb..tblscan1 in $LogDir/tmp1 -S$SRV -U$UserName -P$PW -c -t':' -r\\n >/dev/null
$SYB/isql -Dtempdb -S$SRV -U$UserName -P$PW <<!>>$LogDir/tmp
set nocount on
select t.procname, t.tblScanCnt as 'Tbl Scan Count', p.totalProcExecutionCount
from tblscan1 t left join
(select procName, sum(totalProcExecutionCount) totalProcExecutionCount
from ProcExecutionSummaryByMonth
where procName not like 'rs_%'
group by procName) p 
on t.procname=p.procName
where t.tblScanCnt <> 0
order by totalProcExecutionCount desc
go
!

mail -s "Table scan in query plans details for $Db  procs & views" $MailList < $LogDir/tmp
