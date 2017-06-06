--Credit,Rates,FX UAT
use master
go

declare @ObjName varchar(200) = 'SFreport_EOD'

;with spid
as
(select
s1.session_id as spid, s1.blocking_session_id as blocking_spid,
db_name(s1.database_id) as dbName,
suser_name(s1.user_id) as userName,
s1.status,
case when charindex('create procedure ',lower(s2.text)) > 0 
	 then SUBSTRING(s2.text, charindex('create procedure ',lower(s2.text))+LEN('create procedure '), LEN(s2.text))
	 when charindex('create proc ',lower(s2.text)) > 0 
	 then SUBSTRING(s2.text, charindex('create proc ',lower(s2.text))+LEN('create proc '), LEN(s2.text))
	 else s2.text end as ObjName,
s1.command,
(SELECT TOP 1 SUBSTRING(s2.text,statement_start_offset / 2+1 , 
  ( (CASE WHEN statement_end_offset = -1 
     THEN (LEN(CONVERT(nvarchar(max),s2.text)) * 2) 
     ELSE statement_end_offset END)  - statement_start_offset) / 2+1))  AS sql_statement,
s1.start_time,GETDATE() as [current_time],
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
,s3.query_plan 
from sys.dm_exec_requests AS s1 JOIN sys.dm_exec_sessions s4
ON s1.session_id = s4.session_id
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS s2
cross apply sys.dm_exec_query_plan(plan_handle) as s3  
WHERE s4.is_user_process = 1
and s1.session_id <> @@spid)
select * from spid
where ObjName like '%'+@ObjName+'%'


--=================

/*

*/
--Active transactions
;with spid
as
(
SELECT st.transaction_id,
er.Session_ID,
s.host_name,
s.login_name,
db.name as dbname,
case when charindex('create procedure ',lower(text)) > 0 
	 then SUBSTRING(text, charindex('create procedure ',lower(text))+LEN('create procedure ')+1, LEN(text))
	 when charindex('create proc ',lower(text)) > 0 
	 then SUBSTRING(text, charindex('create proc ',lower(text))+LEN('create proc ')+1, LEN(text))
	 else text end as ObjName,
er.command, 
text as [statement],
er.wait_resource, 
er.total_elapsed_time,
p.status, p.physical_io,
p.lastwaittype,  
s.transaction_isolation_level,
/*
Transaction isolation level of the session.
0 = Unspecified
1 = ReadUncomitted
2 = ReadCommitted
3 = Repeatable
4 = Serializable
5 = Snapshot
*/
cast(p.login_time as varchar(24)) as login_time,
cast(p.last_batch as varchar(24)) as last_batch,
p.program_name
    FROM sys.dm_tran_active_transactions st 
        INNER JOIN sys.dm_exec_requests er 
        ON st.transaction_id = er.transaction_id
        CROSS APPLY sys.dm_exec_sql_text(er.sql_handle)
INNER JOIN sys.dm_tran_database_transactions dt 
ON dt.transaction_id = st.transaction_id 
INNER JOIN sys.databases db ON db.database_id = dt.database_id 
INNER JOIN sys.dm_exec_sessions s ON s.session_id = er.Session_ID
join master..sysprocesses p
on p.spid = er.Session_ID
)
select * from spid
where ObjName like '%'+@ObjName+'%'
 

-- transactions by connections
;with spid
as
(
SELECT st.transaction_id,
er.Session_ID,
s.host_name,
s.login_name,
db.name as dbname,
case when charindex('create procedure ',lower(text)) > 0 
	 then SUBSTRING(text, charindex('create procedure ',lower(text))+LEN('create procedure ')+1, LEN(text))
	 when charindex('create proc ',lower(text)) > 0 
	 then SUBSTRING(text, charindex('create proc ',lower(text))+LEN('create proc ')+1, LEN(text))
	 else text end as ObjName, 
text as [statement],
er.total_elapsed_time,
cast(p.login_time as varchar(24)) as login_time,
cast(p.last_batch as varchar(24)) as last_batch,
p.program_name, p.status, p.physical_io,
p.lastwaittype,  
s.transaction_isolation_level
    FROM sys.dm_tran_session_transactions st INNER JOIN sys.dm_exec_connections ec 
    ON st.session_id = ec.session_id
    INNER JOIN sys.dm_exec_requests er 
        ON st.transaction_id = er.transaction_id
        CROSS APPLY sys.dm_exec_sql_text(er.sql_handle)
INNER JOIN sys.dm_tran_database_transactions dt 
ON dt.transaction_id = st.transaction_id 
INNER JOIN sys.databases db ON db.database_id = dt.database_id 
INNER JOIN sys.dm_exec_sessions s ON s.session_id = er.Session_ID
join master..sysprocesses p
on p.spid = er.Session_ID
)
select * from spid
where ObjName like '%'+@ObjName+'%'
     





