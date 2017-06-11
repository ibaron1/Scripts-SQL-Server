/*
select * from monitordb..indexusage

select * from monitordb..indexusage_summary
*/

select distinct TableName, IndexName 
into #tmp --553
from monitordb..indexusage_summary
where QryPlanCount = 0 and UsedCount = 0
								
select * from #tmp

/*
select distinct TableName, IndexName 
into #tmp1 --746
from monitordb..indexusage_summary
*/

select distinct TableName, IndexName
into #tmp1
from #tmp t --407
where not exists
(select '1' from monitordb..indexusage_summary
 where TableName = t.TableName and  IndexName = t.IndexName
 and (QryPlanCount <> 0 or UsedCount <> 0))
 
select s.* 
from monitordb..indexusage_summary s, #tmp1 t
where s.TableName = t.TableName and  s.IndexName = t.IndexName
order by s.TableName, s.IndexName, s.SrvName, s.DB
 
drop table #tmp, #tmp1