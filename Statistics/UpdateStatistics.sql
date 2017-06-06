set nocount on

declare @SqlString varchar(200)

declare
UpdStat_crsr cursor local fast_forward for
select distinct 'UPDATE STATISTICS '+schema_name(o.schema_id)+'.'+o.name+' WITH FULLSCAN'
from sys.indexes i join sys.objects o
on i.object_id = o.object_id and o.[type]='U'
where datediff(DAY, STATS_DATE (i.object_id , i.index_id), GETDATE()) > 2

open UpdStat_crsr


while 1 = 1
begin

  fetch UpdStat_crsr into @SqlString

  if @@fetch_status <> 0
            break 
            
  print  @SqlString
  exec(@SqlString)  
            

end

close UpdStat_crsr
deallocate UpdStat_crsr

select distinct 'UPDATE STATISTICS '+schema_name(o.schema_id)+'.'+o.name+' WITH FULLSCAN'
from sys.indexes i join sys.objects o
on i.object_id = o.object_id and o.[type]='U'
where datediff(DAY, STATS_DATE (i.object_id , i.index_id), GETDATE()) > 2

/**** verify ****/

select object_name(id) as tbl, [name] as Idx, 
STATS_DATE (id , indid) StatsUpdateDate,
datediff(DAY, STATS_DATE (id , indid), GETDATE()) as UpdDate
from sysindexes
where object_name(id) not like 'sys%'
and datediff(DAY, STATS_DATE (id , indid), GETDATE()) > 2
and datediff(DAY, STATS_DATE (id , indid), GETDATE()) is not null
order by object_name(id)

go