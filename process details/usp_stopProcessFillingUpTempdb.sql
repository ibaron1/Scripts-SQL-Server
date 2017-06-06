alter proc [dbo].[usp_stopProcessFill_Tempdb]    
    
as    
    
set nocount on    

declare @sessionId table(Session_ID int)    
declare @sql nvarchar(100)    
    
 insert @sessionId    
 select     
 st.Session_ID    
 FROM sys.dm_tran_active_snapshot_database_transactions st     
 INNER JOIN sys.dm_tran_database_transactions dt     
 ON dt.transaction_id = st.transaction_id     
 INNER JOIN sys.databases db ON db.database_id = dt.database_id     
 INNER JOIN sys.dm_exec_sessions s ON s.session_id = st.session_id    
 join master..sysprocesses p    
 on p.spid = st.Session_ID    
 cross apply sys.dm_exec_sql_text(p.sql_handle)     
 where text in ('SELECT * FROM BEAliases','SELECT className, fieldName, tableName FROM ClassToTable ORDER BY fieldName DESC')    
 and st.elapsed_time_seconds > 1000    

 while exists (select '1' from @sessionId)    
 begin  

   set @sql = 'kill '+(select top 1 CAST(Session_ID as varchar(10)) from @sessionId)    
      
   exec sp_executesql @sql 
   
   print @sql  
   
	 delete @sessionId
	 
	 insert @sessionId    
	 select     
	 st.Session_ID    
	 FROM sys.dm_tran_active_snapshot_database_transactions st     
	 INNER JOIN sys.dm_tran_database_transactions dt     
	 ON dt.transaction_id = st.transaction_id     
	 INNER JOIN sys.databases db ON db.database_id = dt.database_id     
	 INNER JOIN sys.dm_exec_sessions s ON s.session_id = st.session_id    
	 join master..sysprocesses p    
	 on p.spid = st.Session_ID    
	 cross apply sys.dm_exec_sql_text(p.sql_handle)     
	 where text in ('SELECT * FROM BEAliases','SELECT className, fieldName, tableName FROM ClassToTable ORDER BY fieldName DESC')    
	 and st.elapsed_time_seconds > 1000   
          
 end    
    
