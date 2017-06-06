--FX
set nocount on

declare @tblname varchar(200) = 'srf_main.MasterAgreementDetails'

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

select name as tbl 
into #tbls
from sysobjects
where type in ('U', 'V', 'FN', 'IF', 'TF')

select distinct cast(object_name(d.id) as varchar(40)) ObjName, 
case o.type when 'P' then 'Proc' when 'TR' then 'Trigger' when 'V' then 'View' 
			when 'V' then 'view'
			when 'FN' then 'SQL scalar function'
			when 'IF' then 'SQL inline table-valued function'
			when 'TF' then 'SQL table-valued-function' end as ObjType,
cast(object_name(depid) as varchar(40)) as DepObjName,
(select case type 
		when 'U' then 'table' 
		when 'V' then 'view' 
		when 'FN' then 'SQL scalar function'
		when 'IF' then 'SQL inline table-valued function'
		when 'TF' then 'SQL table-valued-function' end
 from sys.objects
 where object_id = d.depid) as DepObjType
into #depObj
from sysdepends d, sys.objects o, #tbls t 
where d.id = o.object_id
and object_name(depid) = t.tbl
and depid = object_id(@tblname)

select * from #depObj
--select * from @tmp

-- Detailed stats
select 
	t.[dbname],
	t.[ObjectName],
	t.[ObjType],
	t.[objectid],
	t.[sql_statement],
	t.[last_execution_time],
	t.[last_elapsed_time_in_microseconds],
	t.[max_elapsed_time],
	t.[min_elapsed_time],
	t.[execution_count],
	t.[UseCounts],
	t.[size_in_bytes],
	t.[plan_generation_num],
	t.[plan_compiled_time],
	t.[last_physical_reads],
	t.[total_physical_reads],
	t.[min_physical_reads],
	t.[max_physical_reads],
	t.total_logical_reads,
	t.[total_logical_writes],
	t.[last_logical_writes],
	t.[min_logical_writes],
	t.[max_logical_writes],
	t.[query_plan] 
from @tmp t join #depObj d
on t.[ObjectName] = d.ObjName
order by ObjectName, max_elapsed_time desc, execution_count desc


drop table #tbls, #depObj
