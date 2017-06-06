--isolate physical disks that are involved in the I/O bottlenecks.
--The io_pending_ms_ticks values represent the total time individual I/Os are waiting in the pending queue. 
set nocount on

declare @Interval char(8)= '00:00:04'

while 0=0
begin
	select 
		db_name(database_id) as DbName, 
		file_name(file_id) as FileName, 
		io_stall,
		io_pending_ms_ticks,
		scheduler_address 
	from	sys.dm_io_virtual_file_stats(NULL, NULL)t1,
			sys.dm_io_pending_io_requests as t2
	where	t1.file_handle = t2.io_handle

	waitfor delay @Interval 
end