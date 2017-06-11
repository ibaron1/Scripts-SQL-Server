select "date     "= convert(char(10),getdate(),101),db_name = d.name, size = convert(char(10), sum(round((a.low * convert(float, u.size)) / 1048576, 1))) + " " + "MB",
                free_mb = str(sum(curunreservedpgs(d.dbid, u.lstart, u.unreservedpgs) * 2)/1024.0, 16) + " " + "MB",
                Perc_Full =str((((sum(round((a.low * convert(float, u.size)) / 1048576, 1)) * 1000) - 
                                (sum(curunreservedpgs(d.dbid, u.lstart, u.unreservedpgs) * 2))) / 
                                ((sum(round((a.low * convert(float, u.size)) / 1048576, 1))) * 1000)) * 100, 16) + " " + "%"
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
               and d.name in ('GPS','GPS3','GPS4')
               group by d.dbid
               order by 4 