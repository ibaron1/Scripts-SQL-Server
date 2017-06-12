DROP FUNCTION dbo.udf_GetCPUUsage
GO

CREATE FUNCTION dbo.udf_GetCPUUsage ()
RETURNS @CPUUsage TABLE
   (
       SQLCPUUtilization       INT,
       SystemIdleProcess       INT,
       OtherCPUUtilization     INT,
       EventTime               DATETIME
   )
AS



/***************************************************************
Purpose:   To retrieve details of the SQL Server and Non-SQL Server CPU
           usage over the past 30 minutes
           
           Scope of the results is for the server
           
           The following DMVs are used:
               sys.dm_os_ring_buffers  - undocumented in BOL
          
          
Author:        Unknown
History:   7 May 2012 - Initial Issue  
           2 Jul 2012 - ChillyDBA - Converted to a table valued function

****************************************************************/

BEGIN
   -- Get CPU Utilization History for last 30 minutes (in one minute intervals)
   -- This version works with SQL Server 2008 and SQL Server 2008 R2 only
   DECLARE @ts_now bigint = (SELECT cpu_ticks/(cpu_ticks/ms_ticks)FROM sys.dm_os_sys_info); 

   INSERT @CPUUsage
       (
           SQLCPUUtilization,
           SystemIdleProcess,
           OtherCPUUtilization,
           EventTime
       )
   SELECT TOP(30) 
       SQLCPUUtilization                                   AS SQLCPUUtilization, 
       SystemIdle                                          AS SystemIdleProcess, 
       100 - SystemIdle - SQLCPUUtilization                AS OtherCPUUtilization,
       DATEADD(ms, -1 * (@ts_now - [timestamp]), GETDATE())AS EventTime 
   FROM 
       ( 
           SELECT 
               record.value('(./Record/@id)[1]', 'int')                                                 AS RecordID, 
               record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int')           AS SystemIdle, 
               record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]','int')   AS SQLCPUUtilization,
               [timestamp] 
           FROM 
           ( 
               SELECT 
                   [timestamp], 
                   CONVERT(xml, record) AS [record] 
               FROM sys.dm_os_ring_buffers 
               WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR' 
               AND record LIKE N'%<SystemHealth>%'
           ) AS x 
        ) AS y 
   ORDER BY RecordID DESC;
   
   RETURN  
END

--SELECT * FROM dbo.udf_GetCPUUsage() 