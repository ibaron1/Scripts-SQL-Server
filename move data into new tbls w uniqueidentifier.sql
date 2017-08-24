set nocount on
go

if object_id('tempdb.dbo.#t') is not null
  drop table #t

select * into #t
from order_activity
where 1=2

DECLARE @count INT = 200000;

WHILE @count > 0
BEGIN
  delete TOP (@count) 
  from order_activity
  output deleted.* into #t
  --where db_update_time >= '06-06-2017'

  SET @count = @@ROWCOUNT 

  INSERT INTO [dbo].[order_activity1]
           ([id]
           ,[order_id]
           ,[version_num]
           ,[ex_dest]
           ,[order_status]
           ,[order_msg]
           ,[action_type]
           ,[action_by]
           ,[db_update_time])
  select newid(), * from #t

  truncate table #t

END  

set nocount on
go

if object_id('tempdb.dbo.#t') is not null
  drop table #t

select * into #t
from order_summary
where 1=2

DECLARE @count INT = 200000;

WHILE @count > 0
BEGIN
  delete TOP (@count) 
  from order_summary
  output deleted.* into #t
  --where db_update_time >= '06-06-2017'

  SET @count = @@ROWCOUNT 
 
  INSERT INTO [dbo].[order_summary1]
           ([id]
           ,[order_id]
           ,[root_id]
           ,[parent_id]
           ,[version_num]
           ,[asset_class]
           ,[source_id]
           ,[ex_dest]
           ,[account]
           ,[symbol]
           ,[side]
           ,[order_status]
           ,[cum_qty]
           ,[trade_date]
           ,[ord_entry_time]
           ,[db_update_time]
           ,[avg_price]
           ,[exec_count])
  select newid(), * from #t

  truncate table #t

END  

set nocount on
go

if object_id('tempdb.dbo.#t') is not null
  drop table #t

select * into #t
from exec_activity
where 1=2

DECLARE @count INT = 200000;

WHILE @count > 0
BEGIN
  delete TOP (@count) 
  from exec_activity
  output deleted.* into #t
  --where db_update_time >= '06-06-2017'

  SET @count = @@ROWCOUNT 
 
  INSERT INTO [dbo].[exec_activity1]
          ([id]
           ,[order_id]
           ,[version_num]
           ,[exec_id]
           ,[dest_id]
           ,[qty]
           ,[price]
           ,[exec_msg]
           ,[db_update_time])
  select newid(), * from #t

  truncate table #t

END  

