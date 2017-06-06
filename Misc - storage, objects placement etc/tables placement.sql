use riskbook -- riskworld logger70
go

select object_name(id) as [Table], 
name as [Index], 
groupname as [Filegroup]
from sysindexes i join sysfilegroups f
on i.groupid = f.groupid
 
go