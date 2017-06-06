-- Calculates average stalls per read, per write, and per total input/output for each database file
-- gives full details for all database files
-- IO/s per MB - to analyze size of database files' impact on I/O

SELECT distinct @@servername as Instance, DB_NAME(vfs.database_id) AS [Database Name], 
b.physical_name AS FileName,b.type_desc,

CAST(b.size/128.0 AS DECIMAL(10,2)) AS [Size_MB],
num_of_reads + num_of_writes AS [Total I/Os],
io_stall_read_ms + io_stall_write_ms AS [Total I/O stalls], 
CAST(round((num_of_reads + num_of_writes)/(b.size/128.0),0) AS int) AS [Total I/Os_MB],
CAST((io_stall_read_ms + io_stall_write_ms)/(1.0 + num_of_reads + num_of_writes) AS NUMERIC(10,1)) AS [Avg I/O stalls_ms],

'' as [R],
num_of_reads as [Read I/Os],
io_stall_read_ms AS [Read I/O stalls],
CAST(io_stall_read_ms/(1.0 + num_of_reads) AS NUMERIC(10,1)) AS [Avg Read I/O stalls_ms],

'' as [W],
num_of_writes as [Write I/Os],
io_stall_write_ms AS [Write I/O stalls], 
CAST(io_stall_write_ms/(1.0 + num_of_writes) AS NUMERIC(10,1)) AS [Avg Write I/O stalls_ms],

CAST(b.size/128.0-(FILEPROPERTY(b.name, 'SpaceUsed')/128.0) AS DECIMAL(10,2)) AS [Available Space],
CAST(FILEPROPERTY(b.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2)) AS [Space Used],
CAST((CAST(FILEPROPERTY(b.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2))/CAST(b.size/128.0 AS DECIMAL(10,2)))*100 AS DECIMAL(10,2)) AS [% Used]
FROM sys.dm_io_virtual_file_stats(null,null) vfs join master.sys.master_files b
on vfs.file_id = b.file_id and vfs.database_id = b.database_id
--where b.database_id = DB_ID('FALCON_SRF_FX')
ORDER BY [Database Name], b.type_desc desc, [Size_MB], [Avg I/O stalls_ms] DESC;


--These queries may help you explore I/O situation and top wait stats in a little more deeply.


-- Check for IO Bottlenecks (run multiple times, look for values above zero)
SELECT cpu_id, pending_disk_io_count 
FROM sys.dm_os_schedulers
WHERE [status] = 'VISIBLE ONLINE'
ORDER BY cpu_id;

-- Look at average for all schedulers (run multiple times, look for values above zero)
SELECT AVG(pending_disk_io_count) AS [AvgPendingDiskIOCount]
FROM sys.dm_os_schedulers 
WHERE [status] = 'VISIBLE ONLINE';

-- Clear Wait Stats 
-- DBCC SQLPERF('sys.dm_os_wait_stats', CLEAR);

-- Isolate top waits for server instance since last restart or statistics clear
WITH Waits AS
(SELECT wait_type, wait_time_ms / 1000. AS wait_time_s,
100. * wait_time_ms / SUM(wait_time_ms) OVER() AS pct,
ROW_NUMBER() OVER(ORDER BY wait_time_ms DESC) AS rn
FROM sys.dm_os_wait_stats
WHERE wait_type NOT IN ('CLR_SEMAPHORE','LAZYWRITER_SLEEP','RESOURCE_QUEUE','SLEEP_TASK'
,'SLEEP_SYSTEMTASK','SQLTRACE_BUFFER_FLUSH','WAITFOR', 'LOGMGR_QUEUE','CHECKPOINT_QUEUE'
,'REQUEST_FOR_DEADLOCK_SEARCH','XE_TIMER_EVENT','BROKER_TO_FLUSH','BROKER_TASK_STOP','CLR_MANUAL_EVENT'
,'CLR_AUTO_EVENT','DISPATCHER_QUEUE_SEMAPHORE', 'FT_IFTS_SCHEDULER_IDLE_WAIT'
,'XE_DISPATCHER_WAIT', 'XE_DISPATCHER_JOIN'))
SELECT W1.wait_type, 
CAST(W1.wait_time_s AS DECIMAL(12, 2)) AS wait_time_s,
CAST(W1.pct AS DECIMAL(12, 2)) AS pct,
CAST(SUM(W2.pct) AS DECIMAL(12, 2)) AS running_pct
FROM Waits AS W1
INNER JOIN Waits AS W2
ON W2.rn <= W1.rn
GROUP BY W1.rn, W1.wait_type, W1.wait_time_s, W1.pct
HAVING SUM(W2.pct) - W1.pct < 95; -- percentage threshold
