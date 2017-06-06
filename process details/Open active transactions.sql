--Active transactions
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
(SELECT TOP 1 SUBSTRING(text,statement_start_offset / 2+1 , 
  ( (CASE WHEN statement_end_offset = -1 
     THEN (LEN(CONVERT(nvarchar(max),text)) * 2) 
     ELSE statement_end_offset END)  - statement_start_offset) / 2+1))  AS sql_statement,
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
p.program_name,
s3.query_plan
    FROM sys.dm_tran_active_transactions st 
        INNER JOIN sys.dm_exec_requests er 
        ON st.transaction_id = er.transaction_id
        CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) as s2
        CROSS APPLY sys.dm_exec_query_plan(plan_handle) as s3 
INNER JOIN sys.dm_tran_database_transactions dt 
ON dt.transaction_id = st.transaction_id 
INNER JOIN sys.databases db ON db.database_id = dt.database_id 
INNER JOIN sys.dm_exec_sessions s ON s.session_id = er.Session_ID
join master..sysprocesses p
on p.spid = er.Session_ID
WHERE is_user_process = 1
and s.session_id <> @@spid  
order by db.name 





