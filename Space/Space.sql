/* Returns a table with the space used in all tables of the
*  database.  It's reported with the schema information unlike
*  the system procedure sp_spaceuse.
*
*  sp_spaceused is used to perform the calculations to ensure
*  that the numbers match what SQL Server would report.
*
*  Compatible with sQL Server 2000 and 2005
*
* Example:
exec dbo.dba_SpaceUsed null, 'N'
*
* © Copyright 2007 Andrew Novick http://www.NovickSoftware.com
* This software is provided as is without warrentee of any kind.
* You may use this procedure in any of your SQL Server databases
* including databases that you sell, so long as they contain 
* other unrelated database objects. You may not publish this 
* procedure either in print or electronically.
******************************************************************/

/* Returns a table with the space used in all tables of the
*  Database.  It's reported with the schema information unlike
*  the system procedure sp_spaceuse.
*
*  sp_spaceused is used to perform the calculations to ensure
*  that the numbers match what SQL Server would report.
*
*  Compatible with sQL Server 2000 and 2005
*
* Example:
exec dbo.dba_SpaceUsed null, 'N'
*
* © Copyright 2007 Andrew Novick http://www.NovickSoftware.com
* This software is provided as is without warrentee of any kind.
* You may use this procedure in any of your SQL Server Databases
* including Databases that you sell, so long as they contain 
* other unrelated Database objects. You may not publish this 
* procedure either in print or electronically.
******************************************************************/

SET NOCOUNT ON

declare  @SourceDB varchar ( 128 ) -- Optional Database name
         -- If null, the current Database is reported.
		,@SortBy char(1) -- N for name, S for Size
           -- T for table name

set @SourceDB = null
set @SortBy = 'S' 

DECLARE @sql nvarchar (4000)

IF @SourceDB IS NULL BEGIN
	SET @SourceDB = DB_NAME () -- The current DB 
END

--------------------------------------------------------
-- Create and fill a list of the tables in the Database.

CREATE TABLE #Tables (	[schema] sysname
                      , TabName sysname )
		
SELECT @sql = 'insert #Tables ([schema], [TabName]) 
                  select TABLE_schema, TABLE_NAME 
		          from ['+ @SourceDB +'].INFORMATION_schema.TABLES
			          where TABLE_TYPE = ''BASE TABLE'''
EXEC (@sql)


---------------------------------------------------------------
-- #TabSpaceTxt Holds the results of sp_spaceused. 
-- It Doesn't have schema Info!
CREATE TABLE #TabSpaceTxt (
                         TabName sysname
	                   , [Rows] varchar (11)
	                   , Reserved varchar (18)
					   , Data varchar (18)
	                   , Index_Size varchar ( 18 )
	                   , Unused varchar ( 18 )
                       )
					
---------------------------------------------------------------
-- The result table, with numeric results and schema name.
CREATE TABLE #TabSpace ( [schema] sysname
                       , TabName sysname
	                   , [Rows] bigint
	                   , ReservedMB numeric(18,3)
					   , DataMB numeric(18,3)
	                   , Index_SizeMB numeric(18,3)
	                   , UnusedMB numeric(18,3)
                       )

DECLARE @Tab sysname -- table name
      , @Sch sysname -- owner,schema

DECLARE TableCursor CURSOR FOR
    SELECT [schema], TabName 
         FROM #Tables

OPEN TableCursor;
FETCH TableCursor into @Sch, @Tab;

WHILE @@FETCH_STATUS = 0 BEGIN

	SELECT @sql = 'exec [' + @SourceDB 
	   + ']..sp_executesql N''insert #TabSpaceTxt exec sp_spaceused '
	   + '''''[' + @Sch + '].[' + @Tab + ']' + '''''''';

	Delete from #TabSpaceTxt; -- Stores 1 result at a time
	EXEC (@sql);

    INSERT INTO #TabSpace
	SELECT @Sch
	     , [TabName]
         , convert(bigint, Rows)
	     , convert(numeric(18,3), convert(numeric(18,3), 
		        left(Reserved, len(Reserved)-3)) / 1024.0) 
                ReservedMB
	     , convert(numeric(18,3), convert(numeric(18,3), 
		        left(Data, len(Data)-3)) / 1024.0) DataMB
	     , convert(numeric(18,3), convert(numeric(18,3), 
		        left(Index_Size, len(Index_Size)-3)) / 1024.0) 
                 Index_SizeMB
	     , convert(numeric(18,3), convert(numeric(18,3), 
		        left(Unused, len([Unused])-3)) / 1024.0) 
                [UnusedMB]
        FROM #TabSpaceTxt;

	FETCH TableCursor into @Sch, @Tab;
END;

CLOSE TableCursor;
DEALLOCATE TableCursor;

-- Get how amny times tables were accessed since reboot
SELECT OBJECT_NAME(S.object_id)  [Table]
	,sum(S.user_seeks + S.user_scans + S.user_lookups) as accessedTimes#SinceReboot 
into #accessTimes    
FROM sys.dm_db_index_usage_stats S RIGHT JOIN sys.objects O
  ON S.object_id =  O.object_Id
    and S.Database_id = DB_ID()
    and O.type = 'U'
--where OBJECT_NAME(O.object_id) in ('Position', 'PositionXmlFields','ScenarioRate')
group by OBJECT_NAME(S.object_id)

-----------------------------------------------------
-- Caller specifies sort, Default is size
IF @SortBy = 'N' -- Use schema then Table Name
	SELECT s.*, a.accessedTimes#SinceReboot 
		FROM #TabSpace s left join #accessTimes a
		ON s.TabName = a.[Table] 
		ORDER BY [schema] asc, [TabName] asc
ELSE IF @SortBy = 'T'  -- Table name, then schema
	SELECT s.*, a.accessedTimes#SinceReboot 
		FROM #TabSpace s left join #accessTimes a
		ON s.TabName = a.[Table] 
	   ORDER BY [TabName] asc, [schema] asc
ELSE  -- S, NULL, or whatever get's the default
	SELECT s.*, a.accessedTimes#SinceReboot 
		FROM #TabSpace s left join #accessTimes a
		ON s.TabName = a.[Table] 
	   ORDER BY ReservedMB desc
;

DROP TABLE #Tables
DROP TABLE #TabSpaceTxt
DROP TABLE #TabSpace, #accessTimes



