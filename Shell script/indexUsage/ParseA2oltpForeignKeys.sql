if exists (select * from sysobjects where name='a2oltpForeignKey_dtl')
  drop table a2oltpForeignKey_dtl
go
create table a2oltpForeignKey_dtl
(tbl varchar(50), 
const varchar(50),  
key1 varchar(50),key2 varchar(50) null,key3 varchar(50) null,key4 varchar(50) null)

delete a2oltpForeignKey
where keydef is null
go

declare a2oltpForeignKey_crsr cursor for
select keydef from a2oltpForeignKey
go
set nocount on

declare @keydef varchar(2000),  @tblind int, @tbl varchar(50), @const varchar(50)
declare @keystring varchar(2000), @start int, @end int

declare @key1 varchar(50),@key2 varchar(50),@key3 varchar(50),@key4 varchar(50)

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
      
    select @key1=null,@key2=null,@key3=null,@key4=null
    
    select @key1 = case when patindex("%,%", @keystring) > 0
                        then substring(@keystring, 1, patindex("%,%", @keystring)-1)
                        else @keystring end 
         
    set @start = patindex("%,%", @keystring)

    if @start > 0
    begin
      select @keystring = substring(@keystring, @start+1,@end-@start)
      select @key2 = case when patindex("%,%", @keystring) > 0
                          then substring(@keystring, 1, patindex("%,%", @keystring)-1)
                          else @keystring end
      set @start = patindex("%,%", @keystring)

      if @start > 0
      begin
        select @keystring = substring(@keystring, @start+1,@end-@start)
        select @key3 = case when patindex("%,%", @keystring) > 0
                            then substring(@keystring, 1, patindex("%,%", @keystring)-1)
                            else @keystring end
        set @start = patindex("%,%", @keystring)

        if @start > 0
        begin
          select @keystring = substring(@keystring, @start+1,@end-@start)
          select @key4 = case when patindex("%,%", @keystring) > 0
                              then substring(@keystring, 1, patindex("%,%", @keystring)-1)
                              else @keystring end

        end
      end
    end
  end
    
  fetch a2oltpForeignKey_crsr into @keydef
  
  select @tblind = patindex("%.%",@keydef)
  
  if @tblind > 0
    insert a2oltpForeignKey_dtl
    select @tbl, @const,
           @key1,@key2,@key3,@key4 
   
end

insert a2oltpForeignKey_dtl
select @tbl, @const,
       @key1,@key2,@key3,@key4

close a2oltpForeignKey_crsr
deallocate cursor a2oltpForeignKey_crsr
go
