SELECT DB_NAME(dbid) as DbName,
ISNULL(OBJECT_NAME(objectid,dbid), 'ad hoc') as ObjectName,
usecounts, size_in_bytes
, cacheobjtype, objtype, [text]
FROM sys.dm_exec_cached_plans P
   CROSS APPLY sys.dm_exec_sql_text(plan_handle)
WHERE cacheobjtype in ('Compiled Plan', 'Compiled Plan Stub')
  AND [text] NOT LIKE '%dm_exec_cached_plans%'
ORDER BY cacheobjtype

SELECT 
sum(usecounts) as total_usecounts, sum(size_in_bytes) as total_size_in_bytes
, cacheobjtype, objtype
FROM sys.dm_exec_cached_plans
  CROSS APPLY sys.dm_exec_sql_text(plan_handle)
WHERE cacheobjtype in ('Compiled Plan', 'Compiled Plan Stub')
  AND [text] NOT LIKE '%dm_exec_cached_plans%'
--GROUP BY cacheobjtype, objtype
GROUP BY ROLLUP (cacheobjtype, objtype)
 
