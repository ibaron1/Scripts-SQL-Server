-- Indexes only
SELECT @@servername as Instance, schema_name(schema_id)+'.'+o.name as tblName, i.name as indexName, indid, reserved*8/1024.0 as reserved_MB, 
used*8/1024.0 as used_MB
FROM sysindexes i join sys.objects o
on i.id = o.object_id and type = 'U'
WHERE indid >=1
order by reserved_MB desc

-- Tables only
SELECT @@servername as Instance, schema_name(schema_id)+'.'+o.name as tblName, isnull(i.name,'heap - table') as indexName, indid, reserved*8/1024.0 as reserved_MB, 
used*8/1024.0 as used_MB
FROM sysindexes i join sys.objects o
on i.id = o.object_id and type = 'U'
WHERE indid  = 0
order by reserved_MB desc

-- Space for all Tables and their indexes 

SELECT @@servername as Instance, db_name() as DbName, schema_name(schema_id)+'.'+o.name as tblName, i.name as indexName, indid, 
cast(round(reserved*8/1024/1024.0, 2) as dec(20,2)) as reserved_GB, 
cast(round(reserved*8/1024.0, 2) as int) as reserved_MB, 
cast(round(used*8/1024/1024.0, 2) as dec(20,2)) as used_GB,
cast(round(used*8/1024.0, 2) as int) as used_MB
FROM sysindexes i join sys.objects o
on i.id = o.object_id and type = 'U'
order by reserved_MB desc

-- Space for Some Tables and their indexes 

SELECT @@servername as Instance, schema_name(schema_id)+'.'+o.name as tblName, i.name as indexName, indid, 
cast(round(reserved*8/1024.0, 2) as dec(20,2)) as reserved_MB, 
cast(round(used*8/1024.0, 2) as dec(20,2)) as used_MB
FROM sysindexes i join sys.objects o
on i.id = o.object_id and type = 'U'
WHERE schema_name(schema_id)+'.'+o.name in ('srf_main.TradeMessagePayload')
order by reserved_MB desc



-- Sum of Space used for some tables and their indexes
SELECT @@servername as Instance, schema_name(schema_id)+'.'+o.name as tblName, sum(reserved*8/1024.0) as reserved_MB, 
sum(used*8/1024.0) as used_MB
FROM sysindexes i join sys.objects o
on i.id = o.object_id and type = 'U'
--WHERE indid in (0,1)
where schema_name(schema_id)+'.'+o.name in ('srf_main.BCPValAgg','srf_main.EODBusinessException')
group by schema_name(schema_id)+'.'+o.name
order by reserved_MB desc
