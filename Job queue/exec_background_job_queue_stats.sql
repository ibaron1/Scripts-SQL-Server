select * from sys.dm_exec_background_job_queue_stats 

-- the percentage of failed background jobs for all executed queries.

SELECT 
        CASE ended_count WHEN 0 
                THEN 'No jobs ended' 
                ELSE CAST((failed_lock_count + failed_giveup_count + failed_other_count) / CAST(ended_count AS float) * 100 AS varchar(20)) 
        END AS [Percent Failed]
FROM sys.dm_exec_background_job_queue_stats;

-- the percentage of failed enqueue attempts for all executed queries.

SELECT 
        CASE enqueued_count WHEN 0 
                THEN 'No jobs posted' 
                ELSE CAST((enqueue_failed_full_count + enqueue_failed_duplicate_count) / CAST(enqueued_count AS float) * 100 AS varchar(20)) 
        END AS [Percent Enqueue Failed]
FROM sys.dm_exec_background_job_queue_stats;
GO



/*
Returns a row that provides aggregate statistics for each query processor job submitted for asynchronous (background) execution. 

Column name  Data type  Description  
queue_max_len 
 int 
 Maximum length of the queue.
 
enqueued_count 
 int 
 Number of requests successfully posted to the queue.
 
started_count 
 int 
 Number of requests that started execution.
 
ended_count 
 int 
 Number of requests serviced to either success or failure.
 
failed_lock_count 
 int 
 Number of requests that failed due to lock contention or deadlock.
 
failed_other_count 
 int 
 Number of requests that failed due to other reasons.
 
failed_giveup_count 
 int 
 Number of requests that failed because retry limit has been reached.
 
enqueue_failed_full_count 
 int 
 Number of failed enqueue attempts because the queue is full.
 
enqueue_failed_duplicate_count 
 int 
 Number of duplicate enqueue attempts.
 
elapsed_avg_ms 
 int 
 Average elapsed time of request in milliseconds.
 
elapsed_max_ms 
 int 
 Elapsed time of the longest request in milliseconds.

http://msdn.microsoft.com/en-us/library/ms176059.aspx
*/

