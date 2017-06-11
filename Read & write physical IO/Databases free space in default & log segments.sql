
-- Free space in default segment
select db_name = d.name,
       free_mb_in_default = convert(int,(sum(curunreservedpgs(d.dbid, u.lstart, u.unreservedpgs) * 2)/1024.0))
into #freeDataSpace
            from master..sysdatabases d,
                 master..sysusages u,
                 master..sysdevices v,
                 master..spt_values a,
                 master..spt_values b,
                 master..sysmessages m
            where d.dbid = u.dbid
                        and u.segmap <> 4
                        and v.low <= u.size + vstart
                        and v.high >= u.size + vstart - 1
                        and v.status & 2 = 2
                        and a.type = "E"
                        and a.number = 1
                        and b.type = "S"
                        and u.segmap & 7 = b.number
                        and b.msgnum = m.error
                        and d.dbid > 3 and d.dbid < 20
            group by d.dbid
            order by d.dbid 

-- Free space in log segment
select db_name = d.name,
       free_mb_in_log	   = convert(int,(sum(curunreservedpgs(d.dbid, u.lstart, u.unreservedpgs) * 2)/1024.0))
into #freeLogSpace
            from master..sysdatabases d,
                 master..sysusages u,
                 master..sysdevices v,
                 master..spt_values a,
                 master..spt_values b,
                 master..sysmessages m
            where d.dbid = u.dbid
                        and u.segmap = 4
                        and v.low <= u.size + vstart
                        and v.high >= u.size + vstart - 1
                        and v.status & 2 = 2
                        and a.type = "E"
                        and a.number = 1
                        and b.type = "S"
                        and u.segmap & 7 = b.number
                        and b.msgnum = m.error
                        and d.dbid > 3 and d.dbid < 20
            group by d.dbid
            order by d.dbid