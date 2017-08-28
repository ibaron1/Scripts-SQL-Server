USE TFM_Archive
GO

if object_id('tfm.PurgeExpiredArchivedDataFinalSteps') is not null
  drop proc tfm.PurgeExpiredArchivedDataFinalSteps
go

/****************************************************************************************************************************************
Author. Eli Baron
Date created. 8-9-17
Purpose. Jira WMTRACAPGO-336, End of current archiving cycle or cycle's run, is to be called from PurgeExpiredArchivedDataForAllWorkflows
****************************************************************************************************************************************/
create proc tfm.PurgeExpiredArchivedDataFinalSteps
@AppDataType varchar(20),
@EndOfCurrentRun char(1)
as

set nocount on
set transaction isolation level read uncommitted
set dateformat mdy

;with after_del
as
(select sum(cast(round(size/128.0, 0) as int)) as size_in_MB,
	sum(cast(round(fileproperty(name, 'SpaceUsed')/128.0,0) as int)) as Space_used_in_MB,
	sum(cast(round(size/128.0-(fileproperty(name, 'SpaceUsed')/128.0),0) as int)) as Available_Space_in_MB,
	cast(cast(round(sum(cast(fileproperty(name, 'SpaceUsed')/128.0 as dec(10,2)))/sum(cast(size/128.0 as dec(10,2)))*100,0) as int) as varchar(10))+'%' as Percent_Used
	from sys.database_files
	where type_desc = 'rows'
	group by type_desc)
update tfm.ControlPurgeOfExpiredArchivedData
set Updated_DbSpace_Used_MB = Space_used_in_MB
,Updated_DbAvailable_Space_MB = Available_Space_in_MB
,Updated_Percent_Used = Percent_Used
,CurentRunEnded = getdate()
,DataPurgeEnded = case when @EndOfCurrentRun = 'N' then getdate() end
from after_del
where  ControlPurgeOfExpiredArchivedData.DbName = db_name() and AppDataType = @AppDataType

GO
