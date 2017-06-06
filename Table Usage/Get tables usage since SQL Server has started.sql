USE riskworld
go
SELECT DISTINCT OBJECT_NAME(S.object_id)  [Table]
	,S.user_seeks + S.user_scans + S.user_lookups as accessedTimes#     
    ,S.user_seeks
    ,S.user_scans
    ,S.user_lookups
FROM sys.dm_db_index_usage_stats S RIGHT JOIN sys.objects O
  ON S.object_id =  O.object_Id
    and s.database_id = DB_ID()
    and S.object_Id is not null and O.object_Id is not null
    and O.type = 'U'
and (S.user_seeks >= 0 
    or S.user_scans >= 0
    or S.user_lookups >= 0)
and not (S.user_seeks = 0 and S.user_scans = 0 and S.user_lookups = 0)
order by accessedTimes# desc