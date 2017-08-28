use TFM_Archive
go

if object_id('tfm.PurgeExpiredArchivedDataForWorkflow') is not null
  drop proc tfm.PurgeExpiredArchivedDataForWorkflow
go

/*************************************************************************************
Author. Eli Baron
Date created. 8-10-17
Purpose. Jira WMTRACAPGO-336, purge expired archived data for a workflow/application
*************************************************************************************/
create proc tfm.PurgeExpiredArchivedDataForWorkflow
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
@PurgeArchivedDataOlderThan datetime,
@tbl varchar(128),
@rc int

-- purge expired archived data 
select @PurgeArchivedDataOlderThan = convert(char(10), dateadd(dd,-1*(RetentionDaysForArchiving),ctrl.DataPurgeStarted),101)
from tfm.DataArchivingAndPurgingConfig as cfg
cross join tfm.ControlPurgeOfExpiredArchivedData as ctrl
where cfg.AppDataType = @AppDataType and cfg.workflowId = @workflowId and Tbl = 'tfm.Request'

select transactionId into #transactionId -- for RequestKeyAttributes, Step
from tfm.Request
where workflowId = @workflowId and timestamp < @PurgeArchivedDataOlderThan

select tranStepId into #tranStepId -- for Activity
from tfm.Step
where transactionId in (select transactionId from #transactionId)

select activityId into #activityId -- for Payload
from tfm.Activity
where tranStepId in (select tranStepId from #tranStepId)


--1. 
set @tbl = 'tfm.RequestKeyAttributes'

begin try
while exists
(select 1 from tfm.ExpiredArchivedDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from tfm.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDaysForArchiving is not null)
 and EndDate is null)
 begin

	update tfm.ExpiredArchivedDataProcessing
	set PurgeExpiredDataOlderThan = @PurgeArchivedDataOlderThan
		,RowsToPurge = 
	   (select count(1) from tfm.RequestKeyAttributes 
	    where transactionId in (select transactionId from #transactionId))
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
    option (maxdop 0)

	if (select RowsToPurge from tfm.ExpiredArchivedDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select @ArchivingBatchSize = ArchivingBatchSize
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

		delete top (@ArchivingBatchSize) from tfm.RequestKeyAttributes
		where transactionId in (select transactionId from #transactionId)
		option (maxdop 0)

		set @rc = @@rowcount

		update tfm.ExpiredArchivedDataProcessing
		set PurgeExpiredDataOlderThan = @PurgeArchivedDataOlderThan
		,RowsPurged = isnull(RowsPurged, 0) + @rc
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update tfm.ExpiredArchivedDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update tfm.ExpiredArchivedDataProcessing
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
(select 1 from tfm.ExpiredArchivedDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from tfm.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDaysForArchiving is not null)
 and EndDate is null)
 begin

	update tfm.ExpiredArchivedDataProcessing
	set PurgeExpiredDataOlderThan = @PurgeArchivedDataOlderThan
		,RowsToPurge = 
	   (select count(1) from tfm.Payload 
	    where activityId in (select activityId from #activityId)
		   or transactionId in (select transactionId from #transactionId))
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
    option (maxdop 0)

	if (select RowsToPurge from tfm.ExpiredArchivedDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select @ArchivingBatchSize = ArchivingBatchSize
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

		delete top (@ArchivingBatchSize) from tfm.Payload
		where activityId in (select activityId from #activityId)
		   or transactionId in (select transactionId from #transactionId)
		option (maxdop 0)

		set @rc = @@rowcount

		update tfm.ExpiredArchivedDataProcessing
		set RowsPurged = isnull(RowsPurged, 0) + @rc
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update tfm.ExpiredArchivedDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update tfm.ExpiredArchivedDataProcessing
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
(select 1 from tfm.ExpiredArchivedDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from tfm.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDaysForArchiving is not null)
 and EndDate is null)
 begin

	update tfm.ExpiredArchivedDataProcessing
	set PurgeExpiredDataOlderThan = @PurgeArchivedDataOlderThan
		,RowsToPurge = 
	   (select count(1) from tfm.Activity 
	    where activityId in (select activityId from #activityId))
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
    option (maxdop 0)

	if (select RowsToPurge from tfm.ExpiredArchivedDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select @ArchivingBatchSize = ArchivingBatchSize
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

		delete top (@ArchivingBatchSize) from tfm.Activity
	    where activityId in (select activityId from #activityId)
		option (maxdop 0)

		set @rc = @@rowcount

		update tfm.ExpiredArchivedDataProcessing
		set RowsPurged = isnull(RowsPurged, 0) + @rc
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update tfm.ExpiredArchivedDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update tfm.ExpiredArchivedDataProcessing
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
(select 1 from tfm.ExpiredArchivedDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from tfm.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDaysForArchiving is not null)
 and EndDate is null)
 begin

	update tfm.ExpiredArchivedDataProcessing
	set PurgeExpiredDataOlderThan = @PurgeArchivedDataOlderThan
		,RowsToPurge = 
	   (select count(1) from tfm.Step 
	    where tranStepId in (select tranStepId from #tranStepId))
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
    option (maxdop 0)

	if (select RowsToPurge from tfm.ExpiredArchivedDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select @ArchivingBatchSize = ArchivingBatchSize
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

		delete top (@ArchivingBatchSize) from tfm.Step
	    where tranStepId in (select tranStepId from #tranStepId)
		option (maxdop 0)

		set @rc = @@rowcount

		update tfm.ExpiredArchivedDataProcessing
		set RowsPurged = isnull(RowsPurged, 0) + @rc
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update tfm.ExpiredArchivedDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update tfm.ExpiredArchivedDataProcessing
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
(select 1 from tfm.ExpiredArchivedDataProcessing
 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl 
 and exists (select 1 from tfm.DataArchivingAndPurgingConfig
			 where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
			 and RetentionDaysForArchiving is not null)
 and EndDate is null)
 begin

	update tfm.ExpiredArchivedDataProcessing
	set PurgeExpiredDataOlderThan = @PurgeArchivedDataOlderThan
		,RowsToPurge = 
	   (select count(1) from tfm.Request 
	    where transactionId in (select transactionId from #transactionId))
	   ,StartDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
    option (maxdop 0)

	if (select RowsToPurge from tfm.ExpiredArchivedDataProcessing 
	    where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl) = 0
	  break

	select @ArchivingBatchSize = ArchivingBatchSize
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

		delete top (@ArchivingBatchSize) from tfm.Request
	    where transactionId in (select transactionId from #transactionId)
		option (maxdop 0)

		set @rc = @@rowcount

		update tfm.ExpiredArchivedDataProcessing
		set RowsPurged = isnull(RowsPurged, 0) + @rc
		,LastDate = getdate()
		where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
	end
	
	update tfm.ExpiredArchivedDataProcessing
	set EndDate = getdate()
	where AppDataType = @AppDataType and workflowId = @workflowId and Tbl = @tbl
end
end try
begin catch
	update tfm.ExpiredArchivedDataProcessing
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