/*
select top 1600000 acid,tmid,secid,base_pay,local_recv,base_recv,base_move,effdate,td_local_pay,td_base_pay,date,cancel_effdate,archive_date 
into tempdb..arch_daily_currency
from GPS..arch_daily_currency
*/

set nocount on

set statistics io on

declare @write_Start datetime, @write_End datetime, @write_time_sec int, @writeIO numeric(5,2) 
 
declare @read_Start datetime, @read_End datetime, @read_time_sec int, @readIO numeric(5,2)

declare @tbl_Size_in_mb numeric(5,2)

use tempdb
select  @tbl_Size_in_mb=convert(numeric(5,2),data_pgs(id, doampg)/512.0) 
from tempdb..sysindexes 
where object_name(id) = 'arch_daily_currency'
and indid = 0

select tbl_Size_in_mb = @tbl_Size_in_mb

select * into tempdb..Measure from tempdb..arch_daily_currency where 1=2

select 'Database: tempdb'
/**** Writes I/O ****/
	select @write_Start = getdate()

	insert tempdb..Measure
	select * from tempdb..arch_daily_currency (index 0 lru)

	dbcc cacheremove('tempdb','Measure')

	select @write_End = getdate()

	select @write_time_sec = round(datediff(ms, @write_Start, @write_End)/10000.0,1)*10

	select write_time_sec = @write_time_sec, writeIO_MB_sec = convert(numeric(5,2), @tbl_Size_in_mb / @write_time_sec) 

/**** Reads I/O ****/

	select @read_Start = getdate()
    
    select count(*) from tempdb..Measure

	SELECT @read_End = getdate()

	select @read_time_sec = round(datediff(ms, @read_Start, @read_End)/10000.0,1)*10
    
	select read_time_sec = @read_time_sec, readIO_MB_sec = convert(numeric(5,2), @tbl_Size_in_mb/ case @read_time_sec when 0 then 1 else @read_time_sec end)

drop table tempdb..Measure