use TFM_Archive
go

if object_id('tfm.DataArchivingForWorkflow') is not null
  drop proc tfm.DataArchivingForWorkflow
go

/*********************************************************
Author. Eli Baron
Date created. 8-10-17
Purpose. Jira WMTRACAPGO-336, archive data for a workflow
*********************************************************/
create proc tfm.DataArchivingForWorkflow
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

-- archive data 
select @ArchiveOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),ctrl.DataArchivingStarted),101)
from tfm.DataArchivingAndPurgingConfig as cfg
cross join TFM.tfm.ControlOfDataArchiving as ctrl
where cfg.AppDataType = @AppDataType and cfg.workflowId = @workflowId and Tbl = 'tfm.Request'

select transactionId into #transactionId -- for RequestKeyAttributes, Step
from TFM.tfm.Request
where workflowId = @workflowId and timestamp < @ArchiveOlderThan

select tranStepId into #tranStepId -- for Activity
from TFM.tfm.Step
where transactionId in (select transactionId from #transactionId)

select activityId into #activityId -- for Payload
from TFM.tfm.Activity
where tranStepId in (select tranStepId from #tranStepId)

-- remove expired archived data 

--1. 
set @tbl = 'tfm.RequestKeyAttributes'

begin try
while exists
(select 1 from tfm.ArchivingDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from tfm.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin

	update tfm.ArchivingDataProcessing
	set ArchiveOlderThan = @ArchiveOlderThan
	   ,RowsToArchive = 
	   (select count(1) from TFM.tfm.RequestKeyAttributes 
	    where transactionId in (select transactionId from #transactionId))
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToArchive from tfm.ArchivingDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select @ArchiveOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101)
	      ,@ArchivingBatchSize = ArchivingBatchSize
	from tfm.DataArchivingAndPurgingConfig
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

		delete top (@ArchivingBatchSize) from TFM.tfm.RequestKeyAttributes
		output deleted.* into tfm.RequestKeyAttributes
		where transactionId in (select transactionId from #transactionId)
		option (maxdop 0)

		set @rc = @@rowcount

		update tfm.ArchivingDataProcessing
		set RowsArchived = isnull(RowsArchived, 0) + @rc
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update tfm.ArchivingDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update tfm.ArchivingDataProcessing
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
set @tbl = 'tfm.Payload'

begin try
while exists
(select 1 from tfm.ArchivingDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from tfm.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 
	update tfm.ArchivingDataProcessing
	set ArchiveOlderThan = @ArchiveOlderThan
	   ,RowsToArchive = 
	   (select count(1) from TFM.tfm.Payload 
	    where activityId in (select activityId from #activityId)
		   or transactionId in (select transactionId from #transactionId))
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToArchive from tfm.ArchivingDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select @ArchiveOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101)
	      ,@ArchivingBatchSize = ArchivingBatchSize
	from tfm.DataArchivingAndPurgingConfig
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

		delete top (@ArchivingBatchSize) from TFM.tfm.Payload
		output deleted.* into tfm.Payload
		where activityId in (select activityId from #activityId)
		   or transactionId in (select transactionId from #transactionId)
		option (maxdop 0)

		set @rc = @@rowcount

		update tfm.ArchivingDataProcessing
		set RowsArchived = isnull(RowsArchived, 0) + @rc
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update tfm.ArchivingDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update tfm.ArchivingDataProcessing
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
set @tbl = 'tfm.Activity'

begin try
while exists
(select 1 from tfm.ArchivingDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from tfm.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 
	update tfm.ArchivingDataProcessing
	set ArchiveOlderThan = @ArchiveOlderThan
	   ,RowsToArchive = 
	   (select count(1) from TFM.tfm.Activity 
	    where activityId in (select activityId from #activityId))
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToArchive from tfm.ArchivingDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select @ArchiveOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101)
	      ,@ArchivingBatchSize = ArchivingBatchSize
	from tfm.DataArchivingAndPurgingConfig
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

		delete top (@ArchivingBatchSize) from TFM.tfm.Activity
		output deleted.* into tfm.Activity
		where activityId in (select activityId from #activityId)
		option (maxdop 0)

		set @rc = @@rowcount

		update tfm.ArchivingDataProcessing
		set RowsArchived = isnull(RowsArchived, 0) + @rc		
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update tfm.ArchivingDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update tfm.ArchivingDataProcessing
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
set @tbl = 'tfm.Step'

begin try
while exists
(select 1 from tfm.ArchivingDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from tfm.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 
	update tfm.ArchivingDataProcessing
	set ArchiveOlderThan = @ArchiveOlderThan
	   ,RowsToArchive = 
	   (select count(1) from TFM.tfm.Step 
	    where tranStepId in (select tranStepId from #tranStepId))
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToArchive from tfm.ArchivingDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select @ArchiveOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101)
	      ,@ArchivingBatchSize = ArchivingBatchSize
	from tfm.DataArchivingAndPurgingConfig
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

		delete top (@ArchivingBatchSize) from TFM.tfm.Step
		output deleted.* into tfm.Step
		where tranStepId in (select tranStepId from #tranStepId)
		option (maxdop 0)

		set @rc = @@rowcount

		update tfm.ArchivingDataProcessing
		set RowsArchived = isnull(RowsArchived, 0) + @rc		
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update tfm.ArchivingDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update tfm.ArchivingDataProcessing
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
set @tbl = 'tfm.Request'

begin try
while exists
(select 1 from tfm.ArchivingDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from tfm.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDays is not null)
 and EndDate is null)
 begin 
	update tfm.ArchivingDataProcessing
	set ArchiveOlderThan = @ArchiveOlderThan
	   ,RowsToArchive = 
	   (select count(1) from TFM.tfm.Request 
	    where transactionId in (select transactionId from #transactionId))
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	  and StartDate is null
    option (maxdop 0)

	if (select RowsToArchive from tfm.ArchivingDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select @ArchiveOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDays),@StartOfCurrentRun),101)
	      ,@ArchivingBatchSize = ArchivingBatchSize
	from tfm.DataArchivingAndPurgingConfig
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

		delete top (@ArchivingBatchSize) from TFM.tfm.Request
		output deleted.* into tfm.Request
		where transactionId in (select transactionId from #transactionId)
		option (maxdop 0)

		set @rc = @@rowcount

		update tfm.ArchivingDataProcessing
		set RowsArchived = isnull(RowsArchived, 0) + @rc		
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update tfm.ArchivingDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update tfm.ArchivingDataProcessing
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

go
