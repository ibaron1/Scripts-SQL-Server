/*
Memory Grants Pending
The Memory Grants Pending counter represents the number of processes pending for a memory grant within
SQL Server memory. If this counter value is high, then SQL Server is short of memory. Under normal conditions,
this counter value should consistently be 0 for most production servers.
Another way to retrieve this value, on the fly, is to run queries against the DMV sys.dm_exec_query_memory_grants .
 A null value in the column grant_time indicates that the process is still waiting for a memory grant.
This is one method you can use to troubleshoot
"SQL Server 2012 Query Performance Tuning', page 25
*/


select * from sys.dm_exec_query_memory_grants