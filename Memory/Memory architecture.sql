select 
      CASE count( DISTINCT parent_node_id)
      WHEN 1 THEN 'NUMA disabled'
      ELSE 'NUMA enabled'
      END
from
      sys.dm_os_schedulers
where parent_node_id <> 32
