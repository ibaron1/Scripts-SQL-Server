/******** get missing indexes by db, table and their performance impact ******/
SELECT *
into #t
FROM sys.dm_db_missing_index_group_stats

SELECT @@servername as Instance,db_name(database_id) as DbName, statement as [Table],
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
and db_name(database_id) not in ('master','msdb')
order by db_name(database_id), statement,equality_columns, included_columns,
#t.avg_total_user_cost * #t.avg_user_impact/100 * (#t.user_seeks + #t.user_scans) DESC
 
drop table #t


/********///////////other sql///////////////////////***********/
SELECT mig.*, statement AS table_name,
    column_id, column_name, column_usage
FROM sys.dm_db_missing_index_details AS mid
CROSS APPLY sys.dm_db_missing_index_columns (mid.index_handle)
INNER JOIN sys.dm_db_missing_index_groups AS mig ON mig.index_handle = mid.index_handle
ORDER BY mig.index_group_handle, mig.index_handle, column_id;

select * from sys.dm_db_missing_index_details 
select * from sys.dm_db_missing_index_groups 
/********//////////////////////////////////////////***********/
