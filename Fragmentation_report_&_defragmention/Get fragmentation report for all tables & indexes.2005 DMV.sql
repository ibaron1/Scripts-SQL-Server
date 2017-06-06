use riskworld -- riskbook logger70
go
/**********************************************************************************************************************************************************************************************************************************************
The sys.dm_db_index_physical_stats dynamic management function replaces the DBCC SHOWCONTIG statement. This dynamic management function does not accept correlated parameters from CROSS APPLY and OUTER APPLY.
Scanning Modes
The mode in which the function is executed determines the level of scanning performed to obtain the statistical data that is used by the function. mode is specified as LIMITED, SAMPLED, or DETAILED. The function traverses the page chains for the allocation units that make up the specified partitions of the table or index. sys.dm_db_index_physical_stats requires only an Intent-Shared (IS) table lock, regardless of the mode that it runs in. For more information about locking, see Lock Modes. 
The LIMITED mode is the fastest mode and scans the smallest number of pages. For an index, only the parent-level pages of the B-tree (that is, the pages above the leaf level) are scanned. For a heap, only the associated PFS and IAM pages are examined; the data pages of the heap are not scanned. In SQL Server 2005, all pages of a heap are scanned in LIMITED mode. 
With LIMITED mode, compressed_page_count is NULL because the Database Engine only scans non-leaf pages of the B-tree and the IAM and PFS pages of the heap. 
Use SAMPLED mode to get an estimated value for compressed_page_count, and use DETAILED mode to get the actual value for compressed_page_count..
The SAMPLED mode returns statistics based on a 1 percent sample of all the pages in the index or heap. If the index or heap has fewer than 10,000 pages, DETAILED mode is used instead of SAMPLED. 
The DETAILED mode scans all pages and returns all statistics. 
The modes are progressively slower from LIMITED to DETAILED, because more work is performed in each mode. To quickly gauge the size or fragmentation level of a table or index, use the LIMITED mode. 
It is the fastest and will not return a row for each nonleaf level in the IN_ROW_DATA allocation unit of the index.
Using System Functions to Specify Parameter Values
You can use the Transact-SQL functions DB_ID and OBJECT_ID to specify a value for the database_id and object_id parameters. 
However, passing values that are not valid to these functions may cause unintended results. 
For example, if the database or object name cannot be found because they do not exist or are spelled incorrectly, both functions will return NULL. The sys.dm_db_index_physical_stats function interprets NULL as a wildcard value specifying all databases or all objects. 
Additionally, the OBJECT_ID function is processed before the sys.dm_db_index_physical_stats function is called and is therefore evaluated in the context of the current database, not the database specified in database_id. 
This behavior may cause the OBJECT_ID function to return a NULL value; or, if the object name exists in both the current database context and the specified database, an error message may be returned. 
The following examples demonstrate these unintended results. 
See http://msdn.microsoft.com/en-us/library/ms188917.aspx
**********************************************************************************************************************************************************************************************************************************************/
declare @dbid int
set @dbid = db_id()

select db_name(database_id) dbname, object_id, index_id, index_type_desc, 
alloc_unit_type_desc,			--Description of the allocation unit type: IN_ROW_DATA, LOB_DATA, ROW_OVERFLOW_DATA
index_depth,					--Number of index levels 
index_level,					--Current level of the index: 0 for index leaf levels, heaps, and LOB_DATA or ROW_OVERFLOW_DATA allocation units.
								--Greater than 0 for nonleaf index levels. index_level will be the highest at the root level of an index. 
avg_fragmentation_in_percent,	--Logical fragmentation for indexes, or extent fragmentation for heaps in the IN_ROW_DATA allocation unit. 
								--The value is measured as a percentage and takes into account multiple files.
								-- 0 for LOB_DATA and ROW_OVERFLOW_DATA allocation units.
								-- NULL for heaps when mode = SAMPLED.
fragment_count,					--Number of fragments in the leaf level of an IN_ROW_DATA allocation unit. 
								--NULL for nonleaf levels of an index, and LOB_DATA or ROW_OVERFLOW_DATA allocation units. 
avg_fragment_size_in_pages,		--Average number of pages in one fragment in the leaf level of an IN_ROW_DATA allocation unit.
								--NULL for nonleaf levels of an index, and LOB_DATA or ROW_OVERFLOW_DATA allocation units.
								--NULL for heaps when mode = SAMPLED.
page_count,						--Total number of index or data pages.
								--For an index, the total number of index pages in the current level of the b-tree in the IN_ROW_DATA allocation unit.
								--For a heap, the total number of data pages in the IN_ROW_DATA allocation unit.
								--For LOB_DATA or ROW_OVERFLOW_DATA allocation units, total number of pages in the allocation unit.
avg_page_space_used_in_percent,	--Average percentage of available data storage space used in all pages.
								--For an index, average applies to the current level of the b-tree in the IN_ROW_DATA allocation unit.
								--For a heap, the average of all data pages in the IN_ROW_DATA allocation unit.
								--For LOB_DATA or ROW_OVERFLOW DATA allocation units, the average of all pages in the allocation unit.
								--NULL when mode = LIMITED. 
record_count,					--Total number of records
								--For an index, total number of records applies to the current level of the b-tree in the IN_ROW_DATA allocation unit.
								--For a heap, the total number of records in the IN_ROW_DATA allocation unit. 
forwarded_record_count			--Number of records in a heap that have forward pointers to another data location. (This state occurs during an update, when there is not enough room to store the new row in the original location.)
								--NULL for any allocation unit other than the IN_ROW_DATA allocation units for a heap or for heaps when mode = LIMITED.			
into #indexstats
from sys.dm_db_index_physical_stats(@dbid, NULL, NULL, NULL, 'DETAILED')

select dbname as [Database], object_name(i.object_id) AS TableName,
i.name AS IndexName,
index_type_desc, alloc_unit_type_desc, index_depth, index_level, avg_fragmentation_in_percent, fragment_count, avg_fragment_size_in_pages, page_count,
avg_page_space_used_in_percent, record_count, forwarded_record_count
from #indexstats indexstats left join  sys.indexes i 
on i.object_id = indexstats.OBJECT_ID
and i.index_id = indexstats.index_id
where indexstats.avg_fragmentation_in_percent > 0

--drop table #indexstats
go

