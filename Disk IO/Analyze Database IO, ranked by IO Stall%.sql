-- Analyze Database I/O, ranked by IO Stall%
WITH DBIO AS
(SELECT DB_NAME(IVFS.database_id) AS db,
 max(MF.physical_name) as [file],
 CASE WHEN MF.type = 1 THEN 'log' ELSE 'data' END AS file_type,
 SUM(IVFS.io_stall) AS io_stall,
 SUM(num_of_reads) as NumberReads, SUM(cast(1.*num_of_bytes_read/(1024*1024) as decimal(20,1))) as MB_Read, 
 SUM(num_of_writes) as NumberWrites, SUM(cast(1.*num_of_bytes_written/(1024*1024) as decimal(20,1))) as MB_Written
 FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS IVFS
 INNER JOIN sys.master_files AS MF
 ON IVFS.database_id = MF.database_id
 AND IVFS.file_id = MF.file_id
 GROUP BY DB_NAME(IVFS.database_id), MF.[type])
SELECT ROW_NUMBER() OVER(ORDER BY io_stall DESC) AS row#,
   db, [file], file_type, 
  CAST(io_stall / 1000. AS DECIMAL(12, 2)) AS io_stall_sec,
  CAST(100. * io_stall / SUM(io_stall) OVER()
       AS DECIMAL(10, 2)) AS io_stall_pct,
  NumberReads, MB_Read, NumberWrites, MB_Written
FROM DBIO
ORDER BY io_stall DESC;

/********** better ***************/

SELECT DB_NAME(fs.database_id) AS [Database Name], mf.physical_name, io_stall_read_ms, num_of_reads,
CAST(io_stall_read_ms/(1.0 + num_of_reads) AS NUMERIC(10,1)) AS [avg_read_stall_ms],io_stall_write_ms,
num_of_writes,CAST(io_stall_write_ms/(1.0+num_of_writes) AS NUMERIC(10,1)) AS [avg_write_stall_ms],
io_stall_read_ms + io_stall_write_ms AS [io_stalls], num_of_reads + num_of_writes AS [total_io],
CAST((io_stall_read_ms + io_stall_write_ms)/(1.0 + num_of_reads + num_of_writes) AS NUMERIC(10,1))
AS [avg_io_stall_ms]
FROM sys.dm_io_virtual_file_stats(null,null) AS fs
INNER JOIN sys.master_files AS mf
ON fs.database_id = mf.database_id
AND fs.[file_id] = mf.[file_id]
ORDER BY avg_io_stall_ms DESC;
