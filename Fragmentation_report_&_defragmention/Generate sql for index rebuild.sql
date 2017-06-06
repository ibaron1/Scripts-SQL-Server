use riskworld
go
select distinct 'ALTER INDEX '+IndexName+' ON '+TableName+' REBUILD WITH (SORT_IN_TEMPDB = ON, MAXDOP = 1)','--', page_count
from #indexstats
where avg_page_space_used_in_percent >= 5 and index_level in (0,1)
and IndexName is not null

select distinct 'exec sp_recompile '+TableName
from #indexstats
where avg_page_space_used_in_percent >= 5 and index_level in (0,1) 
