--Rates

set nocount on

declare @objname varchar(400)= 'srf_main.SFreportEOD_pending'

select name as tbl 
into #tbls
from sysobjects
where type = 'U'

select distinct OBJECT_SCHEMA_NAME(d.id) as ObjSchema, cast(object_name(d.id) as varchar(40)) ObjName, 
case o.type when 'P' then 'Proc' 
			when 'TR' then 'Trigger' 
			when 'V' then 'View' 
			when 'V' then 'view'
			when 'FN' then 'SQL scalar function'
			when 'IF' then 'SQL inline table-valued function'
			when 'TF' then 'SQL table-valued-function' end as ObjType,
OBJECT_SCHEMA_NAME(d.id) as DepObjSchema, 
cast(object_name(depid) as varchar(40)) as DepObjName,depid,
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
and  o.object_id = object_id(@objname)
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

declare @SqlString varchar(200)

declare
UpdStat_crsr cursor local fast_forward for
select distinct 'UPDATE STATISTICS '+t.DepObjSchema+'.'+t.DepObjName+' WITH FULLSCAN'
from sys.indexes i join #t1 t
on i.object_id = t.depid 

open UpdStat_crsr

while 1 = 1
begin

  fetch UpdStat_crsr into @SqlString

  if @@fetch_status <> 0
            break 
            
  print  @SqlString
  --exec(@SqlString)  
            

end

close UpdStat_crsr
deallocate UpdStat_crsr


drop table #tbls, #t1