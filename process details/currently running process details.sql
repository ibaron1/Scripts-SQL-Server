use master
go

select 
host_name,program_name,client_interface_name,
login_name,nt_domain,nt_user_name,original_login_name,
s1.session_id as spid, blocking_session_id as blocking_spid,
db_name(database_id) as dbName,
suser_name(user_id) as userName,
s1.status,
case when charindex('create procedure ',lower(s2.text)) > 0 
	 then SUBSTRING(s2.text, charindex('create procedure ',lower(s2.text))+LEN('create procedure ')+1, LEN(s2.text))
	 when charindex('create proc ',lower(s2.text)) > 0 
	 then SUBSTRING(s2.text, charindex('create proc ',lower(s2.text))+LEN('create proc ')+1, LEN(s2.text))
	 else s2.text end as ObjName,
command,
(SELECT TOP 1 SUBSTRING(s2.text,statement_start_offset / 2+1 , 
  ( (CASE WHEN statement_end_offset = -1 
     THEN (LEN(CONVERT(nvarchar(max),s2.text)) * 2) 
     ELSE statement_end_offset END)  - statement_start_offset) / 2+1))  AS sql_statement,
start_time,
s1.cpu_time,s1.total_elapsed_time,
percent_complete,estimated_completion_time,s1.reads,s1.writes,s1.logical_reads,
s1.row_count,
s1.lock_timeout,s1.deadlock_priority,
granted_query_memory,
wait_type,wait_time,last_wait_type,wait_resource,open_transaction_count,open_resultset_count,s1.text_size,
s1.transaction_isolation_level,s1.prev_error,nest_level,executing_managed_code
,query_plan 
from sys.dm_exec_requests AS s1
join sys.dm_exec_sessions  as s0
on s1.session_id = s0.session_id  
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS s2
cross apply sys.dm_exec_query_plan(plan_handle) as s3 
WHERE s2.dbid is not null and db_name(s2.dbid) not in ('master','msdb') and s1.session_id <> @@spid


/*
http://msdn.microsoft.com/en-us/library/ms177648.aspx
*/
