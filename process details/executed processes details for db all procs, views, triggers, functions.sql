
declare @tmp table
(
	[dbname] [nvarchar](128) NULL,
	[ObjectName] [varchar](400) NULL,
	[ObjType] [varchar](40) NULL,
	[objectid] [int] NULL,
	[sql_statement] [nvarchar](max) NULL,
	[last_execution_time] [datetime] NOT NULL,
	[last_elapsed_time_in_microseconds] [bigint] NOT NULL,
	[max_elapsed_time] [bigint] NOT NULL,
	[min_elapsed_time] [bigint] NOT NULL,
	[execution_count] [bigint] NOT NULL,
	[UseCounts] [int] NOT NULL,
	[size_in_bytes] [int] NOT NULL,
	[plan_generation_num] [bigint] NOT NULL,
	[plan_compiled_time] [datetime] NOT NULL,
	[last_physical_reads] [bigint] NOT NULL,
	[total_physical_reads] [bigint] NOT NULL,
	[min_physical_reads] [bigint] NOT NULL,
	[max_physical_reads] [bigint] NOT NULL,
	total_logical_reads [bigint] NOT NULL,
	[total_logical_writes] [bigint] NOT NULL,
	[last_logical_writes] [bigint] NOT NULL,
	[min_logical_writes] [bigint] NOT NULL,
	[max_logical_writes] [bigint] NOT NULL,
	[query_plan] [xml] NULL
)

insert @tmp
SELECT db_name(s2.dbid) dbname,
    convert(varchar(400), '') as ObjectName,
    convert(varchar(40) ,'') as ObjType,
    s3.objectid,  
    --s2.text, 
    (SELECT TOP 1 SUBSTRING(s2.text,statement_start_offset / 2+1 , 
      ( (CASE WHEN statement_end_offset = -1 
         THEN (LEN(CONVERT(nvarchar(max),s2.text)) * 2) 
         ELSE statement_end_offset END)  - statement_start_offset) / 2+1))  AS sql_statement,
    last_execution_time,
    last_elapsed_time as last_elapsed_time_in_microseconds,
    max_elapsed_time, 
    min_elapsed_time,   
    execution_count,		--Number of times that the plan has been executed since it was last compiled
    UseCounts,				--Number of times this cache object has been used since its inception
	size_in_bytes,			--Number of bytes consumed by the cache object    
    plan_generation_num,	--A sequence number that can be used to distinguish between instances of plans after a recompile.
    creation_time as plan_compiled_time,   
    last_physical_reads,
    total_physical_reads,  
    min_physical_reads,  
    max_physical_reads,
    total_logical_reads,  
    total_logical_writes, 
    last_logical_writes, 
    min_logical_writes, 
    max_logical_writes
	,s3.query_plan   
FROM sys.dm_exec_query_stats AS s1
join sys.dm_exec_cached_plans as p
on s1.plan_handle = p.plan_handle 
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS s2
cross apply sys.dm_exec_text_query_plan(s1.plan_handle,statement_start_offset,statement_end_offset) as s3
--WHERE db_name(s2.dbid) in ('FALCON_SRF_FX','FALCON_SRF_FX_Cache')
WHERE db_name(s2.dbid) = DB_NAME() 

update @tmp
set 
ObjectName = name,
ObjType = case type 
when 'P' then 'proc'
when 'TR' then 'trigger'
when 'TF' then 'table function'
when 'V' then 'view'
when 'IF' then 'In-lined table-function'
when 'FN' then 'Scalar function'
when 'D' then 'default'
when 'L' then 'Log'  
when 'K' then 'PRIMARY KEY or UNIQUE constraint'
when 'F' then 'FOREIGN KEY constraint'
end 
from sysobjects
where id = objectid

-- Detailed stats
select 
	[dbname],
	[ObjectName],
	[ObjType],
	[sql_statement],
	convert(varchar(24), last_execution_time, 9) as last_execution_time,
	[last_elapsed_time_in_microseconds],
	[max_elapsed_time],
	[min_elapsed_time],
	[execution_count],
	[UseCounts],
	[size_in_bytes],
	[plan_generation_num],
	convert(varchar(24), plan_compiled_time, 9) as plan_compiled_time,
	[last_physical_reads],
	[total_physical_reads],
	[min_physical_reads],
	[max_physical_reads],
	total_logical_reads,
	[total_logical_writes],
	[last_logical_writes],
	[min_logical_writes],
	[max_logical_writes],
	[query_plan] 
from @tmp
--where dbname = '-' -
--and ObjectName = ''
--where ObjType in ('proc','trigger')
--where convert(varchar(24),last_execution_time,101) = '02262013'
--order by ObjectName, (total_logical_reads + total_logical_writes + total_physical_reads)  execution_count desc
--order by (total_logical_reads + total_logical_writes + total_physical_reads)  execution_count desc
--order by last_execution_time
order by ObjectName,max_elapsed_time desc, execution_count -- by max CPU elapsed time
--order by dbname,last_execution_time desc, last_elapsed_time_in_microseconds desc, execution_count -- by latest execution
--order by last_elapsed_time_in_microseconds desc, last_execution_time, execution_count -- by CPU 
--order by last_physical_reads desc, last_execution_time, execution_count -- by physical IO
--order by last_logical_writes desc, last_execution_time, execution_count -- by logical IO

--Summarized stats
declare @tmp1 table 
(
dbname [nvarchar](128) NULL, 
ObjectName [nvarchar](400) NULL, 
ObjType [varchar](40) NULL, 
total_execution_count int
)

insert @tmp1
select dbname, ObjectName, ObjType, sum(execution_count) as total_execution_count
from @tmp
where ObjType in ('proc','trigger')
group by dbname, ObjectName, ObjType

;with cte as 
(
select @@servername as [Instance name], DB_NAME() as dbname, '' as ObjectName,'' as ObjType, '' as total_execution_count,
 (select cast(crdate as varchar(24)) from master..sysdatabases where name='tempdb') as [Since instance recycle on] 
union all
select '', '', ObjectName, ObjType, cast(total_execution_count as varchar(max)),'' from @tmp1
where ObjectName like 'sfreport%'
)
select * from cte
order by dbname desc,ObjType, ObjectName


go

