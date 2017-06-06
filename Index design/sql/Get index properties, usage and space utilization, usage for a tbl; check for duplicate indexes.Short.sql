set nocount on

select a.crdate as [Date when SQL Server was rebooted],
datediff(day, a.crdate, GETDATE()) as [Number of days since SQL Server reboot]
from sys.sysdatabases a
where name='tempdb'

declare
@operation varchar(10) --DROP, CREATE 
 
set @operation = 'CREATE'

declare @schema varchar(20), @tbl varchar(100), 
@index varchar(100), @clmn varchar(100), @is_unique int, @index_id int
declare @keycnt_cur int, @keycnt int, @keycnt_included int,
@schema_tblname varchar(100),
@sqlToDropIndex varchar(400), @indexKeys varchar(8000), @object_id int,
@filegroup_name varchar(200)

create table #checkForDupIdx
(schemaName varchar(20), tableName varchar(200), objectId int, indexName varchar(200),
 ifUnique varchar(20), indexType varchar(20), 
 indexKeyCnt int, includedClmnCnt int,
 indexKeys varchar(8000))

declare
Idx_crsr cursor fast_forward forward_only for
select SCHEMA_NAME(o.schema_id) as [schema],
o.name as [Table], o.object_id, i.name as Idx,i.index_id,
i.is_unique, -- 1 - unique, 0 - not unique
i.index_id --= 1  - clustered, > 1 - nonclustered
from sys.objects o join sys.indexes i
on o.object_id = i.object_id and o.type = 'U'
where o.object_id = object_id('srf_main.MasterAgreementDetails')
and i.index_id > 0 --and i.is_primary_key <> 1
order by o.name

open Idx_crsr

while 1 = 1
  begin 
	fetch Idx_crsr into @schema, @tbl, @object_id, @index, @index_id, @is_unique, @index_id
	
	if @@FETCH_STATUS <> 0
		break
		
	select @filegroup_name = 
	(select top(1) f.name
	 from sys.filegroups f join sys.indexes i
	 on f.data_space_id = i.data_space_id
	 where i.object_id = @object_id and i.name = @index)

	-- Generate sql for clustered index to recreate it
	-- after index column was modified
	
	select @keycnt = COUNT(*)
	from sys.index_columns
	where object_id = @object_id and index_id = @index_id
	and is_included_column = 0
	
	select @keycnt_cur = 1 --, @schema_tblname = @schema+'.'+@tbl
	
	set @indexKeys = ''
	  
	while @keycnt_cur <= @keycnt
	begin
		select @indexKeys = @indexKeys+
		c.name+case is_descending_key
				when 0 then ' asc' else ' desc' end+
		 case when @keycnt_cur < @keycnt then ',' else '' end 
		from sys.index_columns ic
		join sys.columns c
		on ic.object_id  = c.object_id
		and c.object_id = @object_id
		and ic.index_id = @index_id
		and ic.column_id = c.column_id 
		where index_column_id = @keycnt_cur and is_included_column = 0

		 		 		 
		set @keycnt_cur = @keycnt_cur+1
	end
	
	select @keycnt_included = COUNT(*)
	from sys.index_columns
	where object_id = @object_id and index_id = @index_id
	and is_included_column = 1
	
	declare @keycnt_included_orig int = @keycnt_included
	
	if @keycnt_included > 0
	begin
	  select @indexKeys = @indexKeys+' INCLUDE ('
	  
	  select @keycnt_cur = MIN(index_column_id)
	  from sys.index_columns ic
	  where ic.object_id = @object_id
		and ic.index_id = @index_id
		and ic.is_included_column = 1
		
	  select @keycnt_included = @keycnt_included+@keycnt_cur-1
	
	  while @keycnt_cur <= @keycnt_included
	  begin	
		select @indexKeys = @indexKeys+
		c.name+case when @keycnt_cur < @keycnt_included then ',' else ')' end 
		from sys.index_columns ic
		join sys.columns c
		on ic.object_id  = c.object_id
		and c.object_id = @object_id
		and ic.index_id = @index_id
		and ic.column_id = c.column_id 
		where index_column_id = @keycnt_cur and ic.is_included_column = 1
		 
	    set @keycnt_cur = @keycnt_cur+1
	  end 
	end	
	
    insert #checkForDupIdx
    select @schema, @tbl, @object_id, @index, 
    case @is_unique when 1 then 'unique'
					else 'nonunique' end,
	case @index_id when 1 then ' clustered '
		 else ' nonclustered ' end,
	@keycnt, @keycnt_included_orig, @indexKeys

end

close Idx_crsr
deallocate Idx_crsr

create index i on #checkForDupIdx(indexKeys)

select 'Check for duplicate indexes'
;with cte as 		
(select 
a.schemaName+'.'+a.tableName as tableName1, a.indexName as indexName1, a.ifUnique as ifUnique1, a.indexType as indexType1, a.indexKeys as indexKeys1,
b.schemaName+'.'+b.tableName as tableName2, b.indexName as indexName2, b.ifUnique as ifUnique2, b.indexType as indexType2, b.indexKeys as indexKeys2
from #checkForDupIdx a
join #checkForDupIdx b
on a.indexKeys = b.indexKeys
and a.schemaName+'.'+a.tableName = b.schemaName+'.'+b.tableName
and  a.indexName <> b.indexName)
select tableName1 as [Table], indexName1 as [Index], ifUnique1 as [ifUnique], indexType1 as [Type], indexKeys1 as [Keys]
from cte 

select a.schemaName+'.'+tableName as tableName, a.indexName, 
	a.ifUnique, a.indexType, a.indexKeys,
	--rows, 
	cast(round(I.reserved*8/1024.0,0) as int) as reserved_MB, 
	cast(round(I.used*8/1024.0,0) as int) as used_MB
	    ,CASE WHEN i1.type = 0 THEN 'Heap'
	  WHEN i1.type = 1 THEN 'Clustered' 
          WHEN i1.type = 2 THEN 'Non-Clustered'
          WHEN i1.type = 3 THEN 'XML'  
          ELSE 'N/A' END AS Index_Type 
	,S.user_seeks + S.user_scans + S.user_lookups AS accessedTimes#     
    ,S.user_seeks
    ,cast(round(100*(S.user_seeks*1.) / NULLIF((S.user_seeks+S.user_scans+S.user_lookups),0),2) as dec(5,2)) AS [%Seek]
    ,S.user_scans
    ,cast(round(100*(S.user_scans*1.) / NULLIF((S.user_seeks+S.user_scans+S.user_lookups),0),2) as dec(5,2)) AS [%Scan]
    ,S.user_lookups
	,cast(round(100*(S.user_lookups*1.) / NULLIF((S.user_seeks+S.user_scans+S.user_lookups),0),2) as dec(5,2)) AS [%Lookup]
from #checkForDupIdx a join sysindexes I
on a.objectId = I.id
and a.indexName = I.name
left join sys.dm_db_index_usage_stats S
ON S.index_id= I.indid 
and S.object_id =  I.id
and S.database_id = DB_ID()
join sys.indexes i1
on I.id = i1.object_id and I.indid = i1.index_id
join sys.objects o
on o.object_Id = I.id and o.type = 'U'
where 
i1.type <> 0 --table
--and S.user_seeks > 0 
--and S.user_seeks = 0 

drop table #checkForDupIdx

go