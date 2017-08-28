use TFM
go

if object_id('tfm.DataArchiveInitialSteps') is not null
  drop proc tfm.DataArchiveInitialSteps
go

/*****************************************************************************************************************************
Author. Eli Baron
Date created. 8-9-17
Purpose. Jira WMTRACAPGO-336, Start new or restart current archiving cycle, is to be called from DataArchivingForAllWorkflows
*****************************************************************************************************************************/
create proc [tfm].[DataArchiveInitialSteps]
@AppDataType varchar(20),
@DataArchivingStarted datetime
as

set nocount on
set transaction isolation level read uncommitted
set dateformat mdy

declare @StartOfCurrentRun datetime = getdate()
declare @ArchiveOlderThan datetime

if exists (select 1 from tfm.ControlOfDataArchiving where DbName = db_name()
  and AppDataType = @AppDataType and DataArchivingEnded is not null)
or not exists (select 1 from tfm.ControlOfDataArchiving where DbName = db_name()
  and AppDataType = @AppDataType)
begin
	delete tfm.ControlOfDataArchiving
	output deleted.* into TFM_Archive.tfm.ControlOfDataArchiving_History
	where DbName = db_name() and AppDataType = @AppDataType

	insert tfm.ControlOfDataArchiving
	(DbName,
	 DbSize_MB,
	 Orig_DbSpace_Used_MB ,
	 Orig_DbAvailable_Space_MB,
	 Orig_Percent_Used,
	 AppDataType,
	 DataArchivingStarted,
	 CurrentRunStarted)
	 select db_name() as DbName,
	 sum(cast(round(size/128.0, 0) as int)) as size_in_MB,
	 sum(cast(round(fileproperty(name, 'SpaceUsed')/128.0,0) as int)) as Space_used_in_MB,
	 sum(cast(round(size/128.0-(fileproperty(name, 'SpaceUsed')/128.0),0) as int)) as Available_Space_in_MB,
	 cast(cast(round(sum(cast(fileproperty(name, 'SpaceUsed')/128.0 as dec(10,2)))/sum(cast(size/128.0 as dec(10,2)))*100,0) as int) as varchar(10))+'%' as Percent_Used
	 ,@AppDataType
	 ,@DataArchivingStarted
	 ,@StartOfCurrentRun
	 from sys.database_files
		 where type_desc = 'rows'
	 group by type_desc

	 delete TFM_Archive.tfm.ArchivingDataProcessing
	 output deleted.* into TFM_Archive.tfm.ArchivingDataProcessing_History
	 where DbName = db_name()+'_Archive' and AppDataType = @AppDataType

	 insert TFM_Archive.tfm.ArchivingDataProcessing(DbName,Tbl,AppDataType,workflowId,ifArchiveOnboarded)
	 select DbName,Tbl,AppDataType,workflowId,case when RetentionDays is not null then 'Y' else 'N' end
	 from TFM_Archive.tfm.DataArchivingAndPurgingConfig
	 where DbName = db_name()and AppDataType = @AppDataType

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
	 from TFM_Archive.tfm.ArchivingDataProcessing as dal 
	 join LOB 
	 on DbName = db_name() and dal.Tbl = LOB.[Table]
	 and AppDataType = @AppDataType
	 
	 update TFM_Archive.tfm.ArchivingDataProcessing
	 set hasLOBcolumn = 'Y'
	 where hasLOBcolumn is null
	 and DbName = db_name() and AppDataType = @AppDataType

	 --add timestamp to not active tables
	 update a
	 set ArchiveOlderThan = dateadd(dd,-1*(c.RetentionDays),@DataArchivingStarted),StartDate = @DataArchivingStarted
	 from TFM_Archive.tfm.ArchivingDataProcessing a join TFM_Archive.tfm.DataArchivingAndPurgingConfig c
	 on c.DbName = a.DbName and c.Tbl = a.Tbl and c.AppDataType = a.AppDataType
	 where c.AppDataType = @AppDataType and a.ifArchiveOnboarded <> 'Y'

end
else
begin

	 --move data archiving from previous run into a history of archiving summary
	   insert TFM_Archive.tfm.ControlOfDataArchiving_History
	   select * from tfm.ControlOfDataArchiving
	   where DbName = db_name() and AppDataType = @AppDataType

	   --Move errors from previous run into the history log
	   insert TFM_Archive.tfm.ArchivingDataProcessing_History
	   select * from TFM_Archive.tfm.ArchivingDataProcessing
	   where Error is not null 

	   --Clear errors from from current log before the next run so it will log only its errors
	   update TFM_Archive.tfm.ArchivingDataProcessing
	   set Error = null
	   where Error is not null

	   select @DataArchivingStarted = DataArchivingStarted
	   from tfm.ControlOfDataArchiving
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
		update tfm.ControlOfDataArchiving
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


