select max(last_execution_time)
from sys.dm_exec_query_stats
where last_execution_time < DATEADD(hh, -1, getdate())