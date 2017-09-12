use TFM_Archive
go

if object_id('core.PurgeExpiredArchivedDataForWorkflow') is not null
  drop proc core.PurgeExpiredArchivedDataForWorkflow
go

/*************************************************************************************
Author. Eli Baron
Date created. 8-10-17
Purpose. purge expired archived data for a workflow/application
Date modified. 8-29-17
 Moved to core schema
 Added tables from tfmload schema for data archiving
*************************************************************************************/
create proc core.PurgeExpiredArchivedDataForWorkflow
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
@PurgeExpiredDataOlderThan datetime,
@tbl varchar(128),
@rc int

-- archive expired data 
select @PurgeExpiredDataOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),ctrl.DataArchivingStarted),101)
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
	from tfm.Request
	where workflowId = @workflowId and timestamp < @PurgeExpiredDataOlderThan

	insert #tranStepId
	select tranStepId -- for Activity
	from tfm.Step
	where transactionId in (select transactionId from #transactionId)

	insert #activityId
	select activityId -- for Payload and RequestLoad
	from tfm.Activity
	where tranStepId in (select tranStepId from #tranStepId)
end 
else 
if @AppDataType = 'tfmload'
begin
	insert #transactionId
	select transactionId -- for RequestKeyAttributes, Step
	from tfmload.Request
	where workflowId = @workflowId and timestamp < @PurgeExpiredDataOlderThan

	insert #tranStepId
	select tranStepId -- for Activity
	from tfmload.Step
	where transactionId in (select transactionId from #transactionId)

	insert #activityId
	select activityId -- for Payload and RequestLoad
	from tfmload.Activity
	where tranStepId in (select tranStepId from #tranStepId)

	insert #fileId
	select fileId
	from tfmload.FileLoad
	where fileId in 
	(select fileId from tfmload.Request
	where workflowId = @workflowId and timestamp < @PurgeExpiredDataOlderThan)
end

--1. 
set @tbl = 'RequestKeyAttributes'

begin try
while exists
(select 1 from core.ExpiredArchivedDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from core.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin

	update core.ExpiredArchivedDataProcessing
	set PurgeExpiredDataOlderThan = @PurgeExpiredDataOlderThan
	   ,RowsToPurge = 
	   case @AppDataType 
	   when 'tfm' 
	   then (select count(1) from tfm.RequestKeyAttributes 
	    where transactionId in (select transactionId from #transactionId))
	   when 'tfmload' 
	   then (select count(1) from tfmload.RequestKeyAttributes 
	    where transactionId in (select transactionId from #transactionId))
	   end
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToPurge from core.ExpiredArchivedDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select --@PurgeExpiredDataOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101), --do not remove
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
			delete top (@ArchivingBatchSize) from tfm.RequestKeyAttributes
			where transactionId in (select transactionId from #transactionId)
			option (maxdop 0)

			set @rc = @@rowcount

		end
		if @AppDataType = 'tfmload'
		begin
			delete top (@ArchivingBatchSize) from tfmload.RequestKeyAttributes
			where transactionId in (select transactionId from #transactionId)
			option (maxdop 0)

			set @rc = @@rowcount
		end

		update core.ExpiredArchivedDataProcessing
		set RowsPurged = isnull(RowsPurged, 0) + @rc
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update core.ExpiredArchivedDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update core.ExpiredArchivedDataProcessing
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
(select 1 from core.ExpiredArchivedDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from core.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 
	update core.ExpiredArchivedDataProcessing
	set PurgeExpiredDataOlderThan = @PurgeExpiredDataOlderThan
	   ,RowsToPurge = 
	   case @AppDataType 
	   when 'tfm' 
	   then (select count(1) from tfm.Payload 
	    where activityId in (select activityId from #activityId)
		   or transactionId in (select transactionId from #transactionId))
	   when 'tfmload' 
	   then (select count(1) from tfmload.Payload 
	    where activityId in (select activityId from #activityId)
		   or transactionId in (select transactionId from #transactionId))
	   end
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToPurge from core.ExpiredArchivedDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select --@PurgeExpiredDataOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101), --do not remove
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
			delete top (@ArchivingBatchSize) from tfm.Payload
			where activityId in (select activityId from #activityId)
				or transactionId in (select transactionId from #transactionId)
			option (maxdop 0)

			set @rc = @@rowcount
		end

		if @AppDataType = 'tfmload'
		begin
			delete top (@ArchivingBatchSize) from tfmload.Payload
			where activityId in (select activityId from #activityId)
			   or transactionId in (select transactionId from #transactionId)
			option (maxdop 0)

			set @rc = @@rowcount
		end

		update core.ExpiredArchivedDataProcessing
		set RowsPurged = isnull(RowsPurged, 0) + @rc
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update core.ExpiredArchivedDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update core.ExpiredArchivedDataProcessing
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
(select 1 from core.ExpiredArchivedDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from core.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 
	update core.ExpiredArchivedDataProcessing
	set PurgeExpiredDataOlderThan = @PurgeExpiredDataOlderThan
	   ,RowsToPurge = 
	   (select count(1) from tfmload.RequestLoad 
	    where activityId in (select activityId from #activityId)
		   or transactionId in (select transactionId from #transactionId))
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToPurge from core.ExpiredArchivedDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select --@PurgeExpiredDataOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101), --do not remove
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

		delete top (@ArchivingBatchSize) from tfmload.RequestLoad
		where activityId in (select activityId from #activityId)
		   or transactionId in (select transactionId from #transactionId)
		option (maxdop 0)

		set @rc = @@rowcount

		update core.ExpiredArchivedDataProcessing
		set RowsPurged = isnull(RowsPurged, 0) + @rc
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update core.ExpiredArchivedDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update core.ExpiredArchivedDataProcessing
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
(select 1 from core.ExpiredArchivedDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from core.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 
	update core.ExpiredArchivedDataProcessing
	set PurgeExpiredDataOlderThan = @PurgeExpiredDataOlderThan
	   ,RowsToPurge = 
	   (select count(1) from tfmload.RequestPayloadSummary 
	    where transactionId in (select transactionId from #transactionId))
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToPurge from core.ExpiredArchivedDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select --@PurgeExpiredDataOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101), --do not remove
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

		delete top (@ArchivingBatchSize) from tfmload.RequestPayloadSummary
		where transactionId in (select transactionId from #transactionId)
		option (maxdop 0)

		set @rc = @@rowcount

		update core.ExpiredArchivedDataProcessing
		set RowsPurged = isnull(RowsPurged, 0) + @rc
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update core.ExpiredArchivedDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update core.ExpiredArchivedDataProcessing
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
(select 1 from core.ExpiredArchivedDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from core.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 
	update core.ExpiredArchivedDataProcessing
	set PurgeExpiredDataOlderThan = @PurgeExpiredDataOlderThan
	   ,RowsToPurge = 
	   case @AppDataType 
	   when 'tfm' 
	   then (select count(1) from tfm.Activity 
	    where activityId in (select activityId from #activityId))
	   when 'tfmload' 
	   then (select count(1) from tfmload.Activity 
	    where activityId in (select activityId from #activityId))
	   end
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToPurge from core.ExpiredArchivedDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select --@PurgeExpiredDataOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101), --do not remove
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
			delete top (@ArchivingBatchSize) from tfm.Activity
			where activityId in (select activityId from #activityId)
			option (maxdop 0)

			set @rc = @@rowcount
		end
		

		if @AppDataType = 'tfmload'
		begin
			delete top (@ArchivingBatchSize) from tfmload.Activity
			where activityId in (select activityId from #activityId)
			option (maxdop 0)

			set @rc = @@rowcount
		end

		update core.ExpiredArchivedDataProcessing
		set RowsPurged = isnull(RowsPurged, 0) + @rc		
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update core.ExpiredArchivedDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update core.ExpiredArchivedDataProcessing
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
(select 1 from core.ExpiredArchivedDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from core.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 
	update core.ExpiredArchivedDataProcessing
	set PurgeExpiredDataOlderThan = @PurgeExpiredDataOlderThan
	   ,RowsToPurge = 
	   case @AppDataType 
	   when 'tfm' 
	   then (select count(1) from tfm.Step 
	    where tranStepId in (select tranStepId from #tranStepId))
	   when 'tfmload' 
	   then (select count(1) from tfmload.Step 
	    where tranStepId in (select tranStepId from #tranStepId))
	   end
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToPurge from core.ExpiredArchivedDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select --@PurgeExpiredDataOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101), --do not remove
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
			delete top (@ArchivingBatchSize) from tfm.Step
			where tranStepId in (select tranStepId from #tranStepId)
			option (maxdop 0)

			set @rc = @@rowcount
		end
		

		if @AppDataType = 'tfmload'
		begin
			delete top (@ArchivingBatchSize) from tfmload.Step
			where tranStepId in (select tranStepId from #tranStepId)
			option (maxdop 0)

			set @rc = @@rowcount
		end

		update core.ExpiredArchivedDataProcessing
		set RowsPurged = isnull(RowsPurged, 0) + @rc		
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update core.ExpiredArchivedDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update core.ExpiredArchivedDataProcessing
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
(select 1 from core.ExpiredArchivedDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from core.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 
	update core.ExpiredArchivedDataProcessing
	set PurgeExpiredDataOlderThan = @PurgeExpiredDataOlderThan
	   ,RowsToPurge = 
	   case @AppDataType 
	   when 'tfm' 
	   then (select count(1) from tfm.Request 
	    where transactionId in (select transactionId from #transactionId))
	   when 'tfmload' 
	   then (select count(1) from tfmload.Request 
	    where transactionId in (select transactionId from #transactionId))
	   end
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToPurge from core.ExpiredArchivedDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select --@PurgeExpiredDataOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101), --do not remove
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
			delete top (@ArchivingBatchSize) from tfm.Request
			where transactionId in (select transactionId from #transactionId)
			option (maxdop 0)

			set @rc = @@rowcount
		end
		
		if @AppDataType = 'tfmload'
		begin
			delete top (@ArchivingBatchSize) from tfmload.Request
			where transactionId in (select transactionId from #transactionId)
			option (maxdop 0)

			set @rc = @@rowcount
		end

		update core.ExpiredArchivedDataProcessing
		set RowsPurged = isnull(RowsPurged, 0) + @rc		
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update core.ExpiredArchivedDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update core.ExpiredArchivedDataProcessing
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
(select 1 from core.ExpiredArchivedDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from core.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 

 	select @PurgeExpiredDataOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101)
	      ,@ArchivingBatchSize = ArchivingBatchSize
	from core.DataArchivingAndPurgingConfig
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl

	update core.ExpiredArchivedDataProcessing
	set PurgeExpiredDataOlderThan = @PurgeExpiredDataOlderThan
	   ,RowsToPurge = 
	   case @AppDataType 
	   when 'tfm' 
	   then (select count(1) from tfm.Error 
	    where workflowId = @workflowId and TIMESTAMP < @PurgeExpiredDataOlderThan)
	   when 'tfmload' 
	   then (select count(1) from tfmload.Error 
	    where workflowId = @workflowId and TIMESTAMP < @PurgeExpiredDataOlderThan)
	   end
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToPurge from core.ExpiredArchivedDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select --@PurgeExpiredDataOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101), --do not remove
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
			delete top (@ArchivingBatchSize) from tfm.Error
			where workflowId = @workflowId and TIMESTAMP < @PurgeExpiredDataOlderThan
			option (maxdop 0)

			set @rc = @@rowcount
		end
		
		if @AppDataType = 'tfmload'
		begin
			delete top (@ArchivingBatchSize) from tfmload.Error
			where workflowId = @workflowId and TIMESTAMP < @PurgeExpiredDataOlderThan
			option (maxdop 0)

			set @rc = @@rowcount
		end

		update core.ExpiredArchivedDataProcessing
		set RowsPurged = isnull(RowsPurged, 0) + @rc		
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update core.ExpiredArchivedDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update core.ExpiredArchivedDataProcessing
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
(select 1 from core.ExpiredArchivedDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from core.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 
	update core.ExpiredArchivedDataProcessing
	set PurgeExpiredDataOlderThan = @PurgeExpiredDataOlderThan
	   ,RowsToPurge = 
	   (select count(1) from tfmload.FileLoad 
	    where fileId in (select fileId from #fileId))
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToPurge from core.ExpiredArchivedDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select --@PurgeExpiredDataOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101), --do not remove
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

		delete top (@ArchivingBatchSize) from tfmload.FileLoad
		where fileId in (select fileId from #fileId)
		option (maxdop 0)

		set @rc = @@rowcount

		update core.ExpiredArchivedDataProcessing
		set RowsPurged = isnull(RowsPurged, 0) + @rc
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update core.ExpiredArchivedDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update core.ExpiredArchivedDataProcessing
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
