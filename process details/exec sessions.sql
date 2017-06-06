use master
go

select
session_id, 
login_time,host_name,program_name,host_process_id,client_interface_name,
login_name,nt_domain,nt_user_name,original_login_name,
last_successful_logon,last_unsuccessful_logon,unsuccessful_logons, client_version
from sys.dm_exec_sessions 
where is_user_process = 1 and session_id <> @@spid
and host_name <> host_name()
order by login_time desc
go