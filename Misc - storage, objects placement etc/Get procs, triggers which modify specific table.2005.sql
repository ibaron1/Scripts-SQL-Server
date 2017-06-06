set nocount on

declare @Object varchar(30)
set @Object = 'SimHistory'

declare @cmd table(cmd char(9))
insert @cmd select 'insert%%'
insert @cmd select 'delete%%' 
insert @cmd select 'update%%'

select distinct object_name(m.object_id) 'Proc/trigger', o.type, m.definition
from sys.sql_modules m join sysobjects o
on m.object_id = o.id
and o.type <> 'V' and object_name(m.object_id) not like '%[_]backup%'
join @cmd cm
on m.definition like '%'+cm.cmd+@Object+'%'
order by object_name(m.object_id)