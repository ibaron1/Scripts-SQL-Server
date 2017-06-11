
------------ delete statistics from all tables

select 'delete statistics',name
from sysobjects where type='U'

------------ update statistics (leading clmns only)

select 'select '+"'update stats for "+name+"'"+char(10)+'update statistics '+name+char(10)
from sysobjects where type='U'

------------ update index statistics (all indexes clmns)

-- serial mode

select 'select '+"'update index stats for Table "+o.name+"'"+' ,index '+i.name+char(10)+'update index statistics '+o.name+' '+i.name+char(10)
from sysindexes i join sysobjects o
on o.name = object_name(i.id) and o.type='U' and o.name not like 'sys%' and o.name not like 'rs_%'
where (indid  > 0 and lockscheme(i.id, db_id()) = 'allpages') or (indid  > 1 and lockscheme(i.id, db_id()) <> 'allpages')
order by o.name


-- parallel mode : 
/**
set 
'number of worker processes' = max number of partitions
'max parallel degree'	     <= 'number of worker processes'
'max scan parallel degree' = 2 or 3
**/

select 'select '+"'update index stats for Table "+o.name+"'"+' ,index '+i.name+'  with consumers=9'+char(10)+'update index statistics '+o.name+' '+i.name+'  with consumers=9'+char(10)
from sysindexes i join sysobjects o
on o.name = object_name(i.id) and o.type='U' and o.name not like 'sys%' and o.name not like 'rs_%'
where (indid  > 0 and lockscheme(i.id, db_id()) = 'allpages') or (indid  > 1 and lockscheme(i.id, db_id()) <> 'allpages')
order by o.name



----------- restart update stats

select 'select '+"'update stats for "+name+"'"+char(10)+'update statistics '+name+char(10)
from sysobjects o where type='U'
and not exists 
(select 1 from sysstatistics  
where object_name(id) = object_name(o.id))


---------- find date when statistics was modified for indexes & columns

select  object_name(s.id) 'table', moddate 'stats_moddate', colidarray, * 
from sysstatistics s, sysobjects o
where s.id = o.id and type='U'
order by object_name(s.id), moddate, colidarray


--------- get partitioned tables
-- summary

select object_name(id),count(id)
from syspartitions
group by object_name(id)

-- details

select object_name(id) 'table',partitionid, firstpage, controlpage,count(id) 'partitions in the table'
from syspartitions
group by object_name(id)
order by object_name(id)