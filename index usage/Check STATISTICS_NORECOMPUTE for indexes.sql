-- Get all indexes in a db

select @@servername as instance, db_name() as dbName, 
schema_name(o.schema_id) as [schema_name], o.name as [Table],
s.name as [Index],
case no_recompute when 1 then 'ON' else 'OFF' end as [STATISTICS_NORECOMPUTE] 
from sys.stats s join sys.objects o
on s.object_id = o.object_id and type='U'
where no_recompute = 1
order by o.name

-- check for a tbl

select object_name(object_id) as Tbl,name as [Index],
case no_recompute when 1 then 'ON' else 'OFF' end as [STATISTICS_NORECOMPUTE] 
from sys.stats
where object_id=object_id('srf_main.TradeMessagePayload')