#!/bin/ksh
export SYB="/ms/dist/syb/dba_env/oc32/12.5/bin"
export PWDir="/ms/user/b/baroneli/misc"
export UserName="baroneli"

chmod 400 $PWDir/usr
export PW=`cat $PWDir/usr`
chmod 000 $PWDir/usr

export SRV=NYQ_A2_INT2

$SYB/isql -Dtempdb -S$SRV -U$UserName -P$PW <<! >/dev/null
set nocount on
declare @i int, @j int, @a varchar(1900), @t datetime

select @t = getdate()

set @a=replicate('0',1900)

select @a a into #a

select @i = 1, @j = 1

while @i <= 1000
begin
  insert #a values(@a) 
  set @i = @i + 1
end 

while @j <= 1000
begin
  select * from #a (prefetch 2 mru)
  select * from #a (prefetch 16 mru) 
  set @j = @j + 1
end

drop table #a

select 'Time to run in sec:',datediff(ss,@t,getdate())
go
!
