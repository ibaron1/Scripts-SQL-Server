set nocount on

select  distinct db_name(u.dbid) as dbname, v.name,
        sum(size)/512 as db_size_mb,
        sum(curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs))/512 as free_mb,
        0 as log_mb, 0 as log_free_mb,
        segmap,
        case 
             when segmap = 3 then 'data'
             when segmap = 4 then 'log' 
             when segmap = 7 then 'data and log'
             when segmap = 1 then 'system'
             when segmap = 0 then ' -- unused by any segments --' 
             when db_name(u.dbid) is not null then 'user segment' end as usage,
        case  when v.status&16384=16384 then 'UFS / dsync on - writes direct'       
            when v.status&2=2 then 'physical disk'
            else 'UFS device / dsync off - OS/buffered writes' end as status,
        v.status as status_flag
into #data_space
from master..sysusages u,
     master..sysdevices v
where u.segmap != 4
and v.low <= u.size + vstart
and v.high >= u.size + vstart - 1
and v.status & 2 = 2
--and db_name(u.dbid) in ('GPS','GPS3','GPS4')
group by db_name(u.dbid), v.name
order by db_name(u.dbid)

select  db_name(dbid) dbname, 
        sum(size)/512 log_mb,
        sum(curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs))/512 as log_free_mb
into #log_space 
from master.dbo.sysusages u,
     master..sysdevices v 
where segmap = 4
and v.low <= u.size + vstart
and v.high >= u.size + vstart - 1
and v.status & 2 = 2
group by dbid 

update #data_space
set #data_space.log_mb = #log_space.log_mb,
    #data_space.log_free_mb = #log_space.log_free_mb
from #data_space, #log_space
where #data_space.dbname = #log_space.dbname

select * from #data_space

drop table #data_space, #log_space