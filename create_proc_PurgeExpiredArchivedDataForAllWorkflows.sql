use TFM_Archive
go


if object_id('tfm.PurgeExpiredArchivedDataForAllWorkflows') is not null
  drop proc tfm.PurgeExpiredArchivedDataForAllWorkflows
go

/******************************************************************
Author. Eli Baron
Date created. 8-22-17
Purpose. Jira WMTRACAPGO-336, master to purge expired archived data 
******************************************************************/
create proc tfm.PurgeExpiredArchivedDataForAllWorkflows
@RunTime_min int = 120,
@PurgeExpiredArchivedDataStartDay date = null,
@AppDataType varchar(20)
as

set nocount on
set transaction isolation level read uncommitted
set dateformat mdy

declare @DataPurgeStart datetime = coalesce(cast(@PurgeExpiredArchivedDataStartDay as datetime), getdate())
declare @StartOfCurrentRun datetime
declare @EndOfCurrentRun char(1) = 'N'
declare @workflowId int

exec tfm.PurgeExpiredArchivedDataInitialSteps @AppDataType = @AppDataType,@DataPurgeStart = @DataPurgeStart

declare workflow_crsr1 cursor fast_forward for 
select distinct workflowId 
from tfm.ExpiredArchivedDataProcessing
where EndDate is null

open workflow_crsr1

while 1=1
begin
	fetch workflow_crsr1 into @workflowId
	if @@fetch_status <> 0 or @EndOfCurrentRun = 'Y'
		break

	set @StartOfCurrentRun = getdate()

	exec tfm.PurgeExpiredArchivedDataForWorkflow 
		@RunTime_min = @RunTime_min, 
		@AppDataType = @AppDataType, 
		@workflowId = @workflowId, 
		@StartOfCurrentRun = @StartOfCurrentRun,
		@EndOfCurrentRun = @EndOfCurrentRun output
end

close workflow_crsr1
deallocate workflow_crsr1

exec tfm.PurgeExpiredArchivedDataFinalSteps @AppDataType = @AppDataType, @EndOfCurrentRun = @EndOfCurrentRun

go
