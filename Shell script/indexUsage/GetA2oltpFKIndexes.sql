/*
if exists (select * from tempdb..sysobjects where name='a2oltpFKInd')
  drop table tempdb..a2oltpFKInd
go
create table tempdb..a2oltpFKInd
(tbl varchar(50),
constr varchar(50),
ind varchar(50))
go
*/
create proc GetA2oltpFKIndexes
as

declare @tbl varchar(50), @tblold varchar(50)
declare @ind varchar(50), @indold varchar(50)
declare @const varchar(50), @constold varchar(50) 
declare @keys varchar(50)

set nocount on

truncate table tempdb..a2oltpFKInd

declare a2oltpForeignKey_crsr cursor for
select tbl, const from tempdb..a2oltpForeignKey_tbl

declare a2oltpIndDef_crsr cursor for
select tbl, ind from tempdb..a2oltpIndDef_tbl
where tbl = @tbl

create table #a2oltpIndDef
(tbl varchar(50),
ind varchar(50),
keys varchar(50)) 

create table #a2oltpForeignKey
(tbl varchar(50),
const varchar(50),
keys varchar(50))


open a2oltpForeignKey_crsr

select @tblold = '', @constold = ''

fetch a2oltpForeignKey_crsr into @tbl, @const

while @@sqlstatus <> 2
begin 
 
  insert #a2oltpForeignKey
  select tbl, const, keys
  from a2oltpForeignKey_tbl
  where tbl = @tbl and const = @const 
/*
if exists (select * from tempdb..sysobjects where name='a2oltpFKInd')
  drop table tempdb..a2oltpFKInd
go
create table tempdb..a2oltpFKInd
(tbl varchar(50),
constr varchar(50),
ind varchar(50))
go
*/
create proc GetA2oltpFKIndexes
as

declare @tbl varchar(50), @tblold varchar(50)
declare @ind varchar(50), @indold varchar(50)
declare @const varchar(50), @constold varchar(50) 
declare @keys varchar(50)

set nocount on

truncate table tempdb..a2oltpFKInd

declare a2oltpForeignKey_crsr cursor for
select tbl, const from tempdb..a2oltpForeignKey_tbl

declare a2oltpIndDef_crsr cursor for
select tbl, ind from tempdb..a2oltpIndDef_tbl
where tbl = @tbl

create table #a2oltpIndDef
(tbl varchar(50),
ind varchar(50),
keys varchar(50)) 

create table #a2oltpForeignKey
(tbl varchar(50),
const varchar(50),
keys varchar(50))


open a2oltpForeignKey_crsr

select @tblold = '', @constold = ''

fetch a2oltpForeignKey_crsr into @tbl, @const

while @@sqlstatus <> 2
begin 
 
  insert #a2oltpForeignKey
  select tbl, const, keys
  from tempdb..a2oltpForeignKey_tbl
  where tbl = @tbl and const = @const 

  open a2oltpIndDef_crsr

  fetch a2oltpIndDef_crsr into @tbl, @ind 

  while @@sqlstatus <> 2
  begin

    insert #a2oltpIndDef
    select tbl, ind, keys
    from tempdb..a2oltpIndDef_tbl
    where tbl = @tbl and ind = @ind

    if not exists 
      (select '1' from #a2oltpIndDef i
       where not exists (select '1' from #a2oltpForeignKey where keys = i.keys))
    begin
      insert tempdb..a2oltpFKInd
      select distinct i.tbl, c.const, i.ind
      from #a2oltpIndDef i join #a2oltpForeignKey c
      on i.tbl = c.tbl

      break
    end

    fetch a2oltpIndDef_crsr into @tbl, @ind
 
    truncate table #a2oltpIndDef

  end

close a2oltpIndDef_crsr 

fetch a2oltpForeignKey_crsr into @tbl, @const

truncate table #a2oltpForeignKey

end

deallocate cursor a2oltpIndDef_crsr

close a2oltpForeignKey_crsr
deallocate cursor a2oltpForeignKey_crsr

drop table #a2oltpIndDef, #a2oltpForeignKey
  open a2oltpIndDef_crsr

  fetch a2oltpIndDef_crsr into @tbl, @ind 

  while @@sqlstatus <> 2
  begin

    insert #a2oltpIndDef
    select tbl, ind, keys
    from a2oltpIndDef_tbl
    where tbl = @tbl and ind = @ind

    if not exists 
      (select '1' from #a2oltpIndDef i
       where not exists (select '1' from #a2oltpForeignKey where keys = i.keys))
    begin
      insert tempdb..a2oltpFKInd
      select distinct i.tbl, c.const, i.ind
      from #a2oltpIndDef i join #a2oltpForeignKey c
      on i.tbl = c.tbl

      break
    end

    fetch a2oltpIndDef_crsr into @tbl, @ind
 
    truncate table #a2oltpIndDef

  end

close a2oltpIndDef_crsr 

fetch a2oltpForeignKey_crsr into @tbl, @const

truncate table #a2oltpForeignKey

end

deallocate cursor a2oltpIndDef_crsr

close a2oltpForeignKey_crsr
deallocate cursor a2oltpForeignKey_crsr

drop table #a2oltpIndDef, #a2oltpForeignKey

/**** verify

select distinct * from tempdb..a2oltpFKInd
order by tbl, constr

select c.tbl "Table", c.const "Constraint", 
c.key1, isnull(c.key2,'') key2, isnull(c.key3,'') key3, isnull(c.key4,'') key4, 
i.ind "Index", i.def "Index definition"
from tempdb..a2oltpForeignKey_dtl c
join tempdb..a2oltpFKInd f
on c.tbl = f.tbl and c.const = f.constr
join tempdb..a2oltpIndDef_dtl i
on f.tbl = i.tbl and f.ind = i.ind
order by "Table", "Constraint"



select c.tbl, c.const, i.ind, i.def 
into tempdb..a2oltpFKIndexes
from tempdb..a2oltpForeignKey_dtl c
join tempdb..a2oltpFKInd f
on c.tbl = f.tbl and c.const = f.constr
join tempdb..a2oltpIndDef_dtl i
on f.tbl = i.tbl and f.ind = i.ind
order by c.tbl, c.const
*/