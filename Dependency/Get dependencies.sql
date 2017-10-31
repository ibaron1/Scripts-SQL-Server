
--First Refresh objects dependencies - they will get a different object id if they were dropped and recreated
declare @sql varchar(max) = ''
select  @sql += 'exec sp_refreshsqlmodule '+''''+schema_name(schema_id)+'.'+object_name(object_id)+''';'
from sys.objects
where type in ('P','FN','IF','TF','V','TR')
and schema_name(schema_id) <> 'dbo'
select @sql --and execute

SELECT distinct
DB_NAME() referencing_database_name,
(select schema_name(schema_id) from sys.all_objects where object_id = referencing_id) as referencing_schema_name,
OBJECT_NAME (referencing_id) referencing_entity_name,
(select type_desc from sys.all_objects where object_id = referencing_id) as referencing_entity_type,
ISNULL(referenced_database_name,DB_NAME()) referenced_database_name,
ISNULL(referenced_schema_name,'dbo') referenced_schema_name,
referenced_entity_name,
ao.type_desc referenced_entity_type
FROM sys.sql_expression_dependencies sed
JOIN sys.all_objects ao
ON sed.referenced_entity_name = ao.name 
	where ISNULL(referenced_schema_name,'dbo') = 'tfm'
	and referenced_entity_name = 'Workflow'
