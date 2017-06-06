DECLARE @time1 DATETIME;
DECLARE @time2 DATETIME;
DECLARE @value1 BIGINT;
DECLARE @value2 BIGINT;
declare @instance_name varchar(100)

set @instance_name = 'AdventureWorks' -- db name

-- get first sample

SELECT @value1=cntr_value, @time1 =
getdate()
FROM
sys.dm_os_performance_counters
WHERE counter_name =
'Backup/Restore Throughput/sec'
AND instance_name = @instance_name ;

-- wait for 10 seconds

WAITFOR
DELAY
'00:00:05';

-- get second sample

SELECT @value2=cntr_value, @time2 =
getdate()
FROM
sys.dm_os_performance_counters
WHERE counter_name =
'Backup/Restore Throughput/sec'
AND instance_name = @instance_name ;

