if exists (select * from sysobjects where name='a2queryIndDef_tbl')
  drop table a2queryIndDef_tbl
go
create table a2queryIndDef_tbl
(tbl varchar(50),
ind varchar(50),
keys varchar(50))

create index i1 on a2queryIndDef_tbl(tbl, ind, keys)

delete a2queryIndDef
where indDef is null
go

declare a2queryIndDef_crsr cursor for
select indDef from a2queryIndDef
go

set nocount on

declare @indDef varchar(2000), @ind varchar(50), @indind int, @tbl varchar(50)
declare @keystring varchar(2000), @start int, @end int
declare @key varchar(50)

open a2queryIndDef_crsr

fetch a2queryIndDef_crsr into @indDef

select @indind = patindex("%INDEX%",@indDef)
  
while @@sqlstatus <> 2
begin 
  if @indind > 0  
    select @ind = substring(@indDef, @indind+6, datalength(@indDef)-(@indind+6)+1)
  else
  if patindex("%ON dbo%",@indDef) > 0
  begin
    set @start = patindex("%(%",@indDef)+1
    set @end = patindex("%)%", @indDef) 
    set @tbl = substring(@indDef, 12, @start-13)
    set @keystring = substring(@indDef, @start, @end-@start)

    while patindex("%,%", @keystring) > 0
    begin        
      select @key = substring(@keystring, 1, patindex("%,%", @keystring)-1)

      insert a2queryIndDef_tbl
      select @tbl, @ind, @key  
         
      set @start = patindex("%,%", @keystring)

      select @keystring = substring(@keystring, @start+1,@end-@start)
    end

    insert a2queryIndDef_tbl
    select @tbl, @ind, @keystring
  end

  fetch a2queryIndDef_crsr into @indDef
  
  select @indind = patindex("%INDEX%",@indDef)
  
end

close a2queryIndDef_crsr
deallocate cursor a2queryIndDef_crsr

delete a2queryIndDef_tbl
where tbl like 'rs_%'
