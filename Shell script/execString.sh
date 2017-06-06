#!/bin/ksh
#set -x
. ENV

LogDir="$RootDir/proc_def_tmp"

if [[ -d $RootDir/proc_def_tmp ]];then
  rm -r $RootDir/proc_def_tmp
fi
mkdir $RootDir/proc_def_tmp

getProcViewDef.sh

$SYB/isql -b -Dtempdb -S$SRV -U$UserName -P$PW <<!
if exists (select * from sysobjects where name='execString')
  drop table execString
go
create table execString(sqlstring varchar(1800))
go
if exists (select * from sysobjects where name='execString_out')
  drop table execString_out
go
create table execString_out(procnm varchar(40), sqlstring varchar(1200))
go
!

grep -h -w exec $LogDir/*|sed '/@exec/d;/--/d;' > $RootDir/execString.sql

$SYB/bcp tempdb..execString in $RootDir/execString.sql -S$SRV -U$UserName -P$PW -c -t'|' -r\\n 

$SYB/isql -b -Dtempdb -S$SRV -U$UserName -P$PW <<!
declare sql_crsr cursor for
select cast(substring(ltrim(sqlstring), 6, charindex('@', ltrim(sqlstring))-7) as varchar(50)) procnm,
        cast(sqlstring as varchar(1200))
from tempdb..execString
where sqlstring not like '%exec(%'
order by procnm
go

set nocount on

declare @procnm varchar(40), @procnm_old varchar(40), @sqlstring varchar(1200)

set @procnm_old = '' 

open sql_crsr

fetch sql_crsr into @procnm, @sqlstring

while @@sqlstatus <> 2
begin
  if @procnm <> @procnm_old
    insert execString_out
    select @procnm, ltrim(@sqlstring) 

   set @procnm_old = @procnm

   fetch sql_crsr into @procnm, @sqlstring 

end

close sql_crsr
deallocate cursor sql_crsr

if not exists (select * from execString_out where procnm = @procnm)
  insert execString_out 
  select @procnm, @sqlstring 

truncate table execString

insert execString select sqlstring from execString_out
go
!

$SYB/bcp tempdb..execString out $RootDir/execString.sql -S$SRV -U$UserName -P$PW -c -t'|' -r\\n
cut -d' ' -f2 $RootDir/execString.sql > $RootDir/nm
for procnm in `grep -v -f$RootDir/nm $ProcList`
do
GenerateProcExec.sh $procnm
cat $ProcDir/$procnm >> $RootDir/execString.sql
done

echo ""
echo "Exec sql strings are in $RootDir/execString.sql"
echo ""
