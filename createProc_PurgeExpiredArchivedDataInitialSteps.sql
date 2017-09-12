USE TFM_Archive
GO

if object_id('core.PurgeExpiredArchivedDataInitialSteps') is not null
  drop proc core.PurgeExpiredArchivedDataInitialSteps
go

/****************************************************************************************************************************************
Author. Eli Baron
Date created. 8-9-17
Purpose. Start new or restart current archiving cycle, is to be called from PurgeExpiredArchivedDataForAllWorkflows
Date modified. 8-29-17
 Moved to core schema
****************************************************************************************************************************************/
create proc core.PurgeExpiredArchivedDataInitialSteps
@AppDataType varchar(20),
@DataPurgeStart datetime
as

set nocount on
set transaction isolation level read uncommitted
set dateformat mdy

declare @StartOfCurrentRun datetime = getdate()
declare @PurgeExpiredDataOlderThan datetime

if exists (select 1 from core.ControlPurgeOfExpiredArchivedData where DbName = db_name()
  and AppDataType = @AppDataType and DataPurgeEnded is not null)
or not exists (select 1 from core.ControlPurgeOfExpiredArchivedData where DbName = db_name()
  and AppDataType = @AppDataType)
begin
	delete core.ControlPurgeOfExpiredArchivedData
	output deleted.* into core.ControlPurgeOfExpiredArchivedData_History
	where DbName = db_name() and AppDataType = @AppDataType

	insert core.ControlPurgeOfExpiredArchivedData
	(DbName,
	 DbSize_GB,
	 Orig_DbSpace_Used_GB ,
	 Orig_DbAvailable_Space_GB,
	 Orig_Percent_Used,
	 AppDataType,
	 DataPurgeStarted,
	 CurrentRunStarted)
	 select DbName,
	 size_in_GB,
	 Space_used_in_GB,
	 Available_Space_in_GB,
	 Percent_Used,
	 @AppDataType,
	 @DataPurgeStart,
	 @StartOfCurrentRun
	 from dbo.dbstats
	 
	 delete core.ExpiredArchivedDataProcessing
	 output deleted.* into core.ExpiredArchivedDataProcessing_History
	 where DbName = db_name() and AppDataType = @AppDataType

	 insert core.ExpiredArchivedDataProcessing(DbName,Tbl,AppDataType,workflowId,ifDataArchivingOnboarded)
	 select DbArchivingName,Tbl,AppDataType,workflowId,case when RetentionDays is not null then 'Y' else 'N' end
	 from core.DataArchivingAndPurgingConfig
	 where DbArchivingName = db_name() and AppDataType = @AppDataType

	 ;with LOB
	 as
	 (select schema_name(o.schema_id) as schemaName, o.name as [Table],c.name as [column],
	 t.name as [Large datatype],c.length
	 from sys.objects o join sys.syscolumns c
	 on o.object_id = c.id and o.type = 'U'
	 join systypes t
	 on c.xtype = t.xtype and (t.name in ('image','text','xml') or (c.length = -1 and t.name <> 'sysname')))
	 update dal
	 set hasLOBcolumn = 'Y'
	 from core.ExpiredArchivedDataProcessing as dal 
	 join LOB 
	 on dal.DbName = db_name() and dal.AppDataType = LOB.schemaName and dal.Tbl = LOB.[Table]
	 and AppDataType = @AppDataType
	 
	 update core.ExpiredArchivedDataProcessing
	 set hasLOBcolumn = 'Y'
	 where hasLOBcolumn is null
	 and DbName = db_name() and AppDataType = @AppDataType

	 --add timestamp to not active tables
	 update a
	 set PurgeExpiredDataOlderThan = dateadd(dd,-1*(c.RetentionDays),@DataPurgeStart),StartDate = @DataPurgeStart
	 from core.ExpiredArchivedDataProcessing a join core.DataArchivingAndPurgingConfig c
	 on c.DbName = a.DbName and c.Tbl = a.Tbl and c.AppDataType = a.AppDataType
	 where c.AppDataType = @AppDataType and a.ifDataArchivingOnboarded <> 'Y'

end
else
begin

	 --move data archiving from previous run into a history of archiving summary
	   insert core.ControlPurgeOfExpiredArchivedData_History
	   select * from core.ControlPurgeOfExpiredArchivedData
	   where DbName = db_name() and AppDataType = @AppDataType

	   --Move errors from previous run into the history log
	   insert core.ExpiredArchivedDataProcessing_History
	   select * from core.ExpiredArchivedDataProcessing
	   where Error is not null 

	   --Clear errors from from current log before the next run so it will log only its errors
	   update core.ExpiredArchivedDataProcessing
	   set Error = null
	   where Error is not null

	   select @DataPurgeStart = DataPurgeStarted
	   from core.ControlPurgeOfExpiredArchivedData
	   where DbName = db_name() and AppDataType = @AppDataType

		update core.ControlPurgeOfExpiredArchivedData
		set Orig_DbSpace_Used_GB = Space_used_in_GB
		,Orig_DbAvailable_Space_GB = Available_Space_in_GB
		,Orig_Percent_Used = Percent_Used
		,CurrentRunStarted = @StartOfCurrentRun
		,CurentRunEnded = null
		,Updated_DbSpace_Used_GB = null
		,Updated_DbAvailable_Space_GB = null
		,Updated_Percent_Used = null
		from TFM.dbo.dbstats
		where ControlPurgeOfExpiredArchivedData.DbName = db_name() and ControlPurgeOfExpiredArchivedData.AppDataType = @AppDataType

end

GO
