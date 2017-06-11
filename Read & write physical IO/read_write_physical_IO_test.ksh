#!/bin/ksh
PATH=/usr/local/sybase/OCS-12_0/bin:/usr/openwin/bin:$PATH
LD_LIBRARY_PATH=/u/sybase/OCS-12_0/lib
SYBASE=/usr/local/sybase
export PATH
export LD_LIBRARY_PATH
export SYBASE
chmod 744 pw
pw=`cat pw`
chmod 000 pw
SRVR=GLSRD
login=p489920

isql -U$login -S$SRVR -P$pw << ! > /dev/null
set nocount on

if not exists (select '1' from CUSTOM..sysobjects where name='device_measured_IO')
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
space_left_mb int,
note varchar(255)
)
go
!

isql -U$login -S$SRVR -P$pw << !
set nocount on

if exists (select '1' from tempdb..sysobjects where name='Dbs')
  drop table tempdb..Dbs
go

create table tempdb..Dbs(Db varchar(30))
go
--insert tempdb..Dbs select 'GPS'
--insert tempdb..Dbs select 'GPS3'
--insert tempdb..Dbs select 'GPS4'
--insert tempdb..Dbs select 'GPS5'
--insert tempdb..Dbs select 'tempdb'
--insert tempdb..Dbs select 'tempdb1'
--insert tempdb..Dbs select 'tempdb2'
--insert tempdb..Dbs select 'tempdb3'
--insert tempdb..Dbs select 'tempdb4'
--insert tempdb..Dbs select 'tempdb5'
insert tempdb..Dbs select 'tempdb6'
go

if exists (select '1' from tempdb..sysobjects where name='DbDevice')
  drop table tempdb..DbDevice
go

select distinct rtrim(dbname) dbname, rtrim(device) device, phyname, segmap,
case 
     when segmap = 3 then 'data'
     when segmap = 4 then 'log' 
     when segmap = 7 then 'data and log'
     when segmap = 1 then 'system'
     when segmap = 0 then ' -- unused by any segments --' 
     when dbname is not null then 'user segment' end as usage,
status, status_flag
into tempdb..DbDevice
from
(select db_name(dbid) dbname, segmap, vstart/16777216 vdevno  
from master..sysusages) u,
(select low/16777216 vdevno,  name as device, phyname,
(high-low+1)/512 as size_mb, status as status_flag,
 case  when status&16384=16384 then 'UFS / dsync on - writes direct'       
      when status&2=2 then 'physical disk'
      else 'UFS device / dsync off - OS/buffered writes' end as status
from master..sysdevices
where status&2 = 2 or status&16384 = 16384) d -- ignore dump devices
where u.vdevno = d.vdevno and dbname not like 'syb%' 
and dbname in (select Db from  tempdb..Dbs)
and segmap <> 4 and device <> 'master'
order by dbname

create clustered index i on tempdb..DbDevice(dbname desc, device)
go
!

isql -U$login -S$SRVR -P$pw << !
set nocount on

if exists (select '1' from tempdb..sysobjects where name='arch_daily_currency')
  drop table tempdb..arch_daily_currency
go

-- Prepare table to measure I/O

select top 1600000 acid,tmid,secid,base_pay,local_recv,base_recv,base_move,effdate,td_local_pay,td_base_pay,date,cancel_effdate,archive_date 
into tempdb..arch_daily_currency
from GPS..arch_daily_currency
go
!

## Simulate cursor to avoid dynamic sql

isql -b -U$login -S$SRVR -P$pw << ! | tr -s ' '| tr ' ' ':' >tmp
set nocount on
select dbname, device from tempdb..DbDevice
go
!

for DbDevice in `cat tmp`
do

Db=`echo $DbDevice|cut -d':' -f2`
Device=`echo $DbDevice|cut -d':' -f3`

isql -e -U$login -S$SRVR -P$pw << ! > IOsql.out
set nocount on

declare @note varchar(255)

declare @write_Start datetime, @write_End datetime, @write_time int, @writeIO numeric(5,2) 
 
declare @read_Start datetime, @read_End datetime, @read_time int, @readIO numeric(5,2)

declare @tbl_Size_in_mb numeric(5,2), @space_left_mb numeric(10,2), @log_free_mb numeric(10,2), @sql varchar(255)

declare @measured_flag char(1)

	select @write_Start = null, @write_End = null, @write_time = null, @writeIO = null
	select @read_Start  = null, @read_End  = null, @read_time  = null, @readIO  = null
	select @note = '', @measured_flag = 'Y'

	use tempdb
	select  @tbl_Size_in_mb=convert(numeric(5,2),data_pgs(id, doampg)/512.0) 
	from tempdb..sysindexes 
	where object_name(id) = 'arch_daily_currency'
	and indid = 0

	-- do not measure I/O if there is not enough free space in db tran log to write template table to the db device

	select  @log_free_mb = sum(curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs))/512
	from master.dbo.sysusages u,
     	master..sysdevices v 
	where segmap = 4
	and v.low <= u.size + vstart
	and v.high >= u.size + vstart - 1
	and v.status & 2 = 2
	and db_name(u.dbid) = "$Db"
	group by dbid	

	if @log_free_mb < @tbl_Size_in_mb + 20 -- leave 20 mb
	begin
	  select @note = 'Not enough space in tran log to write '+convert(varchar(4),@tbl_Size_in_mb)+' MB into a table; log free space: '+convert(varchar(5),@log_free_mb)

	  select @measured_flag = 'N'

	  goto InsertResults
	end

	select @space_left_mb = sum(curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs))/512  
	from  master.dbo.sysusages u,
      		master..sysdevices v
	where v.low <= u.size + vstart
	and v.high >= u.size + vstart - 1
	and v.status & 2 = 2
	and db_name(dbid) = "$Db" and v.name = "$Device"
	group by dbid

	-- do not measure I/O if not enough free space left to write template table to a db device

	if @space_left_mb < @tbl_Size_in_mb + 20 -- leave 20 mb
	begin
	  select @note = 'Not enough space left to write '+convert(varchar(4),@tbl_Size_in_mb)+' MB template table to a db device; space left: '+convert(varchar(4), @space_left_mb)+' MB'
	  from tempdb..DbDevice where dbname="$Db" and device="$Device"

	  select @measured_flag = 'N'
	  
	  goto InsertResults
	end

	-- Bring template's pages in memory (read from memory not from disk to measure physical writes)
	select * into #tmp from tempdb..arch_daily_currency  (index 0 lru)
	drop table #tmp

        -- needs dynamic exec because of DDL check
	--exec ${Db}..sp_addsegment Device, ${Db}, $Device 

	select @sql="${Db}..sp_addsegment Device, ${Db}, $Device"
	exec(@sql) -- create segment on the device to be measured
	waitfor delay "00:00:01" 

        -- needs dynamic exec because of DDL check
	--create table ${Db}..Measure(acid int,tmid int,secid int,base_pay float,local_recv float,base_recv float,base_move float,effdate datetime,td_local_pay float,td_base_pay float,date datetime,cancel_effdate datetime,archive_date datetime) on Device

	select @sql = 
"create table ${Db}..Measure(acid int,tmid int,secid int,base_pay float,local_recv float,base_recv float,base_move float,effdate datetime,td_local_pay float,td_base_pay float,date datetime,cancel_effdate datetime,archive_date datetime) on Device" 
	exec(@sql) -- create table on the segment
	waitfor delay "00:00:01"

	select @write_Start = getdate()

	insert ${Db}..Measure select * from tempdb..arch_daily_currency (index 0 lru)

	-- Prepare for physical read, remove table from memory cache which also will write dirty pages thus completing previous physical write

	dbcc cacheremove("$Db","Measure")

	select @write_End = getdate()

	/**** Reads I/O ****/
	select @read_Start = getdate()

	select @read_End = getdate()

	select @readIO = convert(numeric(5,2), round(convert(float,@tbl_Size_in_mb/(@read_time/1000)),1))

	select @note = 'Device I/O read & write was measured'

	InsertResults:

	insert CUSTOM..device_measured_IO
	select distinct @@servername, "$Db", "$Device",	 
	@write_time, @writeIO,	
	@read_time, @readIO,
    	@write_Start, @write_End, 
    	@read_Start, @read_End, 
	segmap, usage, phyname, status, status_flag, @space_left_mb, 
	@note
	from tempdb..DbDevice
	where dbname = "$Db" and device = "$Device"

	if @measured_flag = 'Y'
	begin
	  drop table ${Db}..Measure
	  exec ${Db}..sp_dropsegment Device, ${Db}
	end	
go
!

done
