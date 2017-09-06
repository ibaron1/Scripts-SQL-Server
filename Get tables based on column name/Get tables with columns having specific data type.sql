-- Get tables, columns for a data type
declare @tbl varchar(200) = null
SELECT TABLE_SCHEMA, TABLE_NAME, column_name, 
        data_type + case data_type
            when 'sql_variant' then ''
            when 'text' then ''
            when 'ntext' then ''
            when 'xml' then ''
            when 'decimal' then '(' + cast(numeric_precision as varchar) + ', ' + cast(numeric_scale as varchar) + ')'
            else coalesce('('+case when character_maximum_length = -1 then 'MAX' else cast(character_maximum_length as varchar) end +')','') end as DataType,           
case when exists ( 
        select object_id from sys.columns
        where object_id=so.object_id
        and name=column_name
        and columnproperty(object_id,name,'IsIdentity') = 1 
        ) then
        'IDENTITY(' + 
        cast(ident_seed(so.name) as varchar) + ',' + 
        cast(ident_incr(so.name) as varchar) + ')'
        else 'N/A'
        end as [Identity]

from information_schema.columns isc
join sys.objects so
on isc.TABLE_NAME = so.name and so.type='U' and isc.TABLE_SCHEMA = schema_name(so.schema_id)
where isc.TABLE_NAME = coalesce(@tbl, isc.TABLE_NAME)
and data_type = 'decimal' 

-- Get data type for a column name

declare @tbl varchar(200) = null
--declare @tbl varchar(200) = 'EODValuationFeedData'

SELECT TABLE_SCHEMA, TABLE_NAME, column_name, 
        data_type + case data_type
            when 'sql_variant' then ''
            when 'text' then ''
            when 'ntext' then ''
            when 'xml' then ''
            when 'decimal' then '(' + cast(numeric_precision as varchar) + ', ' + cast(numeric_scale as varchar) + ')'
            else coalesce('('+case when character_maximum_length = -1 then 'MAX' else cast(character_maximum_length as varchar) end +')','') end as DataType,           
case when exists ( 
        select object_id from sys.columns
        where object_id=so.object_id
        and name=column_name
        and columnproperty(object_id,name,'IsIdentity') = 1 
        ) then
        'IDENTITY(' + 
        cast(ident_seed(so.name) as varchar) + ',' + 
        cast(ident_incr(so.name) as varchar) + ')'
        else 'N/A'
        end as [Identity]

from information_schema.columns isc
join sys.objects so
on isc.TABLE_NAME = so.name and so.type='U' and isc.TABLE_SCHEMA = schema_name(so.schema_id)
where isc.TABLE_NAME = coalesce(@tbl, isc.TABLE_NAME)
and column_name like 'publisher%' 
/*and exists
(select 1 from sys.columns
 where object_id = so.object_id and name like 'MappedAssetClass%')*/
order by isc.TABLE_NAME


/*********************************/


select schema_name(o.schema_id) as [schema], o.name as [Table], c.name as ColumnName
from sys.objects o
join sys.columns c
on c.object_id = o.object_id and o.type = 'U'
where lower(c.name) like 'counter%' --'counterpartyname'