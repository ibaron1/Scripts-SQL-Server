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

RootDir="/ms/user/b/baroneli/indexUsage"

grep "ADD CONSTRAINT" $RootDir/a2oltp_ForeignKeys.sql|tr -s ' '|cut -d' ' -f4 > $RootDir/a2oltp_ForeignKeysName.txt

grep -v IF $RootDir/a2oltp_indexes.sql|grep -v go|grep -v PRINT|grep -v ELSE > $RootDir/a2oltp_indexes1.sql

grep -v go $RootDir/a2oltp_indexes.sql|grep -v 'IF EXISTS'|grep -v PRINT|grep -v ELSE > $RootDir/a2oltp_indexes1.sql

grep -v WITH $RootDir/A2QUERY_INDEXES.sql|grep -v go|grep -v 'IF EXISTS'|grep -v PRINT|grep -v ELSE>a2query_indexes.sql

$SYB/isql -b -Dtempdb -S$SRV -U$UserName -P$PW <<! #>/dev/null
if exists (select * from sysobjects where name='a2oltpIndDef')
  drop table a2oltpIndDef, a2oltpForeignKey
go
create table a2oltpIndDef (indDef varchar(2000) null)
go
create table a2oltpForeignKey (keydef  varchar(1000) null)
go
if exists (select * from sysobjects where name='a2queryIndDef')
  drop table a2queryIndDef
go
create table a2queryIndDef(indDef varchar(2000) null)
go
!

bcp tempdb..a2oltpIndDef in $RootDir/a2oltp_indexes1.sql -S$SRV -U$UserName -P$PW -c

$SYB/isql -b -Dtempdb -S$SRV -U$UserName -P$PW -i$RootDir/ParseA2oltpIndx.sql >/dev/null

$SYB/isql -b -Dtempdb -S$SRV -U$UserName -P$PW -i$RootDir/ParseA2oltpIndx_Tbl.sql >/dev/null

bcp tempdb..a2oltpForeignKey in $RootDir/a2oltp_ForeignKeys.txt -S$SRV -U$UserName -P$PW -c

$SYB/isql -b -Dtempdb -S$SRV -U$UserName -P$PW -i$RootDir/ParseA2oltpForeignKeys.sql >/dev/null

$SYB/isql -b -Dtempdb -S$SRV -U$UserName -P$PW -i$RootDir/ParseA2oltpForeignKeys_Tbl.sql >/dev/null

bcp tempdb..a2queryIndDef in $RootDir/a2query_indexes.sql -S$SRV -U$UserName -P$PW -c

$SYB/isql -b -Dtempdb -S$SRV -U$UserName -P$PW -i$RootDir/ParseA2queryIndx_Tbl.sql >/dev/null

$SYB/isql -b -D$Db -S$SRV -U$UserName -P$PW <<!
exec GetA2oltpFKIndexes
go
---------- Get a2oltp FK indexes and index definitions
if exists (select * from tempdb..sysobjects where name='a2oltpFKIndexes_dtl')
  drop table tempdb..a2oltpFKIndexes_dtl
go
select distinct c.tbl, c.const, i.ind, i.key1, i.key2, i.key3, i.key4, i.def 
into tempdb..a2oltpFKIndexes_dtl
from tempdb..a2oltpForeignKey_dtl c
join tempdb..a2oltpFKInd f
on c.tbl = f.tbl and c.const = f.constr
join tempdb..a2oltpIndDef_dtl i
on f.tbl = i.tbl and f.ind = i.ind
order by c.tbl, c.const

---------- Get a2oltp FK index keys to compare to a2query indexes not to introduce duplicate indexes (same columns based)
if exists (select * from tempdb..sysobjects where name='a2oltpFKIndexes_tbl')
  drop table tempdb..a2oltpFKIndexes_tbl
go
select distinct f.tbl, i.ind, i.keys 
into tempdb..a2oltpFKIndexes_tbl
from tempdb..a2oltpForeignKey_dtl c
join tempdb..a2oltpFKInd f
on c.tbl = f.tbl and c.const = f.constr
join tempdb..a2oltpIndDef_tbl i
on f.tbl = i.tbl and f.ind = i.ind
order by i.tbl, i.ind
go
select tbl as "Table",ind as "Index",const as "FK constraint",def as "DDL"
from
(
select f.tbl,f.ind,f.const,f.def
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
) t
order by "Table"
go
!

