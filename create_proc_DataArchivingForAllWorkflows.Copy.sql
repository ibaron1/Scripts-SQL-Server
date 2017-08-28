use TFM_Archive
go

if object_id('tfm.DataArchivingForAllWorkflows') is not null
  drop proc tfm.DataArchivingForAllWorkflows
go

/***************************************************
Author. Eli Baron
Date created. 8-9-17
Purpose. Jira WMTRACAPGO-336, master to archive data
***************************************************/
create proc tfm.DataArchivingForAllWorkflows
@RunTime_min int = 120,
@DataArchivingStartDay date = null,
@AppDataType varchar(20)
as

set nocount on
set transaction isolation level read uncommitted
set dateformat mdy

declare @DataArchivingStart datetime = coalesce(cast(@DataArchivingStartDay as datetime), getdate())
declare @StartOfCurrentRun datetime
declare @EndOfCurrentRun char(1) = 'N'
declare @workflowId int

exec TFM.tfm.DataArchiveInitialSteps @AppDataType = @AppDataType,@DataArchivingStarted = @DataArchivingStart

declare workflow_crsr1 cursor fast_forward for 
select distinct workflowId 
from tfm.ArchivingDataProcessing
where EndDate is null

open workflow_crsr1

while 1=1
begin
	fetch workflow_crsr1 into @workflowId
	if @@fetch_status <> 0 or @EndOfCurrentRun = 'Y'
		break

	set @StartOfCurrentRun = getdate()

	exec tfm.DataArchivingForWorkflow 
		@RunTime_min = @RunTime_min, 
		@AppDataType = @AppDataType, 
		@workflowId = @workflowId, 
		@StartOfCurrentRun = @StartOfCurrentRun,
		@EndOfCurrentRun = @EndOfCurrentRun output
end

close workflow_crsr1
deallocate workflow_crsr1

exec TFM.tfm.DataArchiveFinalSteps @AppDataType = @AppDataType, @EndOfCurrentRun = @EndOfCurrentRun

go
