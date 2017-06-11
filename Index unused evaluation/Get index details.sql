
declare ind_cursor cursor for 
select object_name(id), indid, name, keycnt
from sysindexes
where object_name(id) = "pt_trmast"
and 
((indid  > 0 and lockscheme(id, db_id()) = 'allpages') or 
(indid  > 1 and lockscheme(id,db_id()) <> 'allpages'))

go

set nocount on

create table #index_parsed
(tbl varchar(30), indid int, indexname varchar(30), keycolumn varchar(30), 
colid int)

create table #index_pars1
(tbl varchar(30), indid int, indexname varchar(30), keycolumn varchar(30), 
colid int, colid_hex char(4))

declare @tbl varchar(30), @indid int, @indexname varchar(30), @keycnt int, @keycnt_cur int

    open ind_cursor
    fetch ind_cursor into @tbl, @indid, @indexname, @keycnt
    
    while (@@sqlstatus = 0)  
    begin
    
    select @keycnt_cur = 1
             
    if ((lockscheme(object_id(@tbl), db_id()) = 'allpages') and @indid > 1) or
       ((lockscheme(object_id(@tbl), db_id()) <> 'allpages') and @indid > 2)
       select @keycnt_cur = @keycnt - 1    
             
    	while @keycnt_cur <= @keycnt
	    begin
		    insert #index_parsed
     		    select @tbl, @indid, @indexname,  
			   index_col(@tbl, @indid, @keycnt_cur),
			   colid
		    from syscolumns
		    where id=object_id(@tbl) and name = index_col(@tbl, @indid, @keycnt_cur)

     		select @keycnt_cur = @keycnt_cur + 1
	    end
    fetch ind_cursor into @tbl, @indid, @indexname, @keycnt
    end

    close ind_cursor 
    deallocate cursor ind_cursor

insert #index_pars1
select *, substring(inttohex(colid), 5,4)
from #index_parsed
    
drop table  #index_parsed
    
/*
select * 
from #index_pars1
order by indid, colid

select * into tempdb..index_parsed
from #index_pars1
order by indid, colid

select * from tempdb..index_parsed
*/
go

