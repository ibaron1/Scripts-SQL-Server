/*
Page life expectancy, free list stalls/sec, lazy writes/sec, stolen pages are much more useful indicators of memory pressure.

For per-second counters, this value is cumulative. The rate value must be calculated by sampling the value at discrete time intervals. 
The difference between any two successive sample values is equal to the rate for the time interval used.

You need to measure it twice in succession and the difference is the hit rate:

http://www.sqlservercentral.com/Forums/Topic479850-360-1.aspx

One of the people who replied posted some code showing how to obtain the percentage value:
*/

/*
http://www.sql-server-performance.com/articles/per/sys_dm_os_performance_counters_p1.aspx
The buffer cache hit ratio value measures how well your pages are staying in the buffer cache.  
The closer the buffer cache hit ratio is to 100 % the better your buffer cache is being utilized, and the better performance you will get out of your SQL Server.   
Here is how you would use this DMV to calculate the buffer cache hit ratio:
*/

SELECT (a.cntr_value * 1.0 / b.cntr_value) * 100.0 [BufferCacheHitRatio] 
FROM (SELECT *, 1 x FROM sys.dm_os_performance_counters
        WHERE counter_name = 'Buffer cache hit ratio'
          AND object_name = 'SQLServer:Buffer Manager') a   
     JOIN
     (SELECT *, 1 x FROM sys.dm_os_performance_counters  
        WHERE counter_name = 'Buffer cache hit ratio base'
          and object_name = 'SQLServer:Buffer Manager') b
ON a.x = b.x


-- same as above but with round and not in %  Buffer_Cache_Hit_Ratio ; this counter should be as close to 100% as possible
SELECT ROUND(CAST(A.cntr_value1 AS NUMERIC) / CAST(B.cntr_value2 AS NUMERIC),3) AS Buffer_Cache_Hit_Ratio
FROM 
(
SELECT cntr_value AS cntr_value1
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Buffer Manager'
AND counter_name = 'Buffer cache hit ratio'
) AS A,
(
SELECT cntr_value AS cntr_value2
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Buffer Manager'
AND counter_name = 'Buffer cache hit ratio base'
) AS B;


/*******************************************/
SELECT cntr_value AS 'Page Life Expectancy'
FROM sys.dm_os_performance_counters
WHERE object_name = 'SQLServer:Buffer Manager'
AND counter_name = 'Page life expectancy' 





