
-- To clear the cache

DBCC FREEPROCCACHE -- for all databases on an instance


DBCC FLUSHPROCINDB -- for a single database

--Determine the id of your database
DECLARE @intDBID INTEGER
SET @intDBID = ( SELECT dbid
FROM master.dbo.sysdatabases
WHERE name = 'mydatabasename'
)
--Flush the procedure cache for your database
DBCC FLUSHPROCINDB (@intDBID)