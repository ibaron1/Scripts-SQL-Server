USE TFM
GO

delete TFM_Archive.tfm.DataArchivingAndPurgingConfig

declare @tbl table(Tbl varchar(128))

insert @tbl
values
('tfm.Payload')
,('tfm.Activity')
,('tfm.Step')
,('tfm.RequestKeyAttributes')
,('tfm.Request')
,('tfm.Error')	

insert TFM_Archive.tfm.DataArchivingAndPurgingConfig
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
,'TFM'
,w.workflowId
,Tbl
,90
,30
,100000
from @tbl as t cross join tfm.Workflow as w
where not exists
(select '1' from TFM_Archive.tfm.DataArchivingAndPurgingConfig
 where  workflowId = w.workflowId and Tbl = t.Tbl)

 select * from TFM_Archive.tfm.DataArchivingAndPurgingConfig

