use TFM_Archive
go


if object_id('core.ExpiredArchivedDataProcessing') is not null
  drop table core.ExpiredArchivedDataProcessing;

create table core.ExpiredArchivedDataProcessing
(DbName varchar(128) not null,
 AppDataType varchar(20) null,
 workflowId int not null,
 Tbl varchar(128) not null,
 ifDataArchivingOnboarded char(1) null,
 hasLOBcolumn char(1) null default ('N'),
 PurgeExpiredDataOlderThan date null,
 RowsToPurge int null,
 StartDate datetime null,
 RowsPurged int null,
 LastDate datetime null,
 EndDate datetime null,
 Error varchar(4000) null);

 create unique clustered index idx_ExpiredArchivedDataProcessing on core.ExpiredArchivedDataProcessing(AppDataType,workflowId,Tbl);

 if object_id('core.ExpiredArchivedDataProcessing_History') is not null
  drop table core.ExpiredArchivedDataProcessing_History;

create table core.ExpiredArchivedDataProcessing_History
(DbName varchar(128) not null,
 AppDataType varchar(20) null,
 workflowId int not null,
 Tbl varchar(128) not null,
 ifDataArchivingOnboarded char(1) null,
 hasLOBcolumn char(1) null default ('N'),
 PurgeExpiredDataOlderThan date null,
 RowsToPurge int null,
 StartDate datetime null,
 RowsPurged int null,
 LastDate datetime null,
 EndDate datetime null,
 Error varchar(4000) null);

create clustered index idx_ExpiredArchivedDataProcessing on core.ExpiredArchivedDataProcessing_History(AppDataType,workflowId,Tbl,LastDate);

if object_id('core.ControlPurgeOfExpiredArchivedData') is not null
  drop table core.ControlPurgeOfExpiredArchivedData;

create table core.ControlPurgeOfExpiredArchivedData
(DbName varchar(128) not null,
 DbSize_GB dec(10,2) null,
 Orig_DbSpace_Used_GB dec(10,2) null,
 Orig_DbAvailable_Space_GB dec(10,2) null,
 Orig_Percent_Used varchar(4) null,
 Updated_DbSpace_Used_GB dec(10,2) null,
 Updated_DbAvailable_Space_GB dec(10,2) null,
 Updated_Percent_Used varchar(4) null,
 AppDataType varchar(20) null,
 DataPurgeStarted datetime null,
 CurrentRunStarted datetime null,
 CurentRunEnded datetime null,
 DataPurgeEnded datetime null);

 if object_id('core.ControlPurgeOfExpiredArchivedData_History') is not null
  drop table core.ControlPurgeOfExpiredArchivedData_History;

create table core.ControlPurgeOfExpiredArchivedData_History
(DbName varchar(128) not null,
 DbSize_GB dec(10,2) null,
 Orig_DbSpace_Used_GB dec(10,2) null,
 Orig_DbAvailable_Space_GB dec(10,2) null,
 Orig_Percent_Used varchar(4) null,
 Updated_DbSpace_Used_GB dec(10,2) null,
 Updated_DbAvailable_Space_GB dec(10,2) null,
 Updated_Percent_Used varchar(4) null,
 AppDataType varchar(20) null,
 DataPurgeStarted datetime null,
 CurrentRunStarted datetime null,
 CurentRunEnded datetime null,
 DataPurgeEnded datetime null);

go
