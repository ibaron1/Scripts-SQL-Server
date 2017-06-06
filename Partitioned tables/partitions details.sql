SELECT o.name AS table_name, au.type_desc AS allocation_type, au.data_pages, p.rows, partition_number
FROM sys.allocation_units AS au
    JOIN sys.partitions AS p ON au.container_id = p.partition_id
    JOIN sys.objects AS o ON p.object_id = o.object_id
    JOIN sys.indexes AS i ON p.index_id = i.index_id AND i.object_id = p.object_id
WHERE o.type = 'U' and partition_number > 1
--and o.name = N'srf_main.BCPValAgg' 
ORDER BY o.name, p.index_id
