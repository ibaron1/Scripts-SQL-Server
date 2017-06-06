select a.crdate as [Date when SQL Server was rebooted],
datediff(day, a.crdate, GETDATE()) as [Number of days since SQL Server reboot]
from sys.sysdatabases a
where name='tempdb'