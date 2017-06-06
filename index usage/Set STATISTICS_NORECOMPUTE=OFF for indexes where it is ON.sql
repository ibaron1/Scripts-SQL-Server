set nocount on
select 'alter index ['+s.name+'] on '+schema_name(o.schema_id)+'.'+o.name+' set (STATISTICS_NORECOMPUTE=OFF);' 
from sys.stats s join sys.objects o
on s.object_id = o.object_id and type='U'
where no_recompute = 1
order by o.name
