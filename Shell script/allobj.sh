#!/bin/ksh
$SYB/isql -S$SRV -U$UserName -P$PW <<!
use tempdb
go
if exists (select * from sysobjects where name='DQSobj')
begin
  drop table DQSobj
  drop table DQSproc
  drop table DQSview
end
go
create table DQSobj (name varchar(40))
go
!

$SYB/bcp tempdb..DQSobj in list.txt -S$SRV -U$UserName -P$PW -c -t'|' -r\\n >/dev/null

$SYB/isql -S$SRV -U$UserName -P$PW <<! >> $LogDir/tmp
use tempdb
go

select d.name into DQSproc
from DQSobj d join a2query..sysobjects o
on d.name=o.name and type='P'

select d.name into DQSview
from DQSobj d join a2query..sysobjects o
on d.name=o.name and type='V'

select d.name, type, user_name(uid) dbuser from a2query..sysobjects o right join DQSobj d  on o.name=d.name  
order by d.name, type
go
!

