set nocount on
dbcc memorystatus

select * from master..sysperfinfo -- select counters for memory

---- more accurate, using SQL Server performance counters 
select * from sys.dm_os_performance_counters 
where object_name like '%Buffer Node%'