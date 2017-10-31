declare @t table
(name sysname,
 [type] sysname,
 updated sysname,
 selected sysname,
 [column] sysname null)


insert @t
exec sp_depends 'core.PurgeExpiredArchivedDataForWorkflow'

select distinct name, type 
from @t 
where name not like 'core.%'
order by name