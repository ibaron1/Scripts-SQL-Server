use TFM_Archive;

declare @t table
(name sysname,
 [type] sysname,
 updated sysname,
 selected sysname,
 [column] sysname null)


insert @t
exec sp_depends 'core.PurgeExpiredArchivedDataForWorkflow'

select distinct name
into #t1
from @t 
where name like 'tfm.%'
order by name

select s.name+'.'+o.name as name
into #t2
from TFM.sys.objects as o
join TFM.sys.schemas as s
on o.schema_id = s.schema_id
where type = 'U' and s.name = 'tfm'


select * from #t2
where name not in (select name from #t1)
and name not in ('tfm.WorkflowKeyAttributes','tfm.Workflow','tfm.entitlement')

drop table #t1, #t2