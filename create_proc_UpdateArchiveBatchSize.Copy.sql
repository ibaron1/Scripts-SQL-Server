USE TFM_Archive
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if object_id('tfm.ModifyArchiveBatchSize') is not null
  drop proc tfm.ModifyArchiveBatchSize
go

/***************************************************************************
Author. Eli Baron
Date created. 08-11-2017
Purpose. Jira WMTRACAPGO-336, update ArchiveBatchSize for the archived table
***************************************************************************/
create proc tfm.ModifyArchiveBatchSize
@workflowId int,
@Tbl varchar(128),
@ArchivingBatchSize int
as
set nocount on
set implicit_transactions off
set transaction isolation level read uncommitted

update tfm.DataArchivingAndPurgingConfig
set ArchivingBatchSize = @ArchivingBatchSize
where workflowId = workflowId and Tbl = @Tbl

go
