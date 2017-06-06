#!/bin/ksh
#PS4='line $LINENO: '

. ENV

cd $RunDir
grep 'Index :' *|cut -d: -f1,3 > $RootDir/utilizedIndexes

$SYB/isql -Dtempdb -S$SRV -U$UserName -P$PW <<!
if exists (select * from sysobjects where name='utilizedIndexes')
  drop table utilizedIndexes
go
create table utilizedIndexes(pvnm varchar(40), ind varchar(50))
go
if exists (select * from sysobjects where name='utInd')
  drop table utInd
go
create table utInd(ind varchar(50))
go
!

$SYB/bcp tempdb..utilizedIndexes in $RootDir/utilizedIndexes -S$SRV -U$UserName -P$PW -c -t':' -r\\n

$SYB/isql -b -Dtempdb -S$SRV -U$UserName -P$PW <<! > $RootDir/IndexesNotUtilized
set nocount on

insert utInd
select distinct ind 
from utilizedIndexes

select ind, tbl
from indexes i 
where not exists
(select * from utInd where ltrim(ind) = ltrim(i.ind))
order by ind

go
!
