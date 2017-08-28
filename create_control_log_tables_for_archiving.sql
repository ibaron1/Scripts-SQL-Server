use TFM_Archive
go

if object_id('tfm.DataArchivingAndPurgingConfig') is not null
  drop table tfm.DataArchivingAndPurgingConfig
go
create table tfm.DataArchivingAndPurgingConfig
(DbName varchar(128) not null,
 DbArchivingName varchar(128) not null,
 AppDataType varchar(20),
 workflowId int not null, 
 Tbl varchar(128) not null,
 RetentionDays int null,
 RetentionDaysForArchiving int null,
 ArchivingBatchSize int not null);

create unique clustered index idx_DataArchivingAndPurgingConfig on tfm.DataArchivingAndPurgingConfig(workflowId,Tbl)
go

if object_id('tfm.ArchivingDataProcessing') is not null
  drop table tfm.ArchivingDataProcessing;

create table tfm.ArchivingDataProcessing
(DbName varchar(128) not null,
 AppDataType varchar(20) null,
 workflowId int not null,
 Tbl varchar(128) not null,
 ifArchiveOnboarded char(1) null,
 hasLOBcolumn char(1) null default ('N'),
 ArchiveOlderThan date null,
 RowsToArchive int null,
 StartDate datetime null,
 RowsArchived int null,
 LastDate datetime null,
 EndDate datetime null,
 Error varchar(4000) null);

 create unique clustered index idx_ArchivingDataProcessing on tfm.ArchivingDataProcessing(AppDataType,workflowId,Tbl);

 if object_id('tfm.ArchivingDataProcessing_History') is not null
  drop table tfm.ArchivingDataProcessing_History;

create table tfm.ArchivingDataProcessing_History
(DbName varchar(128) not null,
 AppDataType varchar(20) null,
 workflowId int not null,
 Tbl varchar(128) not null,
 ifArchiveOnboarded char(1) null,
 hasLOBcolumn char(1) null default ('N'),
 ArchiveOlderThan date null,
 RowsToArchive int null,
 StartDate datetime null,
 RowsArchived int null,
 LastDate datetime null,
 EndDate datetime null,
 Error varchar(4000) null);

create clustered index idx_ArchivingDataProcessing on tfm.ArchivingDataProcessing_History(AppDataType,workflowId,Tbl,LastDate);


 if object_id('tfm.ControlOfDataArchiving_History') is not null
  drop table tfm.ControlOfDataArchiving_History;

create table tfm.ControlOfDataArchiving_History
(DbName varchar(128) not null,
 DbSize_MB int null,
 Orig_DbSpace_Used_MB int null,
 Orig_DbAvailable_Space_MB int null,
 Orig_Percent_Used varchar(4) null,
 Updated_DbSpace_Used_MB int null,
 Updated_DbAvailable_Space_MB int null,
 Updated_Percent_Used varchar(4) null,
 AppDataType varchar(20) null,
 DataArchivingStarted datetime null,
 CurrentRunStarted datetime null,
 CurentRunEnded datetime null,
 DataArchivingEnded datetime null);

go

use TFM
go

if object_id('tfm.ControlOfDataArchiving') is not null
  drop table tfm.ControlOfDataArchiving;

create table tfm.ControlOfDataArchiving
(DbName varchar(128) not null,
 DbSize_MB int null,
 Orig_DbSpace_Used_MB int null,
 Orig_DbAvailable_Space_MB int null,
 Orig_Percent_Used varchar(4) null,
 Updated_DbSpace_Used_MB int null,
 Updated_DbAvailable_Space_MB int null,
 Updated_Percent_Used varchar(4) null,
 AppDataType varchar(20) null,
 DataArchivingStarted datetime null,
 CurrentRunStarted datetime null,
 CurentRunEnded datetime null,
 DataArchivingEnded datetime null);

go
