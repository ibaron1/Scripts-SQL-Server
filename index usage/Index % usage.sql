
SELECT 
    QUOTENAME(s.name) + '.' + QUOTENAME(t.name) AS TableName,
    i.name AS IdxName,
    i.type_desc AS IdxType,
    ius.user_seeks,
    100*(ius.user_seeks*1.) / NULLIF((ius.user_seeks+ius.user_scans+ius.user_lookups),0) AS [%Seek],
    ius.user_scans,
    100*(ius.user_scans*1.) / NULLIF((ius.user_seeks+ius.user_scans+ius.user_lookups),0) AS [%Scan],
    ius.user_lookups,
    100*(ius.user_lookups*1.) / NULLIF((ius.user_seeks+ius.user_scans+ius.user_lookups),0) AS [%Lookup],
    ius.user_updates
FROM sys.indexes i
LEFT JOIN sys.dm_db_index_usage_stats ius
    ON  ius.object_id = i.object_id
        AND ius.index_id = i.index_id
        AND database_id = DB_ID()--Current DB
INNER JOIN sys.tables t
    ON t.object_id = i.object_id
INNER JOIN sys.schemas s
    ON t.schema_id = s.schema_id
WHERE
    t.type = 'U'
    AND t.is_ms_shipped = 0
and i.type_desc <> 'HEAP'
and s.name+ '.' + t.name = 'srf_main.MasterAgreementDetails'
order by 1
--ORDER BY ius.user_seeks + ius.user_scans + ius.user_lookups DESC