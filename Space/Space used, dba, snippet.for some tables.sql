
SET NOCOUNT ON

--------------------------------------------------------
-- Create and fill a list of the tables in the database.

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

declare @Tables table ([schema] sysname,TabName sysname)
		
insert @Tables ([schema], TabName) 
select TABLE_SCHEMA, TABLE_NAME 
from INFORMATION_SCHEMA.TABLES a
join @tbl b
on a.TABLE_SCHEMA+'.'+TABLE_NAME = b.tbl
where a.TABLE_TYPE = 'BASE TABLE'
  
declare @TabSpace table  
(TabName sysname
,[Rows] bigint
,Reserved varchar(38)
,Data varchar(38)
,Index_Size varchar(38)
,Unused varchar(38)
)

declare @TabSpaceFinal table  
( [Schema] sysname
,TabName sysname
,[Rows] bigint
,ReservedMB numeric(18,3)
,DataMB numeric(18,3)
,Index_SizeMB numeric(18,3)
,UnusedMB numeric(18,3)
)


declare @sqlcmd varchar(200)
  
declare @schema sysname, @TabName sysname

declare TableCursor cursor for
select [schema],TabName from @Tables

open TableCursor

while 1=1
begin
  fetch TableCursor into @schema,@TabName 
  if @@fetch_status  <> 0
    break
    
  set @sqlcmd = 'sp_spaceused '+''''+@schema+'.'+@TabName+''''
print @sqlcmd

  insert @TabSpace  
  exec (@sqlcmd)

  insert @TabSpaceFinal
  select @schema, TabName
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
  from @TabSpace
  
  delete @TabSpace
  
end

close TableCursor;
deallocate TableCursor;

select * from @TabSpaceFinal
order by [Schema] ,TabName
