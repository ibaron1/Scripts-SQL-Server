#!/bin/ksh
#set -x
#PS4='line $LINENO: '

module load syb/12.5

export SYB="/ms/dist/syb/dba_env/oc32/12.5/bin"
export PWDir="/ms/user/b/baroneli/misc"
export UserName="baroneli"

chmod 400 $PWDir/usr
export PW=`cat $PWDir/usr`
chmod 000 $PWDir/usr

export SRV="NYQ_A2_INT2"
export Db="a2query"

$SYB/isql -b -D$Db -S$SRV -U$UserName -P$PW <<! >/dev/null
if exists (select * from sysobjects where name='UnusedIndexes')
  drop table UnusedIndexes
go
create table UnusedIndexes(ind varchar(50), tbl varchar(50))
go
!

bcp ${Db}..UnusedIndexes in UnusedIndex_from_QueryPlans -S$SRV -U$UserName -P$PW -c -t'|' -r\\n

$SYB/isql -b -D$Db -S$SRV -U$UserName -P$PW <<! >UnusedIndexes_from_QueryPlans_w_no_PK.list
if exists (select * from sysobjects where name=' UnusedIndexes_w_no_PK')
  drop table  UnusedIndexes_w_no_PK
go
select u.* into UnusedIndexes_w_no_PK
from UnusedIndexes u join sysindexes i
on u.ind = i.name and i.id = object_id(u.tbl) and u.tbl not like 'rs_%'
and i.status < 2048

select * from UnusedIndexes_w_no_PK
go
!

