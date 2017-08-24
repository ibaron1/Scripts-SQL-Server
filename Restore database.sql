use master
go
ALTER DATABASE pruwf_prod_orig SET SINGLE_USER WITH ROLLBACK  IMMEDIATE
go
RESTORE DATABASE pruwf_prod_orig FROM  DISK = N'\\48.127.142.24\SQLServer\pruwf_prod_orig.bak' 
WITH  FILE = 1,  
MOVE N'pruwf_prod_orig' TO N'K:\databases\MSSQL10_50.DCREPEXTPROD\MSSQL\DATA\pruwf_prod_orig.mdf',  
MOVE N'pruwf_prod_orig_log' TO N'J:\databases\MSSQL10_50.DCREPEXTPROD\MSSQL\DATA\pruwf_prod_orig_log.ldf',  
NOUNLOAD,  REPLACE,  STATS = 10
go
ALTER DATABASE pruwf_prod_orig SET MULTI_USER WITH ROLLBACK  IMMEDIATE
go