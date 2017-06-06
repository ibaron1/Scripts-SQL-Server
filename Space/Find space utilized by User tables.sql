-- Total space used for database
select SUM([Total Space Used in MB]) as [Space Used in MB]
from
(
SELECT 
--[Table Name], 
--(SELECT ROWS FROM sysindexes S WHERE S.Indid < 2 AND S.ID = OBJECT_ID(a.[Table Name])) AS [Total Rows], 
[Total Space Used in MB] FROM  
(SELECT schema_name(so.schema_id) + '.' + OBJECT_NAME(si.id) AS [Table Name],
CONVERT(Numeric(15,2),(((CONVERT(Numeric(15,2),SUM(si.Reserved)) * (SELECT low FROM master.dbo.spt_values (NOLOCK) WHERE number = 1 AND type = 'E')) / 1024.)/1024.)) AS [Total Space Used in MB]
FROM sysindexes si (NOLOCK) INNER JOIN sys.objects so --(NOLOCK) 
ON    si.id = so.object_id AND so.type IN ('U')
WHERE indid IN (0, 1, 255)
GROUP BY schema_name(so.schema_id) + '.' + OBJECT_NAME(si.id)
) as a
) as t



declare @tbl_space table
(
	[Table Name] [nvarchar](517) NULL,
	[Total Rows] [int] NULL,
	[Total Space Used in MB] [numeric](15, 2) NULL
)

insert @tbl_space
SELECT [Table Name], (SELECT ROWS FROM sysindexes S WHERE S.Indid < 2 AND S.ID = OBJECT_ID(a.[Table Name])) AS [Total Rows], [Total Space Used in MB] FROM  
(SELECT schema_name(so.schema_id) + '.' + OBJECT_NAME(si.id) AS [Table Name],
CONVERT(Numeric(15,2),(((CONVERT(Numeric(15,2),SUM(si.Reserved)) * (SELECT low FROM master.dbo.spt_values (NOLOCK) WHERE number = 1 AND type = 'E')) / 1024.)/1024.)) AS [Total Space Used in MB]
FROM sysindexes si (NOLOCK) INNER JOIN sys.objects so (NOLOCK) 
ON    si.id = so.object_id AND so.type IN ('U')
WHERE indid IN (0, 1, 255)
GROUP BY schema_name(so.schema_id) + '.' + OBJECT_NAME(si.id)
) as a
ORDER BY [Total Space Used in MB] DESC

select * from @tbl_space
  union
select 'TOTAL',sum([Total Rows]),sum([Total Space Used in MB])
from @tbl_space
order by 3 desc

/****** find space for specific tables *******/

declare @tbl table (tbl varchar(200))

insert @tbl
values('srf_main.GTRException')
,('srf_main.TradeMessagePayload')
,('srf_main.TradeMessage')
,('srf_main.Trade')
,('srf_main.Exception')
,('srf_main.EODBusinessexception')
,('srf_main.EODTradeStage')
,('srf_main.EODTradeStatus')
,('srf_main.BCPGTRResponseData')
,('srf_main.EODTrade')

declare @tbl_space_before_delete table
(
	[Table Name] [nvarchar](517) NULL,
	[Total Rows] [int] NULL,
	[Total Space Used in MB] [numeric](15, 2) NULL
)

declare @tbl_space_after_delete table
(
	[Table Name] [nvarchar](517) NULL,
	[Total Rows] [int] NULL,
	[Total Space Used in MB] [numeric](15, 2) NULL
)

insert @tbl_space_before_delete
SELECT [Table Name], (SELECT ROWS FROM sysindexes S WHERE S.Indid < 2 AND S.ID = OBJECT_ID(a.[Table Name])) AS [Total Rows], [Total Space Used in MB] FROM  
(SELECT schema_name(so.schema_id) + '.' + OBJECT_NAME(si.id) AS [Table Name],
CONVERT(Numeric(15,2),(((CONVERT(Numeric(15,2),SUM(si.Reserved)) * (SELECT low FROM master.dbo.spt_values (NOLOCK) WHERE number = 1 AND type = 'E')) / 1024.)/1024.)) AS [Total Space Used in MB]
FROM sysindexes si (NOLOCK) INNER JOIN sys.objects so (NOLOCK) 
ON    si.id = so.object_id AND so.type IN ('U')
WHERE indid IN (0, 1, 255)
GROUP BY schema_name(so.schema_id) + '.' + OBJECT_NAME(si.id)
) as a
join @tbl b
on a.[Table Name] = b.tbl

select * from @tbl_space_before_delete
  union
select 'TOTAL',sum([Total Rows]),sum([Total Space Used in MB])
from @tbl_space_before_delete 


