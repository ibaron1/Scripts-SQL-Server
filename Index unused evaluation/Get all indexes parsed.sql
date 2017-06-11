declare ind_cursor cursor for 
select object_name(i.id), indid, i.name, keycnt
from sysindexes i join sysobjects o
on o.name = object_name(i.id) and o.type='U' and o.name not like 'sys%' and o.name not like 'rs%'
where (indid  > 0 and lockscheme(i.id, db_id()) = 'allpages') or (indid  > 1 and lockscheme(i.id, db_id()) <> 'allpages')
order by o.name
go

if exists (select '1' from tempdb..sysobjects where name='index_parsed')
  drop table tempdb..index_parsed
go

create table tempdb..index_parsed
(tbl varchar(30), indid int, indtype varchar(3), lockschema varchar(9), indexname varchar(30), keycolumn varchar(30)) 
--,colid int)
go

set nocount on

declare @tbl varchar(30), @indid int, @indexname varchar(30), @keycnt int, @keycnt_cur int

    open ind_cursor
    fetch ind_cursor into @tbl, @indid, @indexname, @keycnt
    
    while (@@sqlstatus = 0)  
    begin
    
    select @keycnt_cur = 1
             
    if ((lockscheme(object_id(@tbl), db_id()) = 'allpages') and @indid > 1) or
       (lockscheme(object_id(@tbl), db_id()) <> 'allpages')
       select @keycnt = @keycnt - 1    
             
    	while @keycnt_cur <= @keycnt
	    begin
		    insert tempdb..index_parsed
     		    select @tbl, @indid, 
                case when ((lockscheme(object_id(@tbl), db_id()) = 'allpages' and  @indid = 1) or (lockscheme(object_id(@tbl), db_id()) <> 'allpages' and  @indid = 2))  then 'CI'
                     else 'NCI' end,
                lockscheme(object_id(@tbl), db_id()),
                @indexname,  
			   index_col(@tbl, @indid, @keycnt_cur)
			   /*,colid
		    from syscolumns
		    where id=object_id(@tbl) and name = index_col(@tbl, @indid, @keycnt_cur)*/

     		select @keycnt_cur = @keycnt_cur + 1
	    end
    fetch ind_cursor into @tbl, @indid, @indexname, @keycnt
    end

    close ind_cursor 
    deallocate cursor ind_cursor

/*
select p1.tbl, p1.indexname, p1.keycolumn, p1.indtype, p1.lockschema 
from tempdb..index_parsed p1, tempdb..index_parsed p2
where p1.indexname = p2.indexname
and p2.keycolumn = 'smsecid'
*/

-- select * from tempdb..index_parsed
/* -- compare indexes from 2 databases or source and target after refresh)
tempdb..sp_rename index_parsed, index_parsed_GPS4_GLSRD

select * from tempdb..index_parsed_GPS4_GLSRD

select * into tempdb..index_parsed_GPS4_GLSR2 from tempdb..index_parsed where 1=2 -- for import from GLSR2

select * from tempdb..index_parsed_GPS4_GLSRD i
where not exists 
(select '1' from tempdb..index_parsed_GPS4_GLSR2
 where tbl=i.tbl and indid=i.indid and indtype=i.indtype and lockschema=i.lockschema 
 and indexname=i.indexname and keycolumn=i.keycolumn) 
*/
