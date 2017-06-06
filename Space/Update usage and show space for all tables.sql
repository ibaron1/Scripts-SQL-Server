SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--DBCC UPDATEUSAGE(0) 

DECLARE @t TABLE 
( 
id INT, 
SchemaName VARCHAR(64),
TableName VARCHAR(64), 
NRows INT, 
Total FLOAT,
Reserved FLOAT, 
TableSize FLOAT, 
IndexSize FLOAT, 
FreeSpace FLOAT,
LobUsed FLOAT,
LobTotal FLOAT
) 

INSERT @t EXEC sp_msForEachTable 'SELECT 
OBJECT_ID(''?''), 
PARSENAME(''?'', 2), 
PARSENAME(''?'', 1), 
COUNT(*),0,0,0,0,0,0,0 FROM ?' 

DECLARE @low INT 

SELECT @low = [low] FROM master.dbo.spt_values 
WHERE number = 1 
AND type = 'E' 

UPDATE @t 
SET Reserved = x.r, 
IndexSize = x.i 
FROM @t T INNER JOIN (
SELECT id, r = SUM(si.reserved), i = SUM(si.used) 
FROM sysindexes si 
WHERE si.indid IN (0, 1, 255) 
GROUP BY id
) x ON x.id = T.id 

UPDATE @t SET TableSize = (
SELECT SUM(si.dpages) 
FROM sysindexes si 
WHERE si.indid < 2 
AND si.id = T.id
) 
FROM @T T

UPDATE @t
SET TableSize = TableSize + (
SELECT COALESCE(SUM(used), 0) 
FROM sysindexes si 
WHERE si.indid = 255 
AND si.id = T.id
) 
FROM @t T

UPDATE @t SET FreeSpace = Reserved - IndexSize 

UPDATE @t SET IndexSize = IndexSize - TableSize 

UPDATE @t 
SET LobUsed = u.used_pages,
LobTotal = u.total_pages
FROM @t T 
INNER JOIN sys.partitions p ON T.id = p.object_id
INNER JOIN sys.allocation_units u ON u.container_id = p.partition_id
WHERE u.type = 2

UPDATE @t SET Total = Reserved + LobTotal

SELECT @@SERVERNAME as instance, DB_NAME() as dbname,
schemaname,
tablename, 
nrows, 
Total = LTRIM(STR( 
total * @low / 1024.,15,0) + 
' ' + 'KB'), 
Reserved = LTRIM(STR( 
reserved * @low / 1024.,15,0) + 
' ' + 'KB'), 
DataSize = LTRIM(STR( 
tablesize * @low / 1024.,15,0) + 
' ' + 'KB'), 
IndexSize = LTRIM(STR( 
indexSize * @low / 1024.,15,0) + 
' ' + 'KB'), 
LobUsedSpace = LTRIM(STR( 
LobUsed * @low / 1024.,15,0) + 
' ' + 'KB'),
LobTotalSpace = LTRIM(STR( 
LobTotal * @low / 1024.,15,0) + 
' ' + 'KB'),
FreeSpace = LTRIM(STR( 
freeSpace * @low / 1024.,15,0) + 
' ' + 'KB'), 
Total AS Sort
FROM @t 
ORDER BY Sort DESC 

SELECT @@SERVERNAME as instance, DB_NAME() as dbname,
nrows = SUM(nrows),
Total = LTRIM(STR( 
SUM(total) * @low / 1024.,15,0) + 
' ' + 'KB'), 
Reserved = LTRIM(STR( 
SUM(reserved) * @low / 1024.,15,0) + 
' ' + 'KB'), 
DataSize = LTRIM(STR( 
SUM(tablesize) * @low / 1024.,15,0) + 
' ' + 'KB'), 
IndexSize = LTRIM(STR( 
SUM(indexSize) * @low / 1024.,15,0) + 
' ' + 'KB'), 
FreeSpace = LTRIM(STR( 
SUM(freeSpace) * @low / 1024.,15,0) + 
' ' + 'KB') 
FROM @t 

GO