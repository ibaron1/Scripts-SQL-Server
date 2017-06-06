declare @DBNAME VARCHAR(128) = '<not supplied>'
 ,@COUNT INT = 999999999
 ,@ORDERBY VARCHAR(4) = 'AIO'

-- Check for valid @ORDERBY parameter
IF ((SELECT CASE WHEN 
          @ORDERBY in ('ACPU','TCPU','AE','TE','EC','AIO','TIO','ALR','TLR','ALW','TLW','APR','TPR') 
             THEN 1 ELSE 0 END) = 0)
BEGIN 
   -- abort if invalid @ORDERBY parameter entered
   RAISERROR('@ORDERBY parameter not APCU, TCPU, AE, TE, EC, AIO, TIO, ALR, TLR, ALW, TLW, APR or TPR',11,1)
   RETURN
 END
 SELECT TOP (@COUNT) 
         COALESCE(DB_NAME(st.dbid), 
                  DB_NAME(CAST(pa.value AS INT))+'*', 
                 'Resource') AS [Database Name]  
         -- find the offset of the actual statement being executed
         ,SUBSTRING(text, 
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
                  )  AS [Statement]  
         ,OBJECT_SCHEMA_NAME(st.objectid,st.dbid) [Schema Name] 
         ,OBJECT_NAME(st.objectid,st.dbid) [Object Name]   
         ,cp.objtype [Cached Plan objtype] 
         ,execution_count [Execution Count] 
         ,UseCounts				--Number of times this cache object has been used since its inception
		 ,size_in_bytes			--Number of bytes consumed by the cache object    
		 ,plan_generation_num	--A sequence number that can be used to distinguish between instances of plans after a recompile.
		 ,convert(varchar(40),creation_time,21) as plan_compiled_time
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
         ,convert(varchar(40),last_execution_time,21) as [Last Execution Time]
         ,cast(s3.query_plan as xml) as query_plan 
    FROM sys.dm_exec_query_stats qs  
    JOIN sys.dm_exec_cached_plans cp ON qs.plan_handle = cp.plan_handle 
    CROSS APPLY sys.dm_exec_sql_text(qs.plan_handle) st 
    cross apply sys.dm_exec_text_query_plan(qs.plan_handle,statement_start_offset,statement_end_offset) as s3
    OUTER APPLY sys.dm_exec_plan_attributes(qs.plan_handle) pa 
    WHERE attribute = 'dbid' AND  
     CASE when @DBNAME = '<not supplied>' THEN '<not supplied>'
                               ELSE COALESCE(DB_NAME(st.dbid), 
                                          DB_NAME(CAST(pa.value AS INT)) + '*', 
                                          'Resource') END
                                    IN (RTRIM(@DBNAME),RTRIM(@DBNAME) + '*')  
      AND cp.objtype in ('Adhoc', 'Prepared') 
    ORDER BY CASE 
                WHEN @ORDERBY = 'ACPU' THEN total_worker_time / execution_count 
                WHEN @ORDERBY = 'TCPU'  THEN total_worker_time
                WHEN @ORDERBY = 'AE'   THEN total_elapsed_time / execution_count
                WHEN @ORDERBY = 'TE'   THEN total_elapsed_time  
                WHEN @ORDERBY = 'EC'   THEN execution_count
                WHEN @ORDERBY = 'AIO'  THEN (total_logical_reads + total_logical_writes + total_physical_reads) / execution_count  
                WHEN @ORDERBY = 'TIO'  THEN total_logical_reads + total_logical_writes + total_physical_reads
                WHEN @ORDERBY = 'ALR'  THEN total_logical_reads  / execution_count
                WHEN @ORDERBY = 'TLR'  THEN total_logical_reads 
                WHEN @ORDERBY = 'ALW'  THEN total_logical_writes / execution_count
                WHEN @ORDERBY = 'TLW'  THEN total_logical_writes  
                WHEN @ORDERBY = 'APR'  THEN total_physical_reads / execution_count 
                WHEN @ORDERBY = 'TPR'  THEN total_physical_reads
           END DESC