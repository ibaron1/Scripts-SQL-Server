-- Check SQL Server Schedulers to see if they are waiting on CPU
SELECT scheduler_id, current_tasks_count, runnable_tasks_count
FROM sys.dm_os_schedulers
WHERE scheduler_id < 255 