-- Check SQL Server Schedulers to see if they are waiting on CPU
SELECT scheduler_id, current_tasks_count, runnable_tasks_count
FROM sys.dm_os_schedulers
WHERE scheduler_id < 255 

/*
By looking at the results of above query, the number of runnable tasks is generally a nonzero value; 
a nonzero value indicates that tasks have to wait for their time slice to run. 
If the runnable task counts show high values then there is a symptom of CPU bottleneck. 
The above query will also lists all the available schedulers in the SQL Server machine 
and the number of runnable tasks for each scheduler. 
*/

select AVG (runnable_tasks_count) from sys.dm_os_schedulers where status = 'VISIBLE ONLINE'

--Using above TSQL if you get the result greater than 0 (numbers >0) then it means your SQL System is waiting for CPU time to finish that particupar process.
