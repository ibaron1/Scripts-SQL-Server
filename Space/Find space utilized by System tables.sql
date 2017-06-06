SELECT [System Table Name], (SELECT ROWS FROM SysIndexes S WHERE S.Indid < 2 AND S.ID = OBJECT_ID(A.[System Table Name])) AS [Total Rows], [Total Space Used in MB] FROM  
(SELECT QUOTENAME(USER_NAME(so.uid)) + '.' + QUOTENAME(OBJECT_NAME(si.id)) AS [System Table Name],
CONVERT(Numeric(15,2),(((CONVERT(Numeric(15,2),SUM(si.Reserved)) * (SELECT LOW FROM master.dbo.spt_values (NOLOCK) WHERE number = 1 AND type = 'E')) / 1024.)/1024.)) AS [Total Space Used in MB]
FROM SysIndexes si (NOLOCK) INNER JOIN SysObjects so (NOLOCK) 
ON    si.id = so.id AND so.type IN ('S') AND (OBJECTPROPERTY(si.id, 'IsMSShipped') = 1)
WHERE indid IN (0, 1, 255)
GROUP BY QUOTENAME(USER_NAME(so.uid)) + '.' + QUOTENAME(OBJECT_NAME(si.id))
) as a
ORDER BY [Total Space Used in MB] DESC
 
