select name as [Table]
from sysobjects o
where type='U'
and not exists
(SELECT '1'
 FROM sys.dm_db_index_usage_stats S JOIN sys.indexes I
  ON S.index_id= I.index_id 
  and S.object_id =  I.object_Id
  and s.database_id = DB_ID()
  and S.user_seeks + S.user_scans + S.user_lookups > 0
  and OBJECT_NAME(S.object_id) = o.name)
and name <> 'dtproperties'
order by name