use master
go

select
session_id as spid, blocking_session_id as blocking_spid,
db_name(database_id) as dbName,
suser_name(user_id) as userName,
start_time, getdate() as [current_time],
datediff(mi,start_time,getdate()) as Run_in_min,
status,command,
cpu_time,total_elapsed_time,
percent_complete,estimated_completion_time,reads,writes,logical_reads,
row_count,
lock_timeout,deadlock_priority,
granted_query_memory,
wait_type,wait_time,last_wait_type,wait_resource,open_transaction_count,open_resultset_count,text_size,
transaction_isolation_level,prev_error,nest_level,executing_managed_code
from sys.dm_exec_requests AS s1 
WHERE database_id is not null and db_name(database_id) not in ('master','msdb') and session_id <> @@spid


/*
http://msdn.microsoft.com/en-us/library/ms177648.aspx
*/
