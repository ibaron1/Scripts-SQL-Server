#!/bin/ksh
#set -x
####################################################################
### Script Name: procs.sh
### Author: Eli Baron
### Date: 05/10/2006
### Purpose: to report procs utilization on the servers listed below
####################################################################

MDAsrc=ProcExecutionSummaryByMonth
#MDAsrc=ProcExecutionSummaryByM_OLD

export SYB="/ms/dist/aurora/bin"
export PWDir="/ms/user/b/baroneli/misc"
export UserName="baroneli"
chmod 400 $PWDir/usr
export PW=`cat $PWDir/usr`
chmod 000 $PWDir/usr

export RootDir="/ms/user/b/baroneli/StandardObj"
export MailList="Eli.Baron@morganstanley.com"

where=''
a2query=a2queryProcs1
a2query_history=a2query_historyProcs1
if [[ "`echo $MDAsrc`" == "ProcExecutionSummaryByMonth" ]];then
  where="and procType = 'P' and databaseName = 'a2query'"
  a2query=a2queryProcs
  a2query_history=a2query_historyProcs
fi

${SYB}/isql -b -D RDGAudit -S NYP_RDG_AUDIT -U$UserName -P$PW <<!>/dev/null 
if exists (select * from  tempdb..sysobjects where name="$MDAsrc")
  drop table tempdb..${MDAsrc}
go
create table tempdb..${MDAsrc}
(
    procName                   varchar(30)   NOT NULL,
    procLastExecutionTime      datetime      NULL,
    avgDailyProcExecutionCount numeric(38,3) NULL,
    logicalServerName          varchar(30)   NOT NULL
)
go
insert tempdb..${MDAsrc}
select procName, procLastExecutionTime, avgDailyProcExecutionCount, logicalServerName
from   ${MDAsrc} e join DatabaseAuditControl a
on e.auditMemberID = a.auditMemberID and procName <> '' $where
go
!

$SYB/bcp tempdb..${MDAsrc} out ${MDAsrc}.out -S NYP_RDG_AUDIT -U$UserName -P$PW -c -t'|' -r\\n

${SYB}/isql -b -D tempdb -S NYP_RDG_HUB -U$UserName -P$PW <<!
set nocount on
if exists (select * from  sysobjects where name="${MDAsrc}")
  drop table ${MDAsrc}
go
create table ${MDAsrc}
(
    procName                   varchar(30)   NOT NULL,
    procLastExecutionTime      datetime      NULL,
    avgDailyProcExecutionCount numeric(38,3) NULL,
    logicalServerName          varchar(30)   NOT NULL
)
go
!

$SYB/bcp tempdb..${MDAsrc} in ${MDAsrc}.out -S NYP_RDG_HUB -U$UserName -P$PW -c -t'|' -r\\n

${SYB}/isql -b -D tempdb -S NYP_RDG_HUB -U$UserName -P$PW <<!
drop table $a2query
go
drop table $a2query_history
go

set nocount on

select name into tempdb..${a2query} 
from a2query..sysobjects o 
where type = 'P' and name not like 'rs_%' and not exists 
(select * from tempdb..${MDAsrc} 
 where procName = o.name)

select "a2query procs not found in ${MDAsrc}"
select '------------------------------------------------------'
select * from tempdb..${a2query}

select ''

select name  into ${a2query_history}
from a2query_history..sysobjects o 
where type = 'P' and name not like 'rs_%' and not exists 
(select * from tempdb..${MDAsrc} 
 where procName = o.name)
select "a2query_history procs not found in ${MDAsrc}"
select '------------------------------------------------------'
select * from ${a2query_history}
go
!
