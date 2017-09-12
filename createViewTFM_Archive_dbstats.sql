use TFM_Archive
go
if object_id('dbo.dbstats') is not null
  drop view dbo.dbstats
go
/*********************************************************
Author. Eli Baron
Date created. 08-29-17
Purpose. get db stats
*********************************************************/
create view dbo.dbstats
as
with spaceStats
as
(select sum(cast(round(size/128.0, 0)/1024 as dec(10,2))) as size_in_GB,
		 sum(cast(round(fileproperty(name, 'SpaceUsed')/128.0,0)/1024 as dec(10,2))) as Space_used_in_GB,
		 sum(cast(round(size/128.0/1024 - (fileproperty(name, 'SpaceUsed')/128.0)/1024,0) as dec(10,2))) as Available_Space_in_GB
from sys.database_files
		 where type_desc = 'rows'
		 group by type_desc)
select db_name() as DbName,
size_in_GB,
Space_used_in_GB,
Available_Space_in_GB,
cast(cast(round(Space_used_in_GB/size_in_GB*100,0) as int) as varchar(10))+'%' as Percent_Used
from spaceStats		 
