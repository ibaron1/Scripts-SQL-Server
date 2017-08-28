USE TFM_Archive
GO

if object_id('tfm.PurgeExpiredArchivedDataInitialSteps') is not null
  drop proc tfm.PurgeExpiredArchivedDataInitialSteps
go

/****************************************************************************************************************************************
Author. Eli Baron
Date created. 8-9-17
Purpose. Jira WMTRACAPGO-336, Start new or restart current archiving cycle, is to be called from PurgeExpiredArchivedDataForAllWorkflows
****************************************************************************************************************************************/
create proc tfm.PurgeExpiredArchivedDataInitialSteps
@AppDataType varchar(20),
@DataPurgeStart datetime
as

set nocount on
set transaction isolation level read uncommitted
set dateformat mdy

declare @StartOfCurrentRun datetime = getdate()
declare @PurgeExpiredDataOlderThan datetime

if exists (select 1 from tfm.ControlPurgeOfExpiredArchivedData where DbName = db_name()
  and AppDataType = @AppDataType and DataPurgeEnded is not null)
or not exists (select 1 from tfm.ControlPurgeOfExpiredArchivedData where DbName = db_name()
  and AppDataType = @AppDataType)
begin
	delete tfm.ControlPurgeOfExpiredArchivedData
	output deleted.* into tfm.ControlPurgeOfExpiredArchivedData_History
	where DbName = db_name() and AppDataType = @AppDataType

	insert tfm.ControlPurgeOfExpiredArchivedData
	(DbName,
	 DbSize_MB,
	 Orig_DbSpace_Used_MB ,
	 Orig_DbAvailable_Space_MB,
	 Orig_Percent_Used,
	 AppDataType,
	 DataPurgeStarted,
	 CurrentRunStarted)
	 select db_name() as DbName,
	 sum(cast(round(size/128.0, 0) as int)) as size_in_MB,
	 sum(cast(round(fileproperty(name, 'SpaceUsed')/128.0,0) as int)) as Space_used_in_MB,
	 sum(cast(round(size/128.0-(fileproperty(name, 'SpaceUsed')/128.0),0) as int)) as Available_Space_in_MB,
	 cast(cast(round(sum(cast(fileproperty(name, 'SpaceUsed')/128.0 as dec(10,2)))/sum(cast(size/128.0 as dec(10,2)))*100,0) as int) as varchar(10))+'%' as Percent_Used
	 ,@AppDataType
	 ,@DataPurgeStart
	 ,@StartOfCurrentRun
	 from sys.database_files
		 where type_desc = 'rows'
	 group by type_desc
	 
	 delete tfm.ExpiredArchivedDataProcessing
	 output deleted.* into tfm.ExpiredArchivedDataProcessing_History
	 where DbName = db_name() and AppDataType = @AppDataType

	 insert tfm.ExpiredArchivedDataProcessing(DbName,Tbl,AppDataType,workflowId,ifDataArchivingOnboarded)
	 select DbArchivingName,Tbl,AppDataType,workflowId,case when RetentionDays is not null then 'Y' else 'N' end
	 from tfm.DataArchivingAndPurgingConfig
	 where DbArchivingName = db_name() and AppDataType = @AppDataType

	 ;with LOB
	 as
	 (select (schema_name(o.schema_id)+'.'+o.name) as [Table],c.name as [column],
	 t.name as [Large datatype],c.length
	 from sys.objects o join sys.syscolumns c
	 on o.object_id = c.id and o.type = 'U'
	 join systypes t
	 on c.xtype = t.xtype and (t.name in ('image','text','xml') or (c.length = -1 and t.name <> 'sysname')))
	 update dal
	 set hasLOBcolumn = 'Y'
	 from tfm.ExpiredArchivedDataProcessing as dal 
	 join LOB 
	 on DbName = db_name() and dal.Tbl = LOB.[Table]
	 and AppDataType = @AppDataType
	 
	 update tfm.ExpiredArchivedDataProcessing
	 set hasLOBcolumn = 'Y'
	 where hasLOBcolumn is null
	 and DbName = db_name() and AppDataType = @AppDataType

	 --add timestamp to not active tables
	 update a
	 set PurgeExpiredDataOlderThan = dateadd(dd,-1*(c.RetentionDays),@DataPurgeStart),StartDate = @DataPurgeStart
	 from tfm.ExpiredArchivedDataProcessing a join tfm.DataArchivingAndPurgingConfig c
	 on c.DbName = a.DbName and c.Tbl = a.Tbl and c.AppDataType = a.AppDataType
	 where c.AppDataType = @AppDataType and a.ifDataArchivingOnboarded <> 'Y'

end
else
begin

	 --move data archiving from previous run into a history of archiving summary
	   insert tfm.ControlPurgeOfExpiredArchivedData_History
	   select * from tfm.ControlPurgeOfExpiredArchivedData
	   where DbName = db_name() and AppDataType = @AppDataType

	   --Move errors from previous run into the history log
	   insert tfm.ExpiredArchivedDataProcessing_History
	   select * from tfm.ExpiredArchivedDataProcessing
	   where Error is not null 

	   --Clear errors from from current log before the next run so it will log only its errors
	   update tfm.ExpiredArchivedDataProcessing
	   set Error = null
	   where Error is not null

	   select @DataPurgeStart = DataPurgeStarted
	   from tfm.ControlPurgeOfExpiredArchivedData
	   where DbName = db_name() and AppDataType = @AppDataType

	   ;with cur_arch
	   as
	   (select sum(cast(round(size/128.0, 0) as int)) as size_in_MB,
		 sum(cast(round(fileproperty(name, 'SpaceUsed')/128.0,0) as int)) as Space_used_in_MB,
		 sum(cast(round(size/128.0-(fileproperty(name, 'SpaceUsed')/128.0),0) as int)) as Available_Space_in_MB,
		 cast(cast(round(sum(cast(fileproperty(name, 'SpaceUsed')/128.0 as dec(10,2)))/sum(cast(size/128.0 as dec(10,2)))*100,0) as int) as varchar(10))+'%' as Percent_Used
		 from sys.database_files
		 where type_desc = 'rows'
		 group by type_desc)
		update tfm.ControlPurgeOfExpiredArchivedData
		set Orig_DbSpace_Used_MB = Space_used_in_MB
		,Orig_DbAvailable_Space_MB = Available_Space_in_MB
		,Orig_Percent_Used = Percent_Used
		,CurrentRunStarted = @StartOfCurrentRun
		,CurentRunEnded = null
		,Updated_DbSpace_Used_MB = null
		,Updated_DbAvailable_Space_MB = null
		,Updated_Percent_Used = null
		from cur_arch
		where  DbName = db_name() and AppDataType = @AppDataType

end

GO
