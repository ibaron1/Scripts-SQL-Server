USE [TPSREFRESH]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_GetCPUUsage]    Script Date: 6/20/2017 3:02:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************
Author: Eli Baron
Date: 06-16-2017
Usage: 
To get CPU Utilization History for last 30 minutes
This query actually tells you the CPU utilization by SQL Server, in one minute increments
Examples.

select * from dbo.udf_GetCPUUsage() -- CPU utilization for last 30 min

select top 10 * from dbo.udf_GetCPUUsage() -- CPU utilization for last 10 min

select * from dbo.udf_GetCPUUsage() -- CPU utilization for time range from last 30 min
where [Event Time] between '2017-06-12 17:30:21.910' and '2017-06-12 17:33:22.180'
****************************************************************************************/
ALTER function [dbo].[udf_GetCPUUsage] ()
returns 
@CPUUsage table
(
[SQLProcessUtilization%] int,
[System Idle Process%] int,
[Other Process CPU Utilization%] int,
[Event Time] datetime
)
AS
-- Get CPU Utilization History for last 30 minutes
--This query actually tells you the CPU utilization by SQL Server, in one minute increments
BEGIN

DECLARE @ts_now bigint = (SELECT cpu_ticks/(cpu_ticks/ms_ticks) FROM sys.dm_os_sys_info); 

;WITH x
AS
( SELECT [timestamp], CONVERT(xml, record) AS [record] 
FROM sys.dm_os_ring_buffers 
WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR' 
AND record LIKE '%<SystemHealth>%'
)
,y
AS
( 
SELECT record.value('(./Record/@id)[1]', 'int') AS record_id, 
	record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') 
	AS [SystemIdle], 
	record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 
	'int') AS [SQLProcessUtilization], [timestamp]
FROM x)
INSERT @CPUUsage
SELECT TOP(30) SQLProcessUtilization AS [SQL Server Process CPU Utilization], 
               SystemIdle AS [System Idle Process], 
               100 - SystemIdle - SQLProcessUtilization AS [Other Process CPU Utilization], 
               DATEADD(ms, -1 * (@ts_now - [timestamp]), GETDATE()) AS [Event Time]
FROM y
ORDER BY record_id DESC;

RETURN

END
