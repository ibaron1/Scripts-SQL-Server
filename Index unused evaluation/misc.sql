-------------------------------------------------
-- get lock scheme for tbls and their count
-------------------------------------------------

select * from
(select name, lockscheme(id) lockscheme
from sysobjects
where type='U') t
order by lockscheme, name
compute count(lockscheme)
by lockscheme
compute count(lockscheme)

--------------------------
-- find table lock schema
--------------------------

select name, lockscheme(id)
from sysobjects
where name in ('PortfolioHistoryInstrument','PortfolioInstance')

--------------------------
-- get count allpages tbls
--------------------------
select count(*) 'allpages' from sysobjects
where type='U'
and lockscheme(id) = 'allpages' 

---------------------------
-- get count datapages tbls
---------------------------
select count(*) 'datapages' from sysobjects
where type='U'
and lockscheme(id) = 'datapages' 

---------------------------
-- get count datarows tbls
---------------------------
select count(*) 'datarows' from sysobjects
where type='U'
and lockscheme(id) = 'datarows' 

---------------------------------------
-- get count clustered idx for allpages
---------------------------------------
select count(i.id) 'clustered idx# for allpages'
from sysindexes i join sysobjects o
on i.id = o.id and o.type='U'
and lockscheme(o.id) = 'allpages'
and i.indid = 1

-------------------------------------------
-- get count non-clustered idx for allpages
-------------------------------------------
select count(i.id) 'non-clustered idx# allpages'
from sysindexes i join sysobjects o
on i.id = o.id and o.type='U'
and lockscheme(o.id) = 'allpages'
and i.indid 1

---------------------------------------
-- get count clustered idx for DOL
---------------------------------------
select count(i.id) 'clustered idx# DOL'
from sysindexes i join sysobjects o
on i.id = o.id and o.type='U'
and lockscheme(o.id) <> 'allpages'
and i.indid = 2

-------------------------------------------
-- get count non-clustered idx for DOL
-------------------------------------------
select count(i.id) 'non-clustered idx# DOL'
from sysindexes i join sysobjects o
on i.id = o.id and o.type='U'
and lockscheme(o.id) <'allpages'
and i.indid 2


--------------------
-- get PKs and count
--------------------
select * from 
(select object_name(id) Tbl, name as PK from sysindexes
where status&2048 = 2048
and object_name(id) not like 'sys%') t
compute count(PK) 

----------------
-- get FKs
----------------

select * from 
(select object_name(reftabid) Referenced_tbl, object_name(tableid) Referencing_tbl, 
col_name(tableid, fokey1) fokey1, isnull(col_name(tableid, fokey2), '') fokey2, isnull(col_name(tableid, fokey3), '') fokey3,isnull(col_name(tableid, fokey4), '') fokey4,
col_name(reftabid, refkey1) refkey1, isnull(col_name(reftabid, refkey2), '') refkey2,isnull(col_name(reftabid, refkey3), '') refkey3,isnull(col_name(reftabid, refkey4), '') refkey4,
object_name(constrid) constr
from sysreferences
where object_name(constrid) is not null
--and object_name(reftabid) = 'TEventStub'
) t
order by Referenced_tbl,Referencing_tbl 
compute count(Referenced_tbl) 
by Referenced_tbl
compute count(Referenced_tbl)

------------------------
-- get proc with cursors
------------------------
select distinct object_name(id) from syscomments
where lower(text) like '%cursor%'

------------------------
-- get devices
------------------------
select db_name(u.dbid) dbname, d.name device, d.phyname
from master..sysdevices d, master..sysusages u
where u.vstart between d.low and d.high and dbid=db_id()
group by u.dbid
 