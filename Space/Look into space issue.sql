/**** Get boot time ****/

select @@servername as [SQL Server], crdate as [Boot Time] from master..sysdatabases where name='tempdb'

/**** Get running processes ****/
use master
go

select @@servername as Instance, 
s1.session_id as spid, s1.blocking_session_id as blocking_spid,
db_name(s1.database_id) as dbName,
suser_name(s1.user_id) as userName,
    (SELECT TOP 1 SUBSTRING(s2.text,statement_start_offset / 2+1 , 
      ( (CASE WHEN statement_end_offset = -1 
         THEN (LEN(CONVERT(nvarchar(max),s2.text)) * 2) 
         ELSE statement_end_offset END)  - statement_start_offset) / 2+1))  AS sql_statement,
s1.start_time,s1.status,s1.command,
s1.cpu_time,s1.total_elapsed_time,
s1.reads,s1.writes,s1.logical_reads,
s1.row_count,
s4.host_name,s4.program_name,
s1.lock_timeout,s1.deadlock_priority,
s1.granted_query_memory,
s1.wait_type,wait_time,s1.last_wait_type,s1.wait_resource,

s4.login_time,s4.host_process_id,s4.client_interface_name,s4.login_name,
s4.nt_domain,s4.nt_user_name,s4.original_login_name,s4.last_successful_logon,s4.last_unsuccessful_logon,
s4.unsuccessful_logons,
 
s1.percent_complete,s1.estimated_completion_time,
s1.open_transaction_count,s1.open_resultset_count,s1.text_size,
s1.transaction_isolation_level,s1.prev_error,s1.nest_level,s1.executing_managed_code
,s4.client_version
--,s3.query_plan 
from sys.dm_exec_requests AS s1 JOIN sys.dm_exec_sessions s4
ON s1.session_id = s4.session_id
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS s2
cross apply sys.dm_exec_query_plan(plan_handle) as s3  
WHERE s4.is_user_process = 1
and s1.session_id <> @@spid


/**** Get database and tran log used/free space in MV and % ****/

SELECT @@servername as Instance, db_name(b.database_id) as DbName,
   case b.type_desc when 'LOG' then 'LOG' else 'DATA' end as type_desc,
   sum(CAST(a.size/128.0 AS DECIMAL(10,2))) AS [Size in MB],
   sum(CAST(FILEPROPERTY(a.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2))) AS [Space Used in MB],
   sum(CAST(a.size/128.0-(FILEPROPERTY(a.name, 'SpaceUsed')/128.0) AS DECIMAL(10,2))) AS [Available Space in MB],
   CAST(sum(CAST(FILEPROPERTY(a.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2)))/sum(CAST(a.size/128.0 AS DECIMAL(10,2)))*100 AS DECIMAL(10,2)) AS [Percent Used]
FROM sysfiles a join master.sys.master_files b
on a.fileid = b.file_id
where db_name(b.database_id) = DB_NAME()
group by b.database_id, 
case b.type_desc when 'LOG' then 'LOG' else 'DATA' end

/**** Get tables used, reserved space ****/

SELECT @@servername as Instance, schema_name(schema_id)+'.'+o.name as tblName, i.name as indexName, indid, reserved*8/1024.0 as reserved_MB, 
used*8/1024.0 as used_MB
FROM sysindexes i join sys.objects o
on i.id = o.object_id and type = 'U'
WHERE indid in (0,1)
order by tblName, reserved_MB desc