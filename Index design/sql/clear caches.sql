DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS
DBCC FREESYSTEMCACHE ('ALL')

select 'DBCC freesystemcache ('+''''+name+''''+')'  from   sys.dm_os_memory_clerks group by name

