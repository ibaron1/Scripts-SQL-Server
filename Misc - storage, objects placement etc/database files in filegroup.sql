use riskbook -- riskworld logger70
go

select db_name() as dbname, f.*
from sysfilegroups g right join sysfiles f
on g.groupid = f.groupid

go