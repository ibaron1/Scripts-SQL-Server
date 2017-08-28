set nocount on
declare @schema varchar(40) = 'tfmload'
declare @t table(tbl varchar(128))
insert @t
values
('Activity'),
('Payload'),
('Request'),
('Step'),
('RequestKeyAttributes')

select schema_name(o.schema_id)+'.'+o.name, rows
from sys.objects as o
join @t as t
	on o.name = t.tbl
join sysindexes as i
	on i.id = o.object_id
and i.indid in (0,1)
order by schema_name(o.schema_id)

SELECT * FROM tfm.ControlOfDataArchiving
--SELECT * FROM tfm.ControlOfDataArchiving_History

SELECT * FROM tfm.ArchivingDataProcessing
--SELECT * FROM tfm.ArchivingDataProcessing_History

/*
truncate table tfm.ControlOfDataArchiving
truncate table tfm.ArchivingDataProcessing

delete tfm.ControlOfDataArchiving_History
where DataArchivingEnded is null

*/
/*
select * from tfm.DataArchivingAndPurgingConfig
*/

