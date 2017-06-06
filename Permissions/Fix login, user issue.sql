USE [FALCON_SRF_FX]
GO
EXEC sp_addrolemember N'db_owner', N'srfmain'
GO
go
EXEC sp_change_users_login 'auto_fix', 'srfmain'
go
