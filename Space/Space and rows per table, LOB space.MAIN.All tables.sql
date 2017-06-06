--credit
declare @tbl table (tbl varchar(200))

insert @tbl
select schema_name(schema_id)+'.'+name as TblName
from sys.objects as o
where type='U'

SELECT 
    schema_name(t.schema_id)+'.'+t.NAME AS TableName,
    i.name as indexName,
    case i.index_id when 1 then 'clustered index' else 'heap table' end as [Table/Index],
    p.[Rows],
    sum(a.total_pages) as TotalPages, 
    sum(a.used_pages) as UsedPages, 
    sum(a.data_pages) as DataPages,
    isnull((select sum(a1.total_pages)
     from sys.indexes i1 
		INNER JOIN 
     sys.partitions p1
     on i1.object_id = p1.OBJECT_ID AND i1.index_id = p1.index_id 
		INNER JOIN 
    sys.allocation_units a1 ON p1.partition_id = a1.container_id
    where i.object_id = p1.OBJECT_ID AND i.index_id = p1.index_id
    and a1.type = 2
    group by i1.object_id
    ), 0) as TotalLOBpages,
    (sum(a.total_pages) * 8) / 1024 as TotalSpaceMB, 
    (sum(a.used_pages) * 8) / 1024 as UsedSpaceMB, 
    (sum(a.data_pages) * 8) / 1024 as DataSpaceMB
into #t
FROM 
    sys.tables t
INNER JOIN  	
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
WHERE 
    t.NAME NOT LIKE 'dt%' AND
    i.OBJECT_ID > 255 AND 	
    i.index_id <= 1
GROUP BY 
    schema_name(t.schema_id)+'.'+t.NAME, i.object_id, i.index_id, i.name, p.[Rows]
ORDER BY 
    object_name(i.object_id)
    
select TableName,indexName,[Table/Index],
Rows,TotalPages,UsedPages,DataPages,TotalLOBpages,DataSpaceMB,UsedSpaceMB,TotalSpaceMB as TotalSpaceMB_SortedBy , 
case when DataPages > 0 
then cast(round(1.0* Rows/DataPages,2) as numeric(10,2)) else 0 end as RowsPerDataPage,
case when TotalLOBpages > 0 
then cast(round(1.0* Rows/TotalLOBpages,2) as numeric(10,2)) else 0 end as RowsPerLOBpage,
case when TotalSpaceMB > 0 
then cast(round(1.0* Rows/TotalSpaceMB,2) as numeric(10,2)) else 0 end as RowsPerMB
from #t join @tbl
on TableName = tbl
order by TotalSpaceMB_SortedBy desc

-- less details
select @@servername as [SQL Server instance], db_name() as [Database], TableName,
Rows,UsedSpaceMB,TotalSpaceMB
from #t join @tbl
on TableName = tbl
order by TotalSpaceMB desc
	
drop table #t