use TFM_Archive
go

if object_id('core.DataArchivingForWorkflow') is not null
  drop proc core.DataArchivingForWorkflow
go

/*********************************************************
Author. Eli Baron
Date created. 8-10-17
Purpose. archive data for a workflow
Date modified. 8-29-17
 Moved to core schema
 Added tables from tfmload schema for data archiving
*********************************************************/
create proc core.DataArchivingForWorkflow
@RunTime_min int,
@AppDataType varchar(20),
@workflowId int,
@StartOfCurrentRun datetime,
@EndOfCurrentRun char(1) output
as

set nocount on
set transaction isolation level read uncommitted
set dateformat mdy

declare @ArchivingBatchSize int, 
@ArchiveOlderThan datetime,
@tbl varchar(128),
@rc int

-- archive expired data 
select @ArchiveOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),ctrl.DataArchivingStarted),101)
from core.DataArchivingAndPurgingConfig as cfg
cross join core.ControlOfDataArchiving as ctrl
where cfg.AppDataType = @AppDataType and cfg.workflowId = @workflowId and Tbl = 'Request'

create table #transactionId(transactionId int)
create table #tranStepId(tranStepId int)
create table #activityId(activityId int)
create table #fileId(fileId int)

if @AppDataType = 'tfm'
begin
	insert #transactionId
	select transactionId -- for RequestKeyAttributes, Step
	from TFM.tfm.Request
	where workflowId = @workflowId and timestamp < @ArchiveOlderThan

	insert #tranStepId
	select tranStepId -- for Activity
	from TFM.tfm.Step
	where transactionId in (select transactionId from #transactionId)

	insert #activityId
	select activityId -- for Payload and RequestLoad
	from TFM.tfm.Activity
	where tranStepId in (select tranStepId from #tranStepId)
end 
else 
if @AppDataType = 'tfmload'
begin
	insert #transactionId
	select transactionId -- for RequestKeyAttributes, Step
	from TFM.tfmload.Request
	where workflowId = @workflowId and timestamp < @ArchiveOlderThan

	insert #tranStepId
	select tranStepId -- for Activity
	from TFM.tfmload.Step
	where transactionId in (select transactionId from #transactionId)

	insert #activityId
	select activityId -- for Payload and RequestLoad
	from TFM.tfmload.Activity
	where tranStepId in (select tranStepId from #tranStepId)

	insert #fileId
	select fileId
	from TFM.tfmload.FileLoad
	where fileId in 
	(select fileId from TFM.tfmload.Request
	where workflowId = @workflowId and timestamp < @ArchiveOlderThan)
end

--1. 
set @tbl = 'RequestKeyAttributes'

begin try
while exists
(select 1 from core.ArchivingDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from core.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin

	update core.ArchivingDataProcessing
	set ArchiveOlderThan = @ArchiveOlderThan
	   ,RowsToArchive = 
	   case @AppDataType 
	   when 'tfm' 
	   then (select count(1) from TFM.tfm.RequestKeyAttributes 
	    where transactionId in (select transactionId from #transactionId))
	   when 'tfmload' 
	   then (select count(1) from TFM.tfmload.RequestKeyAttributes 
	    where transactionId in (select transactionId from #transactionId))
	   end
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToArchive from core.ArchivingDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select --@ArchiveOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101), --do not remove
	      @ArchivingBatchSize = ArchivingBatchSize
	from core.DataArchivingAndPurgingConfig
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	set @rc = @ArchivingBatchSize

	while @rc = @ArchivingBatchSize
	begin
		if datediff(mi, @StartOfCurrentRun, getdate()) > @RunTime_min
		begin
			print 'Exceeded run time limit of '+cast(@RunTime_min/60 as varchar(2))+' hrs '+cast(@RunTime_min%60 as varchar(2))+' min'
			print 'Start time '+cast(@StartOfCurrentRun as varchar(24))+' , Current time '+cast(getdate() as varchar(24))
			
			set @EndOfCurrentRun = 'Y'
			goto EndOfCurrentRun
	    end

		if @AppDataType = 'tfm'
		begin
			delete top (@ArchivingBatchSize) from TFM.tfm.RequestKeyAttributes
			output deleted.* into tfm.RequestKeyAttributes
			where transactionId in (select transactionId from #transactionId)
			option (maxdop 0)

			set @rc = @@rowcount

		end
		if @AppDataType = 'tfmload'
		begin
			delete top (@ArchivingBatchSize) from TFM.tfmload.RequestKeyAttributes
			output deleted.* into tfmload.RequestKeyAttributes
			where transactionId in (select transactionId from #transactionId)
			option (maxdop 0)

			set @rc = @@rowcount
		end

		update core.ArchivingDataProcessing
		set RowsArchived = isnull(RowsArchived, 0) + @rc
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update core.ArchivingDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update core.ArchivingDataProcessing
	set Error = 
		'ErrorNumber: '+cast(ERROR_NUMBER() as varchar(100))+' '+
		'ErrorSeverity: '+cast(ERROR_SEVERITY() as varchar(100))+' '+
		'ErrorState: '+cast(ERROR_STATE() as varchar(100))+' '+
		'ErrorLine: '+cast(ERROR_LINE() as varchar(100))+' '+
		'ErrorMessage: '+ERROR_MESSAGE()
    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	set @EndOfCurrentRun = 'Y'
	goto EndOfCurrentRun
end catch

--2. 
set @tbl = 'Payload'

begin try
while exists
(select 1 from core.ArchivingDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from core.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 
	update core.ArchivingDataProcessing
	set ArchiveOlderThan = @ArchiveOlderThan
	   ,RowsToArchive = 
	   case @AppDataType 
	   when 'tfm' 
	   then (select count(1) from TFM.tfm.Payload 
	    where activityId in (select activityId from #activityId)
		   or transactionId in (select transactionId from #transactionId))
	   when 'tfmload' 
	   then (select count(1) from TFM.tfmload.Payload 
	    where activityId in (select activityId from #activityId)
		   or transactionId in (select transactionId from #transactionId))
	   end
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToArchive from core.ArchivingDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select --@ArchiveOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101), --do not remove
	      @ArchivingBatchSize = ArchivingBatchSize
	from core.DataArchivingAndPurgingConfig
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	set @rc = @ArchivingBatchSize

	while @rc = @ArchivingBatchSize
	begin
		if datediff(mi, @StartOfCurrentRun, getdate()) > @RunTime_min
		begin
			print 'Exceeded run time limit of '+cast(@RunTime_min/60 as varchar(2))+' hrs '+cast(@RunTime_min%60 as varchar(2))+' min'
			print 'Start time '+cast(@StartOfCurrentRun as varchar(24))+' , Current time '+cast(getdate() as varchar(24))
			
			set @EndOfCurrentRun = 'Y'
			goto EndOfCurrentRun
	    end

		if @AppDataType = 'tfm'
		begin
			delete top (@ArchivingBatchSize) from TFM.tfm.Payload
			output deleted.* into tfm.Payload
			where activityId in (select activityId from #activityId)
				or transactionId in (select transactionId from #transactionId)
			option (maxdop 0)

			set @rc = @@rowcount
		end

		if @AppDataType = 'tfmload'
		begin
			delete top (@ArchivingBatchSize) from TFM.tfmload.Payload
			output deleted.* into tfmload.Payload
			where activityId in (select activityId from #activityId)
			   or transactionId in (select transactionId from #transactionId)
			option (maxdop 0)

			set @rc = @@rowcount
		end

		update core.ArchivingDataProcessing
		set RowsArchived = isnull(RowsArchived, 0) + @rc
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update core.ArchivingDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update core.ArchivingDataProcessing
	set Error = 
		'ErrorNumber: '+cast(ERROR_NUMBER() as varchar(100))+' '+
		'ErrorSeverity: '+cast(ERROR_SEVERITY() as varchar(100))+' '+
		'ErrorState: '+cast(ERROR_STATE() as varchar(100))+' '+
		'ErrorLine: '+cast(ERROR_LINE() as varchar(100))+' '+
		'ErrorMessage: '+ERROR_MESSAGE()
    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	set @EndOfCurrentRun = 'Y'
	goto EndOfCurrentRun
end catch

--3. 
set @tbl = 'RequestLoad'
-- exists in schema tfmload only 
begin try
while exists
(select 1 from core.ArchivingDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from core.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 
	update core.ArchivingDataProcessing
	set ArchiveOlderThan = @ArchiveOlderThan
	   ,RowsToArchive = 
	   (select count(1) from TFM.tfmload.RequestLoad 
	    where activityId in (select activityId from #activityId)
		   or transactionId in (select transactionId from #transactionId))
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToArchive from core.ArchivingDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select --@ArchiveOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101), --do not remove
	      @ArchivingBatchSize = ArchivingBatchSize
	from core.DataArchivingAndPurgingConfig
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	set @rc = @ArchivingBatchSize

	while @rc = @ArchivingBatchSize
	begin
		if datediff(mi, @StartOfCurrentRun, getdate()) > @RunTime_min
		begin
			print 'Exceeded run time limit of '+cast(@RunTime_min/60 as varchar(2))+' hrs '+cast(@RunTime_min%60 as varchar(2))+' min'
			print 'Start time '+cast(@StartOfCurrentRun as varchar(24))+' , Current time '+cast(getdate() as varchar(24))
			
			set @EndOfCurrentRun = 'Y'
			goto EndOfCurrentRun
	    end

		delete top (@ArchivingBatchSize) from TFM.tfmload.RequestLoad
		output deleted.* into tfmload.RequestLoad
		where activityId in (select activityId from #activityId)
		   or transactionId in (select transactionId from #transactionId)
		option (maxdop 0)

		set @rc = @@rowcount

		update core.ArchivingDataProcessing
		set RowsArchived = isnull(RowsArchived, 0) + @rc
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update core.ArchivingDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update core.ArchivingDataProcessing
	set Error = 
		'ErrorNumber: '+cast(ERROR_NUMBER() as varchar(100))+' '+
		'ErrorSeverity: '+cast(ERROR_SEVERITY() as varchar(100))+' '+
		'ErrorState: '+cast(ERROR_STATE() as varchar(100))+' '+
		'ErrorLine: '+cast(ERROR_LINE() as varchar(100))+' '+
		'ErrorMessage: '+ERROR_MESSAGE()
    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	set @EndOfCurrentRun = 'Y'
	goto EndOfCurrentRun
end catch

--4. 
set @tbl = 'RequestPayloadSummary'
-- exists in schema tfmload only 
begin try
while exists
(select 1 from core.ArchivingDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from core.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 
	update core.ArchivingDataProcessing
	set ArchiveOlderThan = @ArchiveOlderThan
	   ,RowsToArchive = 
	   (select count(1) from TFM.tfm.RequestPayloadSummary 
	    where transactionId in (select transactionId from #transactionId))
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToArchive from core.ArchivingDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select --@ArchiveOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101), --do not remove
	      @ArchivingBatchSize = ArchivingBatchSize
	from core.DataArchivingAndPurgingConfig
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	set @rc = @ArchivingBatchSize

	while @rc = @ArchivingBatchSize
	begin
		if datediff(mi, @StartOfCurrentRun, getdate()) > @RunTime_min
		begin
			print 'Exceeded run time limit of '+cast(@RunTime_min/60 as varchar(2))+' hrs '+cast(@RunTime_min%60 as varchar(2))+' min'
			print 'Start time '+cast(@StartOfCurrentRun as varchar(24))+' , Current time '+cast(getdate() as varchar(24))
			
			set @EndOfCurrentRun = 'Y'
			goto EndOfCurrentRun
	    end

		delete top (@ArchivingBatchSize) from TFM.tfm.RequestPayloadSummary
		output deleted.* into tfm.RequestPayloadSummary
		where transactionId in (select transactionId from #transactionId)
		option (maxdop 0)

		set @rc = @@rowcount

		update core.ArchivingDataProcessing
		set RowsArchived = isnull(RowsArchived, 0) + @rc
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update core.ArchivingDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update core.ArchivingDataProcessing
	set Error = 
		'ErrorNumber: '+cast(ERROR_NUMBER() as varchar(100))+' '+
		'ErrorSeverity: '+cast(ERROR_SEVERITY() as varchar(100))+' '+
		'ErrorState: '+cast(ERROR_STATE() as varchar(100))+' '+
		'ErrorLine: '+cast(ERROR_LINE() as varchar(100))+' '+
		'ErrorMessage: '+ERROR_MESSAGE()
    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	set @EndOfCurrentRun = 'Y'
	goto EndOfCurrentRun
end catch

--5. 
set @tbl = 'Activity'

begin try
while exists
(select 1 from core.ArchivingDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from core.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 
	update core.ArchivingDataProcessing
	set ArchiveOlderThan = @ArchiveOlderThan
	   ,RowsToArchive = 
	   case @AppDataType 
	   when 'tfm' 
	   then (select count(1) from TFM.tfm.Activity 
	    where activityId in (select activityId from #activityId))
	   when 'tfmload' 
	   then (select count(1) from TFM.tfmload.Activity 
	    where activityId in (select activityId from #activityId))
	   end
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToArchive from core.ArchivingDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select --@ArchiveOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101), --do not remove
	      @ArchivingBatchSize = ArchivingBatchSize
	from core.DataArchivingAndPurgingConfig
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	set @rc = @ArchivingBatchSize

	while @rc = @ArchivingBatchSize
	begin
		if datediff(mi, @StartOfCurrentRun, getdate()) > @RunTime_min
		begin
			print 'Exceeded run time limit of '+cast(@RunTime_min/60 as varchar(2))+' hrs '+cast(@RunTime_min%60 as varchar(2))+' min'
			print 'Start time '+cast(@StartOfCurrentRun as varchar(24))+' , Current time '+cast(getdate() as varchar(24))
			
			set @EndOfCurrentRun = 'Y'
			goto EndOfCurrentRun
	    end

		if @AppDataType = 'tfm'
		begin
			delete top (@ArchivingBatchSize) from TFM.tfm.Activity
			output deleted.* into tfm.Activity
			where activityId in (select activityId from #activityId)
			option (maxdop 0)

			set @rc = @@rowcount
		end
		

		if @AppDataType = 'tfmload'
		begin
			delete top (@ArchivingBatchSize) from TFM.tfmload.Activity
			output deleted.* into tfmload.Activity
			where activityId in (select activityId from #activityId)
			option (maxdop 0)

			set @rc = @@rowcount
		end

		update core.ArchivingDataProcessing
		set RowsArchived = isnull(RowsArchived, 0) + @rc		
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update core.ArchivingDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update core.ArchivingDataProcessing
	set Error = 
		'ErrorNumber: '+cast(ERROR_NUMBER() as varchar(100))+' '+
		'ErrorSeverity: '+cast(ERROR_SEVERITY() as varchar(100))+' '+
		'ErrorState: '+cast(ERROR_STATE() as varchar(100))+' '+
		'ErrorLine: '+cast(ERROR_LINE() as varchar(100))+' '+
		'ErrorMessage: '+ERROR_MESSAGE()
    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	set @EndOfCurrentRun = 'Y'
	goto EndOfCurrentRun
end catch

--6.
set @tbl = 'Step'

begin try
while exists
(select 1 from core.ArchivingDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from core.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 
	update core.ArchivingDataProcessing
	set ArchiveOlderThan = @ArchiveOlderThan
	   ,RowsToArchive = 
	   case @AppDataType 
	   when 'tfm' 
	   then (select count(1) from TFM.tfm.Step 
	    where tranStepId in (select tranStepId from #tranStepId))
	   when 'tfmload' 
	   then (select count(1) from TFM.tfmload.Step 
	    where tranStepId in (select tranStepId from #tranStepId))
	   end
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToArchive from core.ArchivingDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select --@ArchiveOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101), --do not remove
	      @ArchivingBatchSize = ArchivingBatchSize
	from core.DataArchivingAndPurgingConfig
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	set @rc = @ArchivingBatchSize

	while @rc = @ArchivingBatchSize
	begin
		if datediff(mi, @StartOfCurrentRun, getdate()) > @RunTime_min
		begin
			print 'Exceeded run time limit of '+cast(@RunTime_min/60 as varchar(2))+' hrs '+cast(@RunTime_min%60 as varchar(2))+' min'
			print 'Start time '+cast(@StartOfCurrentRun as varchar(24))+' , Current time '+cast(getdate() as varchar(24))
			
			set @EndOfCurrentRun = 'Y'
			goto EndOfCurrentRun
	    end

		if @AppDataType = 'tfm'
		begin
			delete top (@ArchivingBatchSize) from TFM.tfm.Step
			output deleted.* into tfm.Step
			where tranStepId in (select tranStepId from #tranStepId)
			option (maxdop 0)

			set @rc = @@rowcount
		end
		

		if @AppDataType = 'tfmload'
		begin
			delete top (@ArchivingBatchSize) from TFM.tfmload.Step
			output deleted.* into tfmload.Step
			where tranStepId in (select tranStepId from #tranStepId)
			option (maxdop 0)

			set @rc = @@rowcount
		end

		update core.ArchivingDataProcessing
		set RowsArchived = isnull(RowsArchived, 0) + @rc		
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update core.ArchivingDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update core.ArchivingDataProcessing
	set Error = 
		'ErrorNumber: '+cast(ERROR_NUMBER() as varchar(100))+' '+
		'ErrorSeverity: '+cast(ERROR_SEVERITY() as varchar(100))+' '+
		'ErrorState: '+cast(ERROR_STATE() as varchar(100))+' '+
		'ErrorLine: '+cast(ERROR_LINE() as varchar(100))+' '+
		'ErrorMessage: '+ERROR_MESSAGE()
    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	set @EndOfCurrentRun = 'Y'
	goto EndOfCurrentRun
end catch

--7. 
set @tbl = 'Request'

begin try
while exists
(select 1 from core.ArchivingDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from core.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 
	update core.ArchivingDataProcessing
	set ArchiveOlderThan = @ArchiveOlderThan
	   ,RowsToArchive = 
	   case @AppDataType 
	   when 'tfm' 
	   then (select count(1) from TFM.tfm.Request 
	    where transactionId in (select transactionId from #transactionId))
	   when 'tfmload' 
	   then (select count(1) from TFM.tfmload.Request 
	    where transactionId in (select transactionId from #transactionId))
	   end
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToArchive from core.ArchivingDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select --@ArchiveOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101), --do not remove
	      @ArchivingBatchSize = ArchivingBatchSize
	from core.DataArchivingAndPurgingConfig
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	set @rc = @ArchivingBatchSize

	while @rc = @ArchivingBatchSize
	begin
		if datediff(mi, @StartOfCurrentRun, getdate()) > @RunTime_min
		begin
			print 'Exceeded run time limit of '+cast(@RunTime_min/60 as varchar(2))+' hrs '+cast(@RunTime_min%60 as varchar(2))+' min'
			print 'Start time '+cast(@StartOfCurrentRun as varchar(24))+' , Current time '+cast(getdate() as varchar(24))
			
			set @EndOfCurrentRun = 'Y'
			goto EndOfCurrentRun
	    end

		if @AppDataType = 'tfm'
		begin
			delete top (@ArchivingBatchSize) from TFM.tfm.Request
			output deleted.* into tfm.Request
			where transactionId in (select transactionId from #transactionId)
			option (maxdop 0)

			set @rc = @@rowcount
		end
		
		if @AppDataType = 'tfmload'
		begin
			delete top (@ArchivingBatchSize) from TFM.tfmload.Request
			output deleted.* into tfmload.Request
			where transactionId in (select transactionId from #transactionId)
			option (maxdop 0)

			set @rc = @@rowcount
		end

		update core.ArchivingDataProcessing
		set RowsArchived = isnull(RowsArchived, 0) + @rc		
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update core.ArchivingDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update core.ArchivingDataProcessing
	set Error = 
		'ErrorNumber: '+cast(ERROR_NUMBER() as varchar(100))+' '+
		'ErrorSeverity: '+cast(ERROR_SEVERITY() as varchar(100))+' '+
		'ErrorState: '+cast(ERROR_STATE() as varchar(100))+' '+
		'ErrorLine: '+cast(ERROR_LINE() as varchar(100))+' '+
		'ErrorMessage: '+ERROR_MESSAGE()
    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	set @EndOfCurrentRun = 'Y'
	goto EndOfCurrentRun
end catch

--8. 
set @tbl = 'Error'

begin try
while exists
(select 1 from core.ArchivingDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from core.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 

 	select @ArchiveOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101)
	      ,@ArchivingBatchSize = ArchivingBatchSize
	from core.DataArchivingAndPurgingConfig
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	update core.ArchivingDataProcessing
	set ArchiveOlderThan = @ArchiveOlderThan
	   ,RowsToArchive = 
	   case @AppDataType 
	   when 'tfm' 
	   then (select count(1) from TFM.tfm.Error 
	    where workflowId = @workflowId and TIMESTAMP < @ArchiveOlderThan)
	   when 'tfmload' 
	   then (select count(1) from TFM.tfmload.Error 
	    where workflowId = @workflowId and TIMESTAMP < @ArchiveOlderThan)
	   end
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToArchive from core.ArchivingDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select --@ArchiveOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101), --do not remove
	      @ArchivingBatchSize = ArchivingBatchSize
	from core.DataArchivingAndPurgingConfig
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	set @rc = @ArchivingBatchSize

	while @rc = @ArchivingBatchSize
	begin
		if datediff(mi, @StartOfCurrentRun, getdate()) > @RunTime_min
		begin
			print 'Exceeded run time limit of '+cast(@RunTime_min/60 as varchar(2))+' hrs '+cast(@RunTime_min%60 as varchar(2))+' min'
			print 'Start time '+cast(@StartOfCurrentRun as varchar(24))+' , Current time '+cast(getdate() as varchar(24))
			
			set @EndOfCurrentRun = 'Y'
			goto EndOfCurrentRun
	    end

		if @AppDataType = 'tfm'
		begin
			delete top (@ArchivingBatchSize) from TFM.tfm.Error
			output deleted.* into tfm.Error
			where workflowId = @workflowId and TIMESTAMP < @ArchiveOlderThan
			option (maxdop 0)

			set @rc = @@rowcount
		end
		
		if @AppDataType = 'tfmload'
		begin
			delete top (@ArchivingBatchSize) from TFM.tfmload.Error
			output deleted.* into tfmload.Error
			where workflowId = @workflowId and TIMESTAMP < @ArchiveOlderThan
			option (maxdop 0)

			set @rc = @@rowcount
		end

		update core.ArchivingDataProcessing
		set RowsArchived = isnull(RowsArchived, 0) + @rc		
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update core.ArchivingDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update core.ArchivingDataProcessing
	set Error = 
		'ErrorNumber: '+cast(ERROR_NUMBER() as varchar(100))+' '+
		'ErrorSeverity: '+cast(ERROR_SEVERITY() as varchar(100))+' '+
		'ErrorState: '+cast(ERROR_STATE() as varchar(100))+' '+
		'ErrorLine: '+cast(ERROR_LINE() as varchar(100))+' '+
		'ErrorMessage: '+ERROR_MESSAGE()
    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	set @EndOfCurrentRun = 'Y'
	goto EndOfCurrentRun
end catch

--9. 
set @tbl = 'FileLoad'
-- exists in schema tfmload only 
begin try
while exists
(select 1 from core.ArchivingDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from core.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 
	update core.ArchivingDataProcessing
	set ArchiveOlderThan = @ArchiveOlderThan
	   ,RowsToArchive = 
	   (select count(1) from TFM.tfmload.FileLoad 
	    where fileId in (select fileId from #fileId))
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToArchive from core.ArchivingDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select --@ArchiveOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101), --do not remove
	      @ArchivingBatchSize = ArchivingBatchSize
	from core.DataArchivingAndPurgingConfig
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	set @rc = @ArchivingBatchSize

	while @rc = @ArchivingBatchSize
	begin
		if datediff(mi, @StartOfCurrentRun, getdate()) > @RunTime_min
		begin
			print 'Exceeded run time limit of '+cast(@RunTime_min/60 as varchar(2))+' hrs '+cast(@RunTime_min%60 as varchar(2))+' min'
			print 'Start time '+cast(@StartOfCurrentRun as varchar(24))+' , Current time '+cast(getdate() as varchar(24))
			
			set @EndOfCurrentRun = 'Y'
			goto EndOfCurrentRun
	    end

		delete top (@ArchivingBatchSize) from TFM.tfmload.FileLoad
		output deleted.* into tfmload.FileLoad
		where fileId in (select fileId from #fileId)
		option (maxdop 0)

		set @rc = @@rowcount

		update core.ArchivingDataProcessing
		set RowsArchived = isnull(RowsArchived, 0) + @rc
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update core.ArchivingDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update core.ArchivingDataProcessing
	set Error = 
		'ErrorNumber: '+cast(ERROR_NUMBER() as varchar(100))+' '+
		'ErrorSeverity: '+cast(ERROR_SEVERITY() as varchar(100))+' '+
		'ErrorState: '+cast(ERROR_STATE() as varchar(100))+' '+
		'ErrorLine: '+cast(ERROR_LINE() as varchar(100))+' '+
		'ErrorMessage: '+ERROR_MESSAGE()
    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	set @EndOfCurrentRun = 'Y'
	goto EndOfCurrentRun
end catch

EndOfCurrentRun:

drop table #transactionId,#tranStepId,#activityId,#fileId

go
