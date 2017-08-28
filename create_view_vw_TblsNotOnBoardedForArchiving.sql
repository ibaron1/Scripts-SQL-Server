use TFM_Archive
go

if object_id('tfm.vw_TblsNotOnBoardedOrArchived') is not null
  drop view tfm.vw_TblsNotOnBoardedOrArchived
go

/********************************************************
Author. Eli Baron
Date created. 08-07-2017
Purpose. Jira WMTRACAPGO-336, Get not yet archived tables 
********************************************************/

create view tfm.vw_TblsNotOnBoardedOrArchived
as
with tbls
as (select distinct Tbl from tfm.DataArchivingAndPurgingConfig)
,wfId
as (select distinct workflowId from tfm.DataArchivingAndPurgingConfig)
select w.workflowId as [Workflow not onboarded  for archiving], ' ' as [Table not onboarded for archiving], ' ' as [Table not archived (no retention)] 
from TFM.tfm.Workflow as w
where workflowId not in (select workflowId from wfId)
union all
select t.workflowId, tbls.Tbl, ' '  
from tfm.DataArchivingAndPurgingConfig as t
right join tbls
on t.Tbl <> tbls.Tbl
where exists
(select '1' from tfm.DataArchivingAndPurgingConfig 
 where workflowId = t.workflowId
 group by workflowId
 having count(1) < (select count(1) from tbls))
union all 
select workflowId, ' ', Tbl
from tfm.DataArchivingAndPurgingConfig 
where RetentionDays is null