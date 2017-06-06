
SELECT 
         COALESCE(DB_NAME(st.dbid), 
                  DB_NAME(CAST(pa.value AS INT))+'*', 
                 'Resource') AS [Database Name]  
         -- find the offset of the actual statement being executed
         ,cast(SUBSTRING(text, 
                   CASE WHEN statement_start_offset = 0 
                          OR statement_start_offset IS NULL  
                           THEN 1  
                           ELSE statement_start_offset/2 + 1 END, 
                   CASE WHEN statement_end_offset = 0 
                          OR statement_end_offset = -1  
                          OR statement_end_offset IS NULL  
                           THEN LEN(text)  
                           ELSE statement_end_offset/2 END - 
                     CASE WHEN statement_start_offset = 0 
                            OR statement_start_offset IS NULL 
                             THEN 1  
                             ELSE statement_start_offset/2  END + 1 
                  ) as varchar(8000))  AS [Statement]   
         ,cp.objtype [Cached Plan objtype] 
         ,execution_count [Execution Count] 
         ,UseCounts				--Number of times this cache object has been used since its inception
		 ,size_in_bytes			--Number of bytes consumed by the cache object    
		 ,plan_generation_num	--A sequence number that can be used to distinguish between instances of plans after a recompile.
		 ,convert(varchar(40),creation_time,13) as plan_compiled_time
		 ,convert(varchar(40),last_execution_time,13) as [Last Execution Time]
         ,(total_logical_reads + total_logical_writes + total_physical_reads )/execution_count [Average IOs] 
         ,total_logical_reads + total_logical_writes + total_physical_reads [Total IOs]  
         ,total_logical_reads/execution_count [Avg Logical Reads] 
         ,total_logical_reads [Total Logical Reads]  
         ,total_logical_writes/execution_count [Avg Logical Writes]  
         ,total_logical_writes [Total Logical Writes]  
         ,total_physical_reads/execution_count [Avg Physical Reads] 
         ,total_physical_reads [Total Physical Reads]   
         ,total_worker_time / execution_count [Avg CPU] 
         ,total_worker_time [Total CPU] 
         ,total_elapsed_time / execution_count [Avg Elapsed Time] 
         ,total_elapsed_time  [Total Elasped Time] 
         ,cast(s3.query_plan as xml) as query_plan 
    INTO #t
    FROM sys.dm_exec_query_stats qs  
    JOIN sys.dm_exec_cached_plans cp ON qs.plan_handle = cp.plan_handle 
    CROSS APPLY sys.dm_exec_sql_text(qs.plan_handle) st 
    cross apply sys.dm_exec_text_query_plan(qs.plan_handle,statement_start_offset,statement_end_offset) as s3
    OUTER APPLY sys.dm_exec_plan_attributes(qs.plan_handle) pa 
    WHERE attribute = 'dbid' AND  
    DB_NAME(st.dbid) in ('FALCON_SRF_FX','FALCON_SRF_FX_Cache') 
    
           
    SELECT * FROM #t
    where [Cached Plan objtype] = 'Adhoc' and [Execution Count] = 1 and  [Average IOs]>= 1000
    ORDER BY [Database Name], [Average IOs] desc, [Last Execution Time] desc


--drop table #t
