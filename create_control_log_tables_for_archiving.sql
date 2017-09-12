use TFM_Archive
go


create schema core;
go

if object_id('core.TblList') is not null
  drop table core.TblList
go
create table core.TblList
(schemaName varchar(20), Tbl varchar(128) not null);

insert core.TblList
values
('tfm','Payload')
,('tfm','RequestPayloadSummary')
,('tfm','Activity')
,('tfm','Step')
,('tfm','RequestKeyAttributes')
,('tfm','Request')
,('tfm','Error')
,('tfmload','Payload')
,('tfmload','Activity')
,('tfmload','Step')
,('tfmload','RequestKeyAttributes')
,('tfmload','RequestLoad')
,('tfmload','Request')
,('tfmload','FileLoad')
,('tfmload','Error')	
go

if object_id('core.DataArchivingAndPurgingConfig') is not null
  drop table core.DataArchivingAndPurgingConfig
go
create table core.DataArchivingAndPurgingConfig
(DbName varchar(128) not null,
 DbArchivingName varchar(128) not null,
 AppDataType varchar(20),
 workflowId int not null, 
 Tbl varchar(128) not null,
 RetentionDays int null,
 RetentionDaysForArchiving int null,
 ArchivingBatchSize int not null);

create unique clustered index idx_DataArchivingAndPurgingConfig on core.DataArchivingAndPurgingConfig(AppDataType,workflowId,Tbl)
go

if object_id('core.ArchivingDataProcessing') is not null
  drop table core.ArchivingDataProcessing;

create table core.ArchivingDataProcessing
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

 create unique clustered index idx_ArchivingDataProcessing on core.ArchivingDataProcessing(AppDataType,workflowId,Tbl);

 if object_id('core.ArchivingDataProcessing_History') is not null
  drop table core.ArchivingDataProcessing_History;

create table core.ArchivingDataProcessing_History
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

create clustered index idx_ArchivingDataProcessing on core.ArchivingDataProcessing_History(AppDataType,workflowId,Tbl,LastDate);

 if object_id('core.ControlOfDataArchiving') is not null
  drop table core.ControlOfDataArchiving;

create table core.ControlOfDataArchiving
(DbName varchar(128) not null,
 DbSize_GB dec(10,2) null,
 Orig_DbSpace_Used_GB dec(10,2) null,
 Orig_DbAvailable_Space_GB dec(10,2) null,
 Orig_Percent_Used varchar(4) null,
 Updated_DbSpace_Used_GB dec(10,2) null,
 Updated_DbAvailable_Space_GB dec(10,2) null,
 Updated_Percent_Used varchar(4) null,
 AppDataType varchar(20) null,
 DataArchivingStarted datetime null,
 CurrentRunStarted datetime null,
 CurentRunEnded datetime null,
 DataArchivingEnded datetime null);

 if object_id('core.ControlOfDataArchiving_History') is not null
  drop table core.ControlOfDataArchiving_History;

create table core.ControlOfDataArchiving_History
(DbName varchar(128) not null,
 DbSize_GB dec(10,2) null,
 Orig_DbSpace_Used_GB dec(10,2) null,
 Orig_DbAvailable_Space_GB dec(10,2) null,
 Orig_Percent_Used varchar(4) null,
 Updated_DbSpace_Used_GB dec(10,2) null,
 Updated_DbAvailable_Space_GB dec(10,2) null,
 Updated_Percent_Used varchar(4) null,
 AppDataType varchar(20) null,
 DataArchivingStarted datetime null,
 CurrentRunStarted datetime null,
 CurentRunEnded datetime null,
 DataArchivingEnded datetime null);

go

