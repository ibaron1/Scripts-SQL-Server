use TFM_Archive
go

if object_id('core.DataArchiveFinalSteps') is not null
  drop proc core.DataArchiveFinalSteps
go

/*****************************************************************************************************************************
Author. Eli Baron
Date created. 8-9-17
Purpose. End of current archiving cycle or cycle's run, is to be called from DataArchivingForAllWorkflows
Date modified. 8-29-17
 Moved to core schema
******************************************************************************************************************************/
create proc core.DataArchiveFinalSteps
@AppDataType varchar(20),
@EndOfCurrentRun char(1),
@DbName varchar(128)
as

set nocount on
set transaction isolation level read uncommitted
set dateformat mdy

update core.ControlOfDataArchiving
set Updated_DbSpace_Used_GB = Space_used_in_GB
,Updated_DbAvailable_Space_GB = Available_Space_in_GB
,Updated_Percent_Used = Percent_Used
,CurentRunEnded = getdate()
,DataArchivingEnded = case when @EndOfCurrentRun = 'N' then getdate() end
from TFM.dbo.dbstats
where ControlOfDataArchiving.DbName = @DbName and ControlOfDataArchiving.AppDataType = @AppDataType


GO
