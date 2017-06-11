declare stat_cursor cursor for 
select object_name(id), moddate,colidarray 
from sysstatistics
where object_name(id) = "pt_trmast"
go

set nocount on

declare @tbl varchar(30), @moddate datetime, @colidarray varbinary(100), @colid_hex binary(2)
declare @i int, @length int, @sql varchar(100)

create table #stat_parsed
(tbl varchar(30),
stats_moddate datetime,
colid_hex  binary(2),
colidarray varbinary(100))


    open stat_cursor
    fetch stat_cursor into @tbl, @moddate, @colidarray
    
    while (@@sqlstatus = 0)  
    begin
	select @length = datalength(@colidarray)
	select @i = 1

	while @i < @length
	begin
	  select @colid_hex = substring(@colidarray,@i,2)     
      
      --select ' @colid_hex', @colid_hex, @colidarray
     
	  insert #stat_parsed
	  select @tbl, @moddate, @colid_hex, @colidarray
		
	  select @i = @i + 2
	end

    fetch stat_cursor into @tbl, @moddate, @colidarray
    end

    close stat_cursor 
    deallocate cursor stat_cursor

select * from #stat_parsed

drop table #stat_parsed