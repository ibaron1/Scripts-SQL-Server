/******** get missing indexes by db, table and their performance impact ******/
declare @ObjName varchar(30)= 'srf_main.GetTradeDetails'
select distinct 
db_id() as dbid1, depid 
into #dep
from sysdepends d, sys.objects o
where d.id = o.object_id
and  o.object_id = object_id(@objname)
and exists
(select '1' from sys.objects
 where object_id = d.depid and type='U')

SELECT *
into #t
FROM sys.dm_db_missing_index_group_stats

SELECT @@servername as Instance,db_name(mid.database_id) as DbName, mid.statement as [Table], 
cast(round(#t.avg_total_user_cost * #t.avg_user_impact/100 * (#t.user_seeks + #t.user_scans),0) as bigint) as [Performance Impact],
equality_columns,inequality_columns,included_columns,
cast(round(#t.avg_total_user_cost,0) as bigint) as avg_total_user_cost, #t.avg_user_impact, 
#t.user_seeks, cast(#t.last_user_seek as varchar(24)) as last_user_seek, 
#t.user_scans, cast(#t.last_user_scan as varchar(24)) as last_user_scan,
#t.unique_compiles
FROM sys.dm_db_missing_index_group_stats AS migs
INNER JOIN sys.dm_db_missing_index_groups AS mig
    ON (migs.group_handle = mig.index_group_handle)
INNER JOIN sys.dm_db_missing_index_details AS mid
    ON (mig.index_handle = mid.index_handle)
join #t on migs.group_handle = #t.group_handle
join #dep on mid.database_id = #dep.dbid1 and OBJECT_ID(mid.statement) = #dep.depid
where db_name(mid.database_id) <> 'dbautils'
order by db_name(mid.database_id), statement,equality_columns, included_columns,
#t.avg_total_user_cost * #t.avg_user_impact/100 * (#t.user_seeks + #t.user_scans) DESC
 
drop table #t, #dep