/******** get missing indexes by db, table and their performance impact ******/
declare @ObjName varchar(30)= 'srf_main.GetTradeDetails'
select distinct 
depid 
into #dep
from sysdepends d, sys.objects o
where d.id = o.object_id
and  o.object_id = object_id(@objname)
and exists
(select '1' from sys.objects
 where object_id = d.depid and type='U')

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
join #dep on o.object_id = #dep.depid
where i1.type <> 0 --table
and S.user_seeks > 0 
--and S.user_seeks = 0 
order by OBJECT_NAME(S.object_id), S.user_seeks + S.user_scans + S.user_lookups

drop table #dep