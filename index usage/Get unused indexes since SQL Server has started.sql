-- all database indexes that were used

SELECT DB_NAME() AS DB, OBJECT_NAME(S.object_id) AS Object_Name
    ,isnull(i1.name,'') Index_Name 
    ,CASE WHEN i1.type = 0 THEN 'Heap'
	  WHEN i1.type = 1 THEN 'Clustered' 
          WHEN i1.type = 2 THEN 'Non-Clustered'
          WHEN i1.type = 3 THEN 'XML'  
          ELSE 'N/A' END AS Index_Type 
	,S.user_seeks + S.user_scans + S.user_lookups AS accessedTimes#     
    ,S.user_seeks
    ,S.user_scans
    ,S.user_lookups
    ,rows
    ,cast(round(reserved*8/1024.0,0) as int) as reserved_MB 
	,cast(round(reserved*8/1024.0,0) as int) as used_MB 
FROM sys.dm_db_index_usage_stats S JOIN sysindexes I 
  ON S.index_id= I.indid 
 and S.object_id =  I.id
 and s.database_id = DB_ID()
join sys.indexes i1
on I.id = i1.object_id and I.indid = i1.index_id
join sys.objects o
on o.object_Id = I.id and o.type = 'U'
where i1.type <> 0 --table
--and S.user_seeks > 0 
and S.user_seeks = 0 
order by OBJECT_NAME(S.object_id), S.user_seeks + S.user_scans + S.user_lookups


/************** index usage for a table ******************/

-- all database indexes that were used

SELECT DB_NAME() AS DB, OBJECT_NAME(S.object_id) AS Object_Name
    ,isnull(i1.name,'') Index_Name 
    ,CASE WHEN i1.type = 0 THEN 'Heap'
	  WHEN i1.type = 1 THEN 'Clustered' 
          WHEN i1.type = 2 THEN 'Non-Clustered'
          WHEN i1.type = 3 THEN 'XML'  
          ELSE 'N/A' END AS Index_Type 
	,S.user_seeks + S.user_scans + S.user_lookups AS accessedTimes#     
    ,S.user_seeks
    ,S.user_scans
    ,S.user_lookups
    ,rows
    ,cast(round(reserved*8/1024.0,0) as int) as reserved_MB 
	,cast(round(reserved*8/1024.0,0) as int) as used_MB 
FROM sys.dm_db_index_usage_stats S JOIN sysindexes I 
  ON S.index_id= I.indid 
 and S.object_id =  I.id
 and s.database_id = DB_ID()
join sys.indexes i1
on I.id = i1.object_id and I.indid = i1.index_id
join sys.objects o
on o.object_Id = I.id and o.type = 'U'
where OBJECT_NAME(S.object_id) = 'EODTrade' and
i1.type <> 0 --table
--and S.user_seeks > 0 
--and S.user_seeks = 0 
order by OBJECT_NAME(S.object_id), S.user_seeks + S.user_scans + S.user_lookups
