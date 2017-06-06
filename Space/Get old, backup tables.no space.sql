select distinct @@servername as [sql server], DB_NAME() as [database], schema_name(schema_id)+'.'+name as [table] 
from sys.objects
where type='U' and name like '%back%' or name like '%temp' or name like '%old'
or name like 'orc[_]%' or name like '%[0-9][0-9]%'
order by 3