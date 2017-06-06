
-- For a current database
--------------------------
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

---------------------------------------
           Database space only, free %
---------------------------------------
-- DATA
SELECT @@SERVERNAME as SERVER_NAME,DB_NAME() as [DB_Name],
   sum(cast(round(a.size/128.0/1024, 2)as dec(10,2))) AS DATA_SIZE_GB,
   sum(cast(round(fileproperty(a.name, 'SpaceUsed')/128.0/1024, 2)as dec(10,2))) AS USED_SPACE_GB,
   sum(cast(round((a.size/128.0-(fileproperty(a.name, 'SpaceUsed')/128.0))/1024, 2) as dec(10,2))) AS FREE_SPACE_GB,
   cast(CAST(100-sum(CAST(FILEPROPERTY(a.name, 'SpaceUsed')/128.0 as dec(10,2)))/sum(CAST(a.size/128.0 AS DECIMAL(10,2)))*100 AS DECIMAL(10,2)) as varchar(10))+'%' AS [FREE%]
FROM sysfiles a join master.sys.master_files b
on a.fileid = b.file_id
where db_name(b.database_id)  = DB_NAME() and b.type_desc = 'ROWS'
group by b.database_id, b.type_desc

-- TRANSACTION LOG
SELECT @@SERVERNAME as SERVER_NAME,DB_NAME() as [DB_Name],
   sum(cast(round(a.size/128.0/1024, 2)as dec(10,2))) AS LOG_SIZE_GB,
   sum(cast(round(fileproperty(a.name, 'SpaceUsed')/128.0/1024, 2)as dec(10,2))) AS USED_SPACE_GB,
   sum(cast(round((a.size/128.0-(fileproperty(a.name, 'SpaceUsed')/128.0))/1024, 2) as dec(10,2))) AS FREE_SPACE_GB,
   cast(CAST(100-sum(CAST(FILEPROPERTY(a.name, 'SpaceUsed')/128.0 as dec(10,2)))/sum(CAST(a.size/128.0 AS DECIMAL(10,2)))*100 AS DECIMAL(10,2)) as varchar(10))+'%' AS [FREE%]
FROM sysfiles a join master.sys.master_files b
on a.fileid = b.file_id
where db_name(b.database_id)  = DB_NAME() and b.type_desc = 'LOG'
group by b.database_id, b.type_desc

-- For a current database Data part only rounded to int
--------------------------
--USED %
SELECT db_name(b.database_id) as DbName,
sum(cast(round(a.size/128.0, 0) as int)) AS Size_in_MB,
sum(cast(round(fileproperty(a.name, 'SpaceUsed')/128.0, 0) as int)) AS Space_Used_in_MB,
sum(cast(round(a.size/128.0-(fileproperty(a.name, 'SpaceUsed')/128.0), 0) as int)) AS Available_Space_in_MB,
cast(cast(round(sum(cast(fileproperty(a.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2)))/sum(cast(a.size/128.0 AS DECIMAL(10,2)))*100, 0) as int) as varchar(10))+'%' AS Percent_Used
FROM sysfiles a join master.sys.master_files b
on a.fileid = b.file_id
where db_name(b.database_id)  = db_name()
and b.type_desc = 'rows'
group by b.database_id

--FREE % LEFT
SELECT db_name(b.database_id) as DbName,
sum(cast(round(a.size/128.0, 0) as int)) AS Size_in_MB,
sum(cast(round(fileproperty(a.name, 'SpaceUsed')/128.0, 0) as int)) AS Space_Used_in_MB,
sum(cast(round(a.size/128.0-(fileproperty(a.name, 'SpaceUsed')/128.0), 0) as int)) AS Available_Space_in_MB,
cast(cast(100-sum(cast(fileproperty(a.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2)))/sum(CAST(a.size/128.0 AS DECIMAL(10,2)))*100 AS DECIMAL(10,2)) as varchar(10))+'%' AS [Free % left]
FROM sysfiles a join master.sys.master_files b
on a.fileid = b.file_id
where db_name(b.database_id)  = db_name()
and b.type_desc = 'rows'
group by b.database_id



--------------------------
-- For all user databases
--------------------------
SELECT cast(getdate() as varchar(24)) as [Checked on], @@servername as Instance, db_name(b.database_id) as DbName,
   case b.type_desc when 'ROWS' then 'DATA' else type_desc end as Space_Type,
   sum(CAST(a.size/128.0 AS DECIMAL(10,2))) AS Size_in_MB,
   sum(CAST(FILEPROPERTY(a.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2))) AS Space_Used_in_MB,
   sum(CAST(a.size/128.0-(FILEPROPERTY(a.name, 'SpaceUsed')/128.0) AS DECIMAL(10,2))) AS Available_Space_in_MB,
   cast(CAST(sum(CAST(FILEPROPERTY(a.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2)))/sum(CAST(a.size/128.0 AS DECIMAL(10,2)))*100 AS DECIMAL(10,2)) as varchar(10))+'%' AS Percent_Used
FROM sysfiles a join master.sys.master_files b
on a.fileid = b.file_id
where db_name(b.database_id) not in ('master','model','msdb','dbautils','FISAUTILS','tempdb','apputils')
group by b.database_id, b.type_desc
order by b.database_id, b.type_desc desc

-- DB space only, get max available space
-------------------------------------------
;with dbspace
as
(SELECT top 100 percent cast(getdate() as varchar(24)) as [Checked on], @@servername as Instance, db_name(b.database_id) as DbName,
   case b.type_desc when 'ROWS' then 'DATA' else type_desc end as Space_Type,
   sum(CAST(a.size/128.0 AS DECIMAL(10,2))) AS Size_in_MB,
   sum(CAST(FILEPROPERTY(a.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2))) AS Space_Used_in_MB,
   sum(CAST(a.size/128.0-(FILEPROPERTY(a.name, 'SpaceUsed')/128.0) AS DECIMAL(10,2))) AS Available_Space_in_MB,
   cast(CAST(sum(CAST(FILEPROPERTY(a.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2)))/sum(CAST(a.size/128.0 AS DECIMAL(10,2)))*100 AS DECIMAL(10,2)) as varchar(10))+'%' AS Percent_Used
FROM sysfiles a join master.sys.master_files b
on a.fileid = b.file_id
where db_name(b.database_id) not in ('master','model','msdb','dbautils','FISAUTILS','tempdb','apputils')
group by b.database_id, b.type_desc
order by b.database_id, b.type_desc desc)
select * from dbspace
where Space_Type = 'DATA'
order by Available_Space_in_MB desc



/*****************************/

-- For databases based on pattern and tempdb
---------------------------------------------
SELECT cast(getdate() as varchar(24)) as [Checked on], @@servername as Instance, db_name(b.database_id) as DbName,
   case b.type_desc when 'ROWS' then 'DATA' else type_desc end as Space_Type,
   sum(CAST(a.size/128.0 AS DECIMAL(10,2))) AS Size_in_MB,
   sum(CAST(FILEPROPERTY(a.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2))) AS Space_Used_in_MB,
   sum(CAST(a.size/128.0-(FILEPROPERTY(a.name, 'SpaceUsed')/128.0) AS DECIMAL(10,2))) AS Available_Space_in_MB,
   cast(CAST(sum(CAST(FILEPROPERTY(a.name, 'SpaceUsed')/128.0 AS DECIMAL(10,2)))/sum(CAST(a.size/128.0 AS DECIMAL(10,2)))*100 AS DECIMAL(10,2)) as varchar(10))+'%' AS Percent_Used
FROM sysfiles a join master.sys.master_files b
on a.fileid = b.file_id
where db_name(b.database_id) like 'FALCON[_]SRF[_]%' or db_name(b.database_id) = 'tempdb'
group by b.database_id, b.type_desc
order by b.database_id, b.type_desc desc


