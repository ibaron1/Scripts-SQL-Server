-- by file and its type
SELECT cast(getdate() as varchar(24)) as [Checked on], @@servername as Instance, db_name(b.database_id) as DbName,
   b.type_desc,
   a.filename AS [File Name],
   CAST(a.size/128.0 AS DECIMAL(10,2)) AS [Size in MB],
   CAST(FILEPROPERTY(a.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2)) AS [Space Used],
   CAST(a.size/128.0-(FILEPROPERTY(a.name, 'SpaceUsed')/128.0) AS DECIMAL(10,2)) AS [Available Space],
   CAST((CAST(FILEPROPERTY(a.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2))/CAST(a.size/128.0 AS DECIMAL(10,2)))*100 AS DECIMAL(10,2)) AS [Percent Used]
FROM sysfiles a join master.sys.master_files b
on a.fileid = b.file_id
where db_name(b.database_id) = DB_NAME()
order by b.type_desc desc

-- summary for db by data and log portion

SELECT cast(getdate() as varchar(24)) as [Checked on], @@servername as Instance, db_name(b.database_id) as DbName,
   case b.type_desc when 'LOG' then 'LOG' else 'DATA' end as Space_Type,
   sum(CAST(a.size/128.0 AS DECIMAL(10,2))) AS Size_in_MB,
   sum(CAST(FILEPROPERTY(a.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2))) AS Space_Used_in_MB,
   sum(CAST(a.size/128.0-(FILEPROPERTY(a.name, 'SpaceUsed')/128.0) AS DECIMAL(10,2))) AS Available_Space_in_MB,
   cast(CAST(sum(CAST(FILEPROPERTY(a.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2)))/sum(CAST(a.size/128.0 AS DECIMAL(10,2)))*100 AS DECIMAL(10,2)) as varchar(10))+'%' AS Percent_Used
FROM sysfiles a join master.sys.master_files b
on a.fileid = b.file_id
where db_name(b.database_id) = DB_NAME()
group by b.database_id, 
case b.type_desc when 'LOG' then 'LOG' else 'DATA' end


SELECT cast(getdate() as varchar(24)) as [Checked on], @@servername as Instance, db_name(b.database_id) as DbName,
   case b.type_desc when 'ROWS' then 'DATA' else type_desc end as Space_Type,
   sum(CAST(a.size/128.0 AS DECIMAL(10,2))) AS Size_in_MB,
   sum(CAST(FILEPROPERTY(a.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2))) AS Space_Used_in_MB,
   sum(CAST(a.size/128.0-(FILEPROPERTY(a.name, 'SpaceUsed')/128.0) AS DECIMAL(10,2))) AS Available_Space_in_MB,
   cast(CAST(sum(CAST(FILEPROPERTY(a.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2)))/sum(CAST(a.size/128.0 AS DECIMAL(10,2)))*100 AS DECIMAL(10,2)) as varchar(10))+'%' AS Percent_Used
FROM sysfiles a join master.sys.master_files b
on a.fileid = b.file_id
where db_name(b.database_id) = DB_NAME()
group by b.database_id, b.type_desc
order by b.database_id, b.type_desc desc


-- Get space used for some tables

SELECT cast(getdate() as varchar(24)) as [Checked on], @@servername as Instance, schema_name(schema_id)+'.'+o.name as tblName, 
sum(reserved*8/1024.0) as reserved_MB, 
sum(used*8/1024.0) as used_MB
FROM sysindexes i join sys.objects o
on i.id = o.object_id and type = 'U'
--WHERE indid in (0,1)
where schema_name(schema_id)+'.'+o.name in ('srf_main.BCPValAgg','srf_main.EODBusinessException')
group by schema_name(schema_id)+'.'+o.name
order by reserved_MB desc


/*
filename is visible to dbcreator, sysadmin, the database owner with CREATE ANY DATABASE permissions, or grantees that have any one of the following permissions: ALTER ANY DATABASE, CREATE ANY DATABASE, VIEW ANY DEFINITION”  (SQL Server Online Help
*/

	