/*** http://www.mssqltips.com/tip.asp?tip=2042 ****/

SELECT DISTINCT [object_name]  
FROM sys.[dm_os_performance_counters]  
ORDER BY[object_name]; 

/*
object_name
SQLServer:Access Methods                                                                                                        
SQLServer:Broker Activation                                                                                                     
SQLServer:Broker Statistics                                                                                                     
SQLServer:Broker TO Statistics                                                                                                  
SQLServer:Broker/DBM Transport                                                                                                  
SQLServer:Buffer Manager                                                                                                        
SQLServer:Buffer Node                                                                                                           
SQLServer:Buffer Partition                                                                                                      
SQLServer:Catalog Metadata                                                                                                      
SQLServer:CLR                                                                                                                   
SQLServer:Cursor Manager by Type                                                                                                
SQLServer:Cursor Manager Total                                                                                                  
SQLServer:Databases                                                                                                             
SQLServer:Deprecated Features                                                                                                   
SQLServer:Exec Statistics                                                                                                       
SQLServer:General Statistics                                                                                                    
SQLServer:Latches                                                                                                               
SQLServer:Locks                                                                                                                 
SQLServer:Memory Manager                                                                                                        
SQLServer:Plan Cache                                                                                                            
SQLServer:Resource Pool Stats                                                                                                   
SQLServer:SQL Errors                                                                                                            
SQLServer:SQL Statistics                                                                                                        
SQLServer:Transactions                                                                                                          
SQLServer:User Settable                                                                                                         
SQLServer:Wait Statistics                                                                                                       
SQLServer:Workload Group Stats
*/

SELECT [object_name], [counter_name],  
   [instance_name], [cntr_value] 
FROM sys.dm_os_performance_counters 
WHERE [object_name] = 'SQLServer:Buffer Manager'; 


                                                                                                                                                                                                  
