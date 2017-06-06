use master
go
CREATE PROCEDURE sp_GetStoredProcedureParameters 
 -- Add the parameters for the stored procedure here
 @procedureName sysname
AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;
    DECLARE @db VARCHAR(100)
 SET @db = DB_NAME()
 SELECT a.[name] AS param_name, b.[name] AS data_type, a.length AS max_length, a.xprec as precission, a.xscale as scale, tdefault AS default_value, isoutparam AS param_type
 FROM syscolumns a JOIN systypes b ON a.xtype = b.xtype
 WHERE id=OBJECT_ID(@db+'.dbo.'+@procedureName)

END
go
