DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS


sp_configure'show advanced options',1
RECONFIGURE
GO

sp_configure 'optimize for ad hoc workloads',1
RECONFIGURE
GO 