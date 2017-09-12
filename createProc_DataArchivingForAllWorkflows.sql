use TFM_Archive
go

if object_id('core.DataArchivingForAllWorkflows') is not null
  drop proc core.DataArchivingForAllWorkflows
go

/***************************************************
Author. Eli Baron
Date created. 8-9-17
Purpose. master to archive data
Date modified. 8-29-17
 Moved to core schema
****************************************************/
create proc core.DataArchivingForAllWorkflows
@RunTime_min int = 120,
@DataArchivingStartDay date = null,
@AppDataType varchar(20),
@DbName varchar(128) = 'TFM'
as


if @AppDataType not in (select distinct AppDataType from core.DataArchivingAndPurgingConfig)
begin
	declare @msg varchar(100) = 'The provided value '''+@AppDataType+''' for parameter @AppDataType is not valid';
	throw 51000, @msg, 1;
end

set nocount on
set transaction isolation level read uncommitted
set dateformat mdy

declare @DataArchivingStart datetime = coalesce(cast(@DataArchivingStartDay as datetime), getdate())
declare @StartOfCurrentRun datetime
declare @EndOfCurrentRun char(1) = 'N'
declare @workflowId int

exec core.DataArchiveInitialSteps @AppDataType = @AppDataType,@DataArchivingStarted = @DataArchivingStart, @DbName = @DbName

declare workflow_crsr1 cursor fast_forward for 
select distinct workflowId 
from core.ArchivingDataProcessing
where AppDataType = @AppDataType and EndDate is null

open workflow_crsr1

while 1=1
begin
	fetch workflow_crsr1 into @workflowId
	if @@fetch_status <> 0 or @EndOfCurrentRun = 'Y'
		break

	set @StartOfCurrentRun = getdate()

	exec core.DataArchivingForWorkflow 
		@RunTime_min = @RunTime_min, 
		@AppDataType = @AppDataType, 
		@workflowId = @workflowId, 
		@StartOfCurrentRun = @StartOfCurrentRun,
		@EndOfCurrentRun = @EndOfCurrentRun output
end

close workflow_crsr1
deallocate workflow_crsr1

exec core.DataArchiveFinalSteps @AppDataType = @AppDataType, @EndOfCurrentRun = @EndOfCurrentRun, @DbName = @DbName


go
