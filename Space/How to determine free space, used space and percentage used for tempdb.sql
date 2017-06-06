use tempdb;

SELECT cast(getdate() as varchar(24)) as [Checked on], @@servername as Instance, db_name(b.database_id) as DbName,
   case b.type_desc when 'ROWS' then 'DATA' else type_desc end as Space_Type,
   sum(CAST(a.size/128.0 AS DECIMAL(10,2))) AS Size_in_MB,
   sum(CAST(FILEPROPERTY(a.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2))) AS Space_Used_in_MB,
   sum(CAST(a.size/128.0-(FILEPROPERTY(a.name, 'SpaceUsed')/128.0) AS DECIMAL(10,2))) AS Available_Space_in_MB,
   cast(CAST(sum(CAST(FILEPROPERTY(a.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2)))/sum(CAST(a.size/128.0 AS DECIMAL(10,2)))*100 AS DECIMAL(10,2)) as varchar(10))+'%' AS Percent_Used
FROM sysfiles a join master.sys.master_files b
on a.fileid = b.file_id
where db_name(b.database_id)  = DB_NAME()
group by b.database_id, b.type_desc
order by b.database_id desc, b.type_desc desc