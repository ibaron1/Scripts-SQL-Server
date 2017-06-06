
set nocount on

declare @spid smallint, @sql_handle varbinary(64)
declare @stmt_start int, @stmt_end int
declare @version char(1), @msg varchar(100)

select @version = substring(convert(varchar(12),serverproperty('ProductVersion')),1,1)

select
spid, blocked, cpu, physical_io, memusage, 
db_name(dbid) dbname,
status, cmd, loginame,  
login_time, 
waittime, lastwaittype, waitresource,
open_tran, program_name, hostname,
sql_handle, stmt_start, stmt_end
into #tmp
from master..sysprocesses p
where spid > 21 and 
spid <> @@spid
and cmd <> 'AWAITING COMMAND'
and ecid = 0

create table #tmp1(spid smallint, sqltext text, statement text)

declare spid_cursor cursor for 
select spid
from #tmp 

open spid_cursor
fetch spid_cursor into @spid

while (@@FETCH_STATUS = 0)
begin

  select @sql_handle = sql_handle,
  @stmt_start = stmt_start/2,
  @stmt_end = case when stmt_end = -1 then -1 else stmt_end/2 end
  from #tmp
  where	spid = @spid

  if (@version = '9' and ((@sql_handle = 0x0) or (@stmt_start = 0 AND @stmt_end = 0)))
     or (@version = '8' and @sql_handle = 0x0)
  begin
	set @msg = 'Query/Stored procedure completed for spid '+convert(varchar(7), @spid)
    raiserror(@msg, 0, 1)

    delete #tmp where spid = @spid
    goto next
  end

  insert #tmp1
  select @spid, text, 
  substring(text, coalesce(nullif(@stmt_start, 0), 1), 
       case @stmt_end when -1 then datalength(text) else (@stmt_end - @stmt_start) end) 
  from sys.dm_exec_sql_text(@sql_handle);

next:
  fetch spid_cursor into @spid

end

close spid_cursor 
deallocate spid_cursor

select #tmp.spid, blocked, cpu, physical_io, memusage, 
dbname,
status, cmd, login_time, 
waittime, lastwaittype, waitresource,
open_tran, program_name, hostname,
sqltext, statement
from #tmp left join #tmp1
on #tmp.spid = #tmp1.spid

drop table #tmp, #tmp1
