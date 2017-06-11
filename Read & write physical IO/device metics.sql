select dbname, device, segmap,
case 
     when segmap = 3 then 'data'
     when segmap = 4 then 'log' 
     when segmap = 7 then 'data and log'
     when segmap = 1 then 'system'
     when segmap = 0 then ' -- unused by any segments --' 
     when dbname is not null then 'user segment' end as usage,
--case when d.vdevno < 0 then d.vdevno + 256 else d.vdevno end vdevno, 
--lstart, vstart, 
    dsync,
    size_mb, isnull(used_mb, 0) as used_mb, 
    (size_mb - isnull(used_mb, 0)) as left_mb,  
    phyname 
into #tmp
from
(select db_name(dbid) dbname, segmap, vstart/16777216 vdevno, lstart, vstart, size/512 as used_mb 
from master..sysusages) u,
(select low/16777216 vdevno,  name as device, phyname,
(high-low+1)/512 as size_mb,
 case when status&2=2 or status&16384=16384 then 'on' else 'off' end as dsync
from master..sysdevices
where status&16 <> 16) d -- ignore dump devices
where u.vdevno = d.vdevno
order by dbname

select t.dbname, t.device, t.usage, t.size_mb, t.used_mb, t.left_mb,
m.Reads, m.APFReads, m.Writes, m.IOTime,
m.DevSemaphoreRequests, m.DevSemaphoreWaits, 
convert(numeric(4,2),1.0*m.DevSemaphoreWaits/m.DevSemaphoreRequests*100) '%', 
t.phyname 'physical name'
from #tmp t, master..monDeviceIO m
where t.device = m.LogicalName
order by DevSemaphoreWaits desc

drop table #tmp