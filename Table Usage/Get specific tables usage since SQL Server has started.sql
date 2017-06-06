SELECT DISTINCT OBJECT_NAME(S.object_id)  [Table]
	,sum(S.user_seeks + S.user_scans + S.user_lookups) as accessedTimes#     
FROM sys.dm_db_index_usage_stats S RIGHT JOIN sys.objects O
  ON S.object_id =  O.object_Id
    and s.database_id = DB_ID()
    and O.type = 'U'
where OBJECT_NAME(O.object_id) in ('Position', 'PositionXmlFields')
group by OBJECT_NAME(S.object_id)