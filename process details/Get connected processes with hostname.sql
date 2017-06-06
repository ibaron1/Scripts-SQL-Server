select distinct(hostname),  @@servername as instance, db_name(dbid) as dbName, loginame,* 
from master..sysprocesses 
where loginame = 'sysWINMIS'
--where dbid = db_id('FALCON_SRF_Cache') 

