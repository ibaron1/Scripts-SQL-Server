USE TFM_Archive
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if object_id('tfm.OnBoardTblArchiving') is not null
  drop proc tfm.OnBoardTblArchiving
go

/******************************************************************************************************
Author. Eli Baron
Date created. 08-11-2017
Purpose. Jira WMTRACAPGO-336, onboard data archiving for a workflow/application
@ArchivingBatchSize for all tables is set the same; it can be modified using SP ModifyArchiveBatchSize
******************************************************************************************************/
create proc tfm.OnBoardTblArchiving
 @product varchar(100)
,@channel varchar(100)
,@touchpoint varchar(100)
,@operation varchar(100)
,@mode varchar(100)
,@version int
,@AppDataType varchar(20) = 'TFM' 
,@RetentionDays int = 30
,@RetentionDaysForArchiving int = 90
,@ArchivingBatchSize int = 100000 
as
set nocount on
set implicit_transactions off
set transaction isolation level read uncommitted

declare @tblname table(tblname varchar(100))
insert @tblname
values
('Request'),
('Step'),
('Activity'),
('Payload'),
('RequestKeyAttributes')

insert tfm.DataArchivingAndPurgingConfig
(DbName
,DbArchivingName
,AppDataType
,workflowId
,Tbl
,RetentionDays
,RetentionDaysForArchiving
,ArchivingBatchSize)
select 
 db_name()
,db_name()+'_Archive'
,@AppDataType
,w.workflowId
,t.tblname
,@RetentionDays
,@RetentionDaysForArchiving
,@ArchivingBatchSize
from TFM.tfm.Workflow as w
cross join @tblname as t 
where w.product = @product and w.channel = @channel and w.touchpoint = @touchpoint and w.operation = @operation and w.mode = @mode and w.version = @version
and not exists
(select '1' from tfm.DataArchivingAndPurgingConfig as cfg
 cross apply tfm.fn_GetItemsFromList(cfg.tbl,'.') tablename
 where  cfg.workflowId = w.workflowId and tablename.Item = t.tblname)

GO