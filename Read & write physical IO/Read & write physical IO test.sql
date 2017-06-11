
/*************** Generate dbccs for all dbs for exec; cannot be dynamic execution ****************

select distinct "dbcc cacheremove('"+dbname+"','Measure')"
from
(select db_name(dbid) dbname, segmap, vstart/16777216 vdevno  
from master..sysusages) u,
(select low/16777216 vdevno,  name as device, phyname,
(high-low+1)/512 as size_mb,
 case when status&16384 = 16384 then 'on - raw device' else 'off - UFS device' end as dsync
from master..sysdevices
where status&16 <> 16) d -- ignore dump devices
where u.vdevno = d.vdevno and dbname not like 'syb%' 
and dbname not in 
('master','model','sybsystemprocs','sybsecurity','sybsystemdb','dbccdb','server_config','maint_tempdb',
'aux_tempdb_1','surveillance','monitordb','globalrep',
'bmc_database','web_fe','mda_hist')
and segmap <> 4 and device <> 'master'
order by dbname desc

*************************************************************************************************/

/****
if exists (select '1' from CUSTOM..sysobjects where name='device_measured_IO')
  drop table CUSTOM..device_measured_IO
go
create table CUSTOM..device_measured_IO
(
server varchar(30),
dbname varchar(30),        
device varchar(30),        
Write_in_sec int null,
Write_in_MB_sec numeric(5,2) null,
Read_in_sec int null,
Read_in_MB_sec numeric(5,2) null,
Write_start_time datetime null,
Write_end_time datetime null,
Read_start_time datetime null,
Read_end_time datetime null,
segmap tinyint,
usage varchar(30),
physical_name varchar(255),          
status varchar(30), 
status_flag smallint null,
note varchar(255) 
)           
****/

set nocount on

if exists (select '1' from tempdb..sysobjects where name='DbDevice')
  drop table tempdb..DbDevice
go

select distinct dbname, device, phyname, segmap,
case 
     when segmap = 3 then 'data'
     when segmap = 4 then 'log' 
     when segmap = 7 then 'data and log'
     when segmap = 1 then 'system'
     when segmap = 0 then ' -- unused by any segments --' 
     when dbname is not null then 'user segment' end as usage,
status, status_flag,
(size_mb - isnull(used_mb, 0)) as space_left_mb
into tempdb..DbDevice
from
(select db_name(dbid) dbname, segmap, vstart/16777216 vdevno, size/512 as used_mb  
from master..sysusages) u,
(select low/16777216 vdevno,  name as device, phyname,
(high-low+1)/512 as size_mb, status as status_flag,
 case  when status&16384=16384 then 'UFS / dsync on - writes direct'       
      when status&2=2 then 'physical disk'
      else 'UFS device / dsync off - OS/buffered writes' end as status
from master..sysdevices
where status&2 = 2 or status&16384 = 16384) d -- ignore dump devices
where u.vdevno = d.vdevno and dbname not like 'syb%' 
and dbname in 
('GPS','GPS3','GPS4','GPS5','tempdb','tempdb1','tempdb2','tempdb3','tempdb4','tempdb5','tempdb6')
and segmap <> 4 and device <> 'master'
order by dbname

create clustered index i on tempdb..DbDevice(dbname desc, device)
go

if exists (select '1' from tempdb..sysobjects where name='log_space')
  drop table tempdb..log_space
go

select  db_name(dbid) dbname, 
        sum(size)/512 log_mb,
        sum(curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs))/512 as log_free_mb
into tempdb..log_space
from master.dbo.sysusages u,
     master..sysdevices v 
where segmap = 4
and v.low <= u.size + vstart
and v.high >= u.size + vstart - 1
and v.status & 2 = 2
and db_name(u.dbid) in 
('GPS','GPS3','GPS4','GPS5','tempdb','tempdb1','tempdb2','tempdb3','tempdb4','tempdb5','tempdb6')
group by dbid 
go

declare device_cursor cursor for select dbname, device from tempdb..DbDevice for read only
go

if exists (select '1' from tempdb..sysobjects where name='arch_daily_currency')
  drop table tempdb..arch_daily_currency
go

-- Prepare table to measure I/O

select top 1600000 acid,tmid,secid,base_pay,local_recv,base_recv,base_move,effdate,td_local_pay,td_base_pay,date,cancel_effdate,archive_date 
into tempdb..arch_daily_currency
from GPS..arch_daily_currency
go

-- Bring template's pages in memory (read from memory not from disk to measure physical writes)
select * into #tmp from tempdb..arch_daily_currency  (index 0 lru)
drop table #tmp

declare  @dbname varchar(30), @device varchar(30), @sql varchar(255)

declare @write_Start datetime, @write_End datetime, @write_time int, @writeIO numeric(5,2) 
 
declare @read_Start datetime, @read_End datetime, @read_time int, @readIO numeric(5,2)

declare @tbl_Size_in_mb_dp double precision,
	@tbl_Size_in_mb numeric(5,2)

use tempdb
select  @tbl_Size_in_mb=convert(numeric(5,2),data_pgs(id, doampg)/512.0) 
from tempdb..sysindexes 
where object_name(id) = 'arch_daily_currency'
and indid = 0

open device_cursor

fetch device_cursor into @dbname, @device
             
WHILE (@@sqlstatus = 0)
BEGIN
	select 'Database:',@dbname

	
	

	select @sql='exec '+@dbname+'..sp_addsegment Device, '+@dbname+', '+@device
	exec(@sql) -- create segment on the device to be measured

	waitfor delay "00:00:01"

	/*
	select @sql='select * from '+@dbname+'..Measure'
	select @sql
	exec(@sql)

	waitfor delay "00:00:01"

	*/
	/**** Writes I/O ****/
	select @write_Start = getdate()
 
	select @sql='insert '+@dbname+'..Measure select * from tempdb..arch_daily_currency (index 0 lru)'
	exec(@sql) 

-- cannot be dynamic execution; generate for all dbs for this run

dbcc cacheremove('tempdb6','Measure')
dbcc cacheremove('tempdb5','Measure')
dbcc cacheremove('tempdb4','Measure')
dbcc cacheremove('tempdb3','Measure')
dbcc cacheremove('tempdb2','Measure')
dbcc cacheremove('tempdb1','Measure')
dbcc cacheremove('tempdb','Measure')
dbcc cacheremove('mosiki_tempdb','Measure')
dbcc cacheremove('GPS4','Measure')
dbcc cacheremove('GPS3','Measure')
dbcc cacheremove('GPS','Measure')
dbcc cacheremove('CUSTOM','Measure')

	select @write_End = getdate()

	select @write_time = round(datediff(ms, @write_Start, @write_End)/10000.0,1)*10
	select @writeIO = convert(numeric(5,2), @tbl_Size_in_mb / @write_time)

	/**** Reads I/O ****/
	select @read_Start = getdate()

	select @sql = 'select count(*) from '+@dbname+'..Measure'
	exec(@sql)

	SELECT @read_End = getdate()

	select @readIO = convert(numeric(5,2), round(convert(float,@tbl_Size_in_mb/(@read_time/1000)),1))

	insert CUSTOM..device_measured_IO
	select distinct @@servername, @dbname, @device,	 
	@write_time, @writeIO,	
	@read_time, @readIO,
    	@write_Start, @write_End, 
    	@read_Start, @read_End, 
	segmap, usage, phyname, status, status_flag, 'Device I/O throughput was measured'
	from tempdb..DbDevice
	where dbname = @dbname and device = @device

	select @sql='drop table '+@dbname+'..Measure'
	exec(@sql) -- remove table after measured device I/O 

	waitfor delay "00:00:04"

	select @sql='exec '+@dbname+'..sp_dropsegment Device, '+@dbname
	exec(@sql) -- remove segment from the device

	waitfor delay "00:00:01"

	fetch device_cursor into @dbname, @device
END

close device_cursor 
deallocate cursor device_cursor

drop table tempdb..DbDevice

select 'Size of the table used to measure physical read/write I/O, in mb',@tbl_Size_in_mb 

select * from CUSTOM..device_measured_IO
