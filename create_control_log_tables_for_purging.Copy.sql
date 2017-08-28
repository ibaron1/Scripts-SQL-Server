use TFM_Archive
go


if object_id('tfm.ExpiredArchivedDataProcessing') is not null
  drop table tfm.ExpiredArchivedDataProcessing;

create table tfm.ExpiredArchivedDataProcessing
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

 create unique clustered index idx_ExpiredArchivedDataProcessing on tfm.ExpiredArchivedDataProcessing(AppDataType,workflowId,Tbl);

 if object_id('tfm.ExpiredArchivedDataProcessing_History') is not null
  drop table tfm.ExpiredArchivedDataProcessing_History;

create table tfm.ExpiredArchivedDataProcessing_History
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

create clustered index idx_ExpiredArchivedDataProcessing on tfm.ExpiredArchivedDataProcessing_History(AppDataType,workflowId,Tbl,LastDate);

if object_id('tfm.ControlPurgeOfExpiredArchivedData') is not null
  drop table tfm.ControlPurgeOfExpiredArchivedData;

create table tfm.ControlPurgeOfExpiredArchivedData
(DbName varchar(128) not null,
 DbSize_MB int null,
 Orig_DbSpace_Used_MB int null,
 Orig_DbAvailable_Space_MB int null,
 Orig_Percent_Used varchar(4) null,
 Updated_DbSpace_Used_MB int null,
 Updated_DbAvailable_Space_MB int null,
 Updated_Percent_Used varchar(4) null,
 AppDataType varchar(20) null,
 DataPurgeStarted datetime null,
 CurrentRunStarted datetime null,
 CurentRunEnded datetime null,
 DataPurgeEnded datetime null);

 if object_id('tfm.ControlPurgeOfExpiredArchivedData_History') is not null
  drop table tfm.ControlPurgeOfExpiredArchivedData_History;

create table tfm.ControlPurgeOfExpiredArchivedData_History
(DbName varchar(128) not null,
 DbSize_MB int null,
 Orig_DbSpace_Used_MB int null,
 Orig_DbAvailable_Space_MB int null,
 Orig_Percent_Used varchar(4) null,
 Updated_DbSpace_Used_MB int null,
 Updated_DbAvailable_Space_MB int null,
 Updated_Percent_Used varchar(4) null,
 AppDataType varchar(20) null,
 DataPurgeStarted datetime null,
 CurrentRunStarted datetime null,
 CurentRunEnded datetime null,
 DataPurgeEnded datetime null);

go
