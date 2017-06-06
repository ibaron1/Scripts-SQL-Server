select 
bpool_committed*8/1024.0 as bpool_committed_MB, 
bpool_commit_target*8/1024.0 as bpool_commit_target_MB, 
(bpool_commit_target-bpool_committed)*8/1024.0 as needs_additional_memory_MB  
from sys.dm_os_sys_info

