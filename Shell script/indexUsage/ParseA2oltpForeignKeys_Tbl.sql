if exists (select * from sysobjects where name='a2oltpForeignKey_tbl')
  drop table a2oltpForeignKey_tbl
go
create table a2oltpForeignKey_tbl
(tbl varchar(50), 
const varchar(50), 
keys varchar(50))

create index i1 on a2oltpForeignKey_tbl(tbl, const, keys)

delete a2oltpForeignKey
where keydef is null
go

declare a2oltpForeignKey_crsr cursor for
select keydef from a2oltpForeignKey
go
set nocount on

declare @keydef varchar(2000),  @tblind int, @tbl varchar(50), @const varchar(50)
declare @keystring varchar(2000), @start int, @end int

declare @key varchar(50)

open a2oltpForeignKey_crsr

fetch a2oltpForeignKey_crsr into @keydef

select @tblind = patindex("%.%",@keydef)
  
while @@sqlstatus <> 2
begin 
  if @tblind > 0   
    select @tbl = substring(@keydef, @tblind+1, datalength(@keydef)-(@tblind+1)+1)
  else
  if patindex("%CONSTRAINT%",@keydef) > 0
    set @const = substring(@keydef, patindex("%CONSTRAINT%",@keydef)+11, datalength(@keydef)-patindex("%CONSTRAINT%",@keydef)-12)
  else
  begin
    set @start = patindex("%(%",@keydef)+1
    set @end = patindex("%)%", @keydef) 
    set @keystring = substring(@keydef, @start, @end-@start)
    
    while patindex("%,%", @keystring) > 0
    begin
      select @key = case when patindex("%,%", @keystring) > 0
                         then substring(@keystring, 1, patindex("%,%", @keystring)-1)
                         else @keystring end 

      insert a2oltpForeignKey_tbl
      select @tbl, @const, @key

      set @start = patindex("%,%", @keystring)
      select @keystring = substring(@keystring, @start+1,@end-@start)
    end

    insert a2oltpForeignKey_tbl
    select @tbl, @const, @keystring 

  end          
            
  fetch a2oltpForeignKey_crsr into @keydef
  
  select @tblind = patindex("%.%",@keydef)
   
end

close a2oltpForeignKey_crsr
deallocate cursor a2oltpForeignKey_crsr
go


