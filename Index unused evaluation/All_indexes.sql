select object_name(i.id) as tbl, i.name
--into #indexes
from sysindexes i join sysobjects o
on o.name = object_name(i.id) and o.type='U'
where o.name not like 'sys%' and o.name not like 'rs%'
and (indid  > 0 and lockscheme(i.id, db_id()) = 'allpages') or (indid  > 1 and lockscheme(i.id, db_id()) <> 'allpages')
order by o.name