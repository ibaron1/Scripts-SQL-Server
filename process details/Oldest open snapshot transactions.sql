PRINT N'DBCC OPENTRAN:' 
EXEC sp_msforeachdb N'USE [?]; PRINT DB_NAME() + N'':''; DBCC OPENTRAN WITH TABLERESULTS, NO_INFOMSGS ' 
PRINT '' 
-- Oldest open snapshot transactions - affects tempdb workload 
SELECT TOP 5 N'dm_tran_active_snapshot_database_transactions' AS DataSource_SnapshotTrans, 
Session_ID,transaction_id, transaction_sequence_num, elapsed_time_seconds 
FROM sys.dm_tran_active_snapshot_database_transactions 
ORDER BY elapsed_time_seconds DESC 
EXEC sp_msforeachdb N'USE [?]; DBCC OPENTRAN'

 
----- The age, DB and owner of the oldest 10 snapshot related transactions can be found with: 
SELECT TOP 10 
st.transaction_id, 
st.Session_ID, 
s.host_name,
s.login_name,
db.name as dbname, 
text as [statement],
st.elapsed_time_seconds,
cast(p.login_time as varchar(24)) as login_time,
cast(p.last_batch as varchar(24)) as last_batch,
p.program_name, p.status, p.physical_io,
p.lastwaittype,  
s.transaction_isolation_level, 
st.is_snapshot, 
st.max_version_chain_traversed, 
st.average_version_chain_traversed
FROM sys.dm_tran_active_snapshot_database_transactions st 
INNER JOIN sys.dm_tran_database_transactions dt 
ON dt.transaction_id = st.transaction_id 
INNER JOIN sys.databases db ON db.database_id = dt.database_id 
INNER JOIN sys.dm_exec_sessions s ON s.session_id = st.session_id
join master..sysprocesses p
on p.spid = st.Session_ID
cross apply sys.dm_exec_sql_text(sql_handle) 
order by s.host_name
