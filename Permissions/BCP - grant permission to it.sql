In case I’m not around,  the following command is required to all new databases.  the srfmain already had a access to Bulkadmin role.

Example:


ALTER DATABASE FALCON_SRF_Rates_QA  SET TRUSTWORTHY ON;
go
USE FALCON_SRF_Rates_QA
GO
EXEC dbo.sp_changedbowner @loginame = N'sa', @map = false
GO
