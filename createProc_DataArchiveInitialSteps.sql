use TFM_Archive
go

if object_id('core.DataArchiveInitialSteps') is not null
  drop proc core.DataArchiveInitialSteps
go

/*****************************************************************************************************************************
Author. Eli Baron
Date created. 8-9-17
Purpose. Start new or restart current archiving cycle, is to be called from DataArchivingForAllWorkflows
Date modified. 8-29-17
 Moved to core schema
*****************************************************************************************************************************/
create proc core.DataArchiveInitialSteps
@AppDataType varchar(20),
@DataArchivingStarted datetime,
@DbName varchar(128)
as

set nocount on
set transaction isolation level read uncommitted
set dateformat mdy

declare @StartOfCurrentRun datetime = getdate()
declare @ArchiveOlderThan datetime

if exists (select 1 from core.ControlOfDataArchiving where DbName = @DbName
  and AppDataType = @AppDataType and DataArchivingEnded is not null)
or not exists (select 1 from core.ControlOfDataArchiving where DbName = @DbName
  and AppDataType = @AppDataType)
begin
	delete core.ControlOfDataArchiving
	output deleted.* into core.ControlOfDataArchiving_History
	where DbName = @DbName and AppDataType = @AppDataType

	insert core.ControlOfDataArchiving
	(DbName,
	 DbSize_GB,
	 Orig_DbSpace_Used_GB ,
	 Orig_DbAvailable_Space_GB,
	 Orig_Percent_Used,
	 AppDataType,
	 DataArchivingStarted,
	 CurrentRunStarted)
	 select DbName,
	 size_in_GB,
	 Space_used_in_GB,
	 Available_Space_in_GB,
	 Percent_Used,
	 @AppDataType,
	 @DataArchivingStarted,
	 @StartOfCurrentRun
	 from TFM.dbo.dbstats

	 delete core.ArchivingDataProcessing
	 output deleted.* into core.ArchivingDataProcessing_History
	 where DbName = @DbName and AppDataType = @AppDataType

	 insert core.ArchivingDataProcessing(DbName,Tbl,AppDataType,workflowId,ifArchiveOnboarded)
	 select DbName,Tbl,AppDataType,workflowId,case when RetentionDays is not null then 'Y' else 'N' end
	 from core.DataArchivingAndPurgingConfig
	 where DbName = @DbName and AppDataType = @AppDataType

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
	 from core.ArchivingDataProcessing as dal 
	 join LOB 
	 on DbName = @DbName and dal.AppDataType = LOB.schemaName and dal.Tbl = LOB.[Table]
	 and AppDataType = @AppDataType
	 
	 update core.ArchivingDataProcessing
	 set hasLOBcolumn = 'Y'
	 where hasLOBcolumn is null
	 and DbName = @DbName and AppDataType = @AppDataType

	 --add timestamp to not active tables
	 update a
	 set ArchiveOlderThan = dateadd(dd,-1*(c.RetentionDays),@DataArchivingStarted),StartDate = @DataArchivingStarted
	 from core.ArchivingDataProcessing a join core.DataArchivingAndPurgingConfig c
	 on c.DbName = a.DbName and c.Tbl = a.Tbl and c.AppDataType = a.AppDataType
	 where c.AppDataType = @AppDataType and a.ifArchiveOnboarded <> 'Y'

end
else
begin

	 --move data archiving from previous run into a history of archiving summary
	   insert core.ControlOfDataArchiving_History
	   select * from core.ControlOfDataArchiving
	   where DbName = @DbName and AppDataType = @AppDataType

	   --Move errors from previous run into the history log
	   insert core.ArchivingDataProcessing_History
	   select * from core.ArchivingDataProcessing
	   where Error is not null 

	   --Clear errors from from current log before the next run so it will log only its errors
	   update core.ArchivingDataProcessing
	   set Error = null
	   where Error is not null

	   select @DataArchivingStarted = DataArchivingStarted
	   from core.ControlOfDataArchiving
	   where DbName = @DbName and AppDataType = @AppDataType

		update core.ControlOfDataArchiving
		set Orig_DbSpace_Used_GB = Space_used_in_GB
		,Orig_DbAvailable_Space_GB = Available_Space_in_GB
		,Orig_Percent_Used = Percent_Used
		,CurrentRunStarted = @StartOfCurrentRun
		,CurentRunEnded = null
		,Updated_DbSpace_Used_GB = null
		,Updated_DbAvailable_Space_GB = null
		,Updated_Percent_Used = null
		from TFM.dbo.dbstats
		where ControlOfDataArchiving.DbName = @DbName and ControlOfDataArchiving.AppDataType = @AppDataType

end


GO



