#!/bin/ksh
. ENV
$SYB/isql -S$SRV -U$UserName -P$PW <<!
use tempdb
go
if exists (select * from sysobjects where name='procs')
  drop table procs
go
select name into procs from ${Db}..sysobjects where type='P' and name not like 'rs_%'
go
if exists (select * from sysobjects where name='views')
  drop table views
go
select name into views from ${Db}..sysobjects where type='V'
go
use $Db
go
select f.tbl,f.ind,f.const,f.def 
into #tblname 
from tempdb..a2oltpFKIndexes f join sysobjects o
on f.tbl = o.name and o.type = 'U'
where not exists 
(select * from tempdb..a2queryIndDef_tbl
 where tbl = f.tbl)
union
select f.tbl,f.ind,f.const,f.def 
from tempdb..a2oltpFKIndexes_dtl f join sysobjects o
on f.tbl = o.name and o.type = 'U'
where not exists (select * from tempdb..a2queryIndDef_dtl
        where tbl = f.tbl
        and isnull(key1,' ') = isnull(f.key1,' ') and isnull(key2,' ') = isnull(f.key2,' ') 
        and isnull(key3,' ') = isnull(f.key3,' ') and isnull(key4,' ') = isnull(f.key4,' '))

select distinct o.name
into procs
from sysobjects o join
(select d.id, tbl from sysdepends d join sysobjects o1
on d.depid=o1.id join #tblname on o1.id=object_id(tbl)) dep(id,tbl)
on o.id=dep.id and type = 'P'
order by o.name

select distinct o.name
into views
from sysobjects o join
(select d.id, tbl from sysdepends d join sysobjects o1
on d.depid=o1.id join #tblname on o1.id=object_id(tbl)) dep(id,tbl)
on o.id=dep.id and type = 'V'
order by o.name

go
!

$SYB/isql -b -S$SRV -U$UserName -P$PW <<! > $ProcList
set nocount on
select name from tempdb..procs
go
!

$SYB/isql -b -S$SRV -U$UserName -P$PW <<! > $ViewList
set nocount on
select name from tempdb..views
go
!
