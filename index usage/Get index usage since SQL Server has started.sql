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
    ,reserved*8/1024.0 as reserved_MB 
	,used*8/1024.0 as used_MB
FROM sys.dm_db_index_usage_stats S JOIN sysindexes I 
  ON S.index_id= I.indid 
 and S.object_id =  I.id
 and s.database_id = DB_ID()
and S.user_seeks + S.user_scans + S.user_lookups > 0 
join sys.indexes i1
on I.id = i1.object_id and I.indid = i1.index_id
join sys.objects o
on o.object_Id = I.id and o.type = 'U'
where i1.type <> 0 --table
OBJECT_NAME(S.object_id) in /* and ('ollEagleDetailsMain','CollFileMaster','CollPrincipalPartyDetails','CollSecurePartyMetaData','CollCtyPartyDetails')*/
order by OBJECT_NAME(S.object_id), S.user_seeks + S.user_scans + S.user_lookups


-- all database indexes that were or were not used

SELECT DB_NAME() AS DB, OBJECT_NAME(S.object_id) AS Object_Name
    ,isnull(I.name,'') Index_Name 
    ,CASE WHEN I.type = 0 THEN 'Heap'
	  WHEN I.type = 1 THEN 'Clustered' 
          WHEN I.type = 2 THEN 'Non-Clustered'
          WHEN I.type = 3 THEN 'XML'  
          ELSE 'N/A' END AS Index_Type 
	,S.user_seeks + S.user_scans + S.user_lookups AS accessedTimes#     
    ,S.user_seeks
    ,S.user_scans
    ,S.user_lookups
FROM sys.dm_db_index_usage_stats S JOIN sys.indexes I
  ON S.index_id= I.index_id 
 and S.object_id =  I.object_Id
 and s.database_id = DB_ID()
--and S.user_seeks + S.user_scans + S.user_lookups > 0 
--order by accessedTimes# desc
--order by OBJECT_NAME(S.object_id), I.name
join sys.objects o
on o.object_Id = I.object_Id and o.type = 'U'
order by S.user_seeks + S.user_scans + S.user_lookups

-- all specific table indexes that were or were not used

SELECT DB_NAME() AS DB, OBJECT_NAME(S.object_id) AS Object_Name
    ,isnull(I.name,'') Index_Name 
    ,CASE WHEN I.type = 0 THEN 'Heap'
	  WHEN I.type = 1 THEN 'Clustered' 
          WHEN I.type = 2 THEN 'Non-Clustered'
          WHEN I.type = 3 THEN 'XML'  
          ELSE 'N/A' END AS Index_Type 
	,S.user_seeks + S.user_scans + S.user_lookups AS accessedTimes#     
    ,S.user_seeks
    ,S.user_scans
    ,S.user_lookups
FROM sys.dm_db_index_usage_stats S JOIN sys.indexes I
  ON S.index_id= I.index_id 
 and S.object_id =  I.object_Id
 and s.database_id = DB_ID()
--and S.user_seeks + S.user_scans + S.user_lookups > 0 
and S.object_id = object_id('srf_main.BCPValAgg')
--order by accessedTimes# desc
--order by OBJECT_NAME(S.object_id), I.name
join sys.objects o
on o.object_Id = I.object_Id and o.type = 'U'
order by S.user_seeks + S.user_scans + S.user_lookups


