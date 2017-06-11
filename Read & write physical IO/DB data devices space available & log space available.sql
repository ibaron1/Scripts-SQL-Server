set nocount on

/**** 
 --specific db and device
select  db_name(dbid) as dbname, v.name as device,
        sum(size)/512 as db_size_mb,
        sum(curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs))/512 as free_mb
from master..sysusages u,
     master..sysdevices v
where u.segmap != 4
and v.low <= u.size + vstart
and v.high >= u.size + vstart - 1
and v.status & 2 = 2
and db_name(u.dbid) = 'GPS'
and v.name='datadev004'
group by db_name(u.dbid), v.name
****/

-- all dbs and devices
select  db_name(dbid) as dbname, v.name,
        sum(size)/512 as db_size_mb,
        sum(curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs))/512 as free_mb,
        0 as log_mb, 0 as log_free_mb
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

-- db log space
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

-- add available log space for log on seperate device to #data_space
update #data_space
set #data_space.log_mb = #log_space.log_mb,
    #data_space.log_free_mb = #log_space.log_free_mb
from #data_space, #log_space
where #data_space.dbname = #log_space.dbname


/****
select 'total number of devices', count(*) from #data_space

select 'number of devices with space available for 187 mb table', count(*) from #data_space
where free_mb < 187

drop table #data_space
****/

