
select
s1.command,
s1.reads,s1.writes,s1.logical_reads,
s1.session_id as spid, s1.blocking_session_id as blocking_spid,
db_name(s1.database_id) as dbName,
suser_name(s1.user_id) as userName,
s4.original_login_name,
s1.start_time,s1.status,
s1.cpu_time,cast(s1.total_elapsed_time/1000/60 as varchar(2))+' min '+cast(s1.total_elapsed_time/1000%60 as varchar(2))+' sec ' 
as total_elapsed_time,
s1.wait_type,wait_time,s1.last_wait_type,s1.wait_resource,
s4.login_time,s4.host_process_id
from sys.dm_exec_requests AS s1 JOIN sys.dm_exec_sessions s4
ON s1.session_id = s4.session_id
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS s2
cross apply sys.dm_exec_query_plan(plan_handle) as s3  
WHERE s4.is_user_process = 1
and s1.session_id <> @@spid
and command in ('CREATE INDEX', 'ALTER INDEX', 'ALTER TABLE')

