/* 1 */
DBCC SQLPERF(logspace) -- for all instance dbs

/* 2 */

SELECT cntr_value / 1024.0 [Log Space Used (MB)] 
FROM
sys.dm_os_performance_counters
WHERE counter_name =
'Log File(s) Used Size (KB)'
AND instance_name = 'AdventureWorks' -- for AdventureWorks db


