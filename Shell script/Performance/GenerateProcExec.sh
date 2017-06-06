#!/bin/ksh
#set -x
#PS4='line $LINENO: '
#############################################################################
### Script Name: GenerateProcExec.sh
### Author: Eli Baron
### Date: 04/18/2006
### Purpose: to generate proc's exec stmt 
#############################################################################

procnm=$1

$SYB/isql -S$SRV -U$UserName -P$PW <<! > $ProcDir/$procnm
use a2query
go
set nocount on

declare @num int, @maxrownum int, @sqlstring varchar(8000)
declare @proc varchar(40)

set @proc='$procnm'

create table #tmp1(rownum numeric(10) identity, Parm varchar(40), ParmValue varchar(15) null)

select convert(varchar(40) NULL, c.name) Parm,case  
  when t.name like '%char' then '''A'''when t.name like '%int' then '1' when t.name like '%datetime' then '''02/01/2006''' end ParmValue
into #tmp
from sysobjects o left join syscolumns c
on o.id =c.id and o.type='P' and o.name not like 'rs_%' and o.name=@proc
join systypes t
on c.type = t.type or c.usertype = t.usertype
order by object_id(o.name)

insert #tmp1(Parm, ParmValue)
select distinct Parm, ParmValue
from #tmp where ParmValue is not null

select @num = 1, @sqlstring = ' '

select @maxrownum = max(rownum) from #tmp1

while @num < @maxrownum
begin
 select @sqlstring = @sqlstring+Parm+' = '+ParmValue+','
 from #tmp1 where rownum=@num

 set @num  = @num + 1
end

select @sqlstring = @sqlstring+Parm+' = '+ParmValue
from #tmp1 where rownum=@num

select @sqlstring = 'exec '+@proc+@sqlstring

truncate table tempdb..execproc
 
insert tempdb..execproc
select @sqlstring

drop table #tmp, #tmp1

/* cannot exec this dynamic sql since every proc has dynamic sql
set showplan on
set fmtonly on
exec(@sqlstring)
set fmtonly off
set showplan off
*/
go
!

$SYB/bcp tempdb..execproc out $ProcDir/$procnm -S$SRV -U$UserName -P$PW -c -t'|' -r\\n >/dev/null
