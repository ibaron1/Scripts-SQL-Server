-- http://msdn.microsoft.com/en-us/library/ms366321.aspx
select * from sys.dm_exec_query_resource_semaphores 

-- http://msdn.microsoft.com/en-us/library/ms175019.aspx
select * from sys.dm_os_memory_clerks


select * from sys.dm_os_memory_brokers

select * from Sys.dm_os_memory_clerks

select ring_buffer_type, count(*) 
from Sys.dm_os_ring_buffers
where ring_buffer_type in ('RING_BUFFER_RESOURCE_MONITOR','RING_BUFFER_OOM','RING_BUFFER_MEMORY_BROKER','RING_BUFFER_BUFFER_POOL')
group by ring_buffer_type

