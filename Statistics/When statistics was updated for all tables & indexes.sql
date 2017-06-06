set nocount on

select name as tbl 
into #tbls
from sysobjects
where type in ('U', 'V', 'FN', 'IF', 'TF')

select distinct OBJECT_SCHEMA_NAME(d.id) as ObjSchema, cast(object_name(d.id) as varchar(40)) ObjName, 
case o.type when 'P' then 'Proc' 
			when 'TR' then 'Trigger' 
			when 'V' then 'View' 
			when 'V' then 'view'
			when 'FN' then 'SQL scalar function'
			when 'IF' then 'SQL inline table-valued function'
			when 'TF' then 'SQL table-valued-function' end as ObjType,
OBJECT_SCHEMA_NAME(d.id) as DepObjSchema, 
cast(object_name(depid) as varchar(40)) as DepObjName,
(select case type 
		when 'U' then 'table' 
		when 'V' then 'view' 
		when 'FN' then 'SQL scalar function'
		when 'IF' then 'SQL inline table-valued function'
		when 'TF' then 'SQL table-valued-function' end
 from sys.objects
 where object_id = d.depid) as DepObjType
 into #t1
from sysdepends d, sys.objects o, #tbls t
where d.id = o.object_id
and object_name(depid) = t.tbl

select @@servername as instance, db_name() as dbName,t.*, [name] as IndexName,
cast(round(reserved*8/1024.0, 2) as dec(20,2)) as reserved_MB, 
cast(round(used*8/1024.0, 2) as dec(20,2)) as used_MB,
STATS_DATE (id , indid) StatisticsWasUpdatedOn,
datediff(DAY, STATS_DATE (id , indid), GETDATE()) as UpdateStatsDone_DaysAgo 
from #t1 t, sysindexes i
where object_name(id)  = DepObjName
and [name] not like '[_]WA[_]Sys[_]%'
and datediff(DAY, STATS_DATE (id , indid), GETDATE()) > 0
--and datediff(DAY, STATS_DATE (id , indid), GETDATE()) is not null


drop table #tbls, #t1