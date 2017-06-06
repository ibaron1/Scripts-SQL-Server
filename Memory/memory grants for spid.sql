use master
go
select 
case is_next_candidate 
when 1 then 'Yes'
when 0 then 'No'
when NULL then 'Memory is already granted' end as isMemoryGranted,
* 
from sys.dm_exec_query_memory_grants 