USE TFM
GO

delete TFM_Archive.core.DataArchivingAndPurgingConfig

insert TFM_Archive.core.DataArchivingAndPurgingConfig
(DbName
,DbArchivingName
,AppDataType
,workflowId
,Tbl
,RetentionDays
,RetentionDaysForArchiving
,ArchivingBatchSize)
select 
 db_name()
,db_name()+'_Archive'
,t.schemaName
,w.workflowId
,t.Tbl
,90
,30
,100000
from TFM_Archive.core.TblList as t cross join TFM.tfm.Workflow as w
where not exists
(select '1' from TFM_Archive.core.DataArchivingAndPurgingConfig
 where  workflowId = w.workflowId and schemaName = t.schemaName and Tbl = t.Tbl)

 select * from TFM_Archive.core.DataArchivingAndPurgingConfig

