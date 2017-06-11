set nocount on

select db_name(dbid) dbname, sum(size)/512 data_mb
into #data
from master.dbo.sysusages 
where segmap <> 4
group by dbid
order by dbname

select db_name(dbid) dbname, sum(size)/512 log_mb
into #log
from master.dbo.sysusages 
where segmap = 4
group by dbid
order by dbname

select @@servername

select d.dbname, d.data_mb, l.log_mb
from #data d, #log l
where d.dbname = l.dbname
and d.dbname in ('GPS','GPS3','GPS4')

drop table #data, #log