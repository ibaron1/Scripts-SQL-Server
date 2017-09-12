use TFM_Archive
GO
if schema_id('tfmload') is not null
  drop schema tfmload
go
create schema tfmload
GO

if object_id('tfmload.Payload') is not null
  drop table tfmload.Payload
GO
CREATE TABLE tfmload.Payload
(
	  transactionId bigint NOT NULL
	, activityId bigint NOT NULL
	, payload VARCHAR(MAX)
	, FormatType VARCHAR(10)
	, EventType VARCHAR(20)
)

GO

if object_id('tfmload.Activity') is not null
  drop table tfmload.Activity
GO
CREATE TABLE tfmload.Activity
(
	  activityId bigint NOT NULL
	, tranStepId bigint NOT NULL
	, activityName VARCHAR(40)
	, outcome VARCHAR(10)
	, tfmSourceApp VARCHAR(20)
	, tfmDestinationApp VARCHAR(20)
	, timestamp DATETIME
	, duration_ms INT
	, hostAddress VARCHAR(40)
	, hostName VARCHAR(40)
	, CONSTRAINT PK_activityId PRIMARY KEY (activityId ASC)
)

GO

if object_id('tfmload.Step') is not null
  drop table tfmload.Step
GO
CREATE TABLE tfmload.Step
(
	  tranStepId bigint NOT NULL
	, transactionId bigint NOT NULL
	, stepId SMALLINT NOT NULL
	, timestamp DATETIME NOT NULL
	, CONSTRAINT PK_tranStepId PRIMARY KEY (tranStepId ASC)
)

CREATE NONCLUSTERED INDEX IX_Step_transactionId ON tfmload.Step (transactionId ASC)
INCLUDE (tranStepId)

GO

if object_id('tfmload.RequestLoad') is not null
  drop table tfmload.RequestLoad
GO
CREATE TABLE tfmload.RequestLoad
(
	  requestId bigint NOT NULL
	, transactionId bigint NOT NULL
	, activityId bigint NOT NULL
	, lastModified DATETIME
	, replay CHAR(1)
	, loadStatus CHAR(7)
	, loadStarted DATETIME
	, loadEnded DATETIME
	, loadError VARCHAR(400)
	, CONSTRAINT PK_requestId PRIMARY KEY (requestId ASC)
)

GO

if object_id('tfmload.Request') is not null
  drop table tfmload.Request
GO
CREATE TABLE tfmload.Request
(
	  transactionId bigint NOT NULL
	, workflowId INT NOT NULL
	, fileId INT NOT NULL
	, correlationId VARCHAR(40)
	, hostAddress VARCHAR(40)
	, hostName VARCHAR(40)
	, currentSystem VARCHAR(20)
	, outcome VARCHAR(10)
	, timestamp DATETIME
	, duration_ms INT
	, CONSTRAINT PK_transactionId PRIMARY KEY (transactionId ASC)
)

CREATE NONCLUSTERED INDEX idx_correlationId ON tfmload.Request (correlationId ASC)

CREATE UNIQUE NONCLUSTERED INDEX idx_transactionId ON tfmload.Request (timestamp ASC, transactionId ASC)

GO

if object_id('tfmload.FileLoad') is not null
  drop table tfmload.FileLoad
GO
CREATE TABLE tfmload.FileLoad
(
	  fileId INT NOT NULL
	, Name VARCHAR(100)
	, URL VARCHAR(200)
	, lastModified DATETIME NULL
	, replay CHAR(1)
	, loadStatus CHAR(7)
	, loadStarted DATETIME NULL
	, loadEnded DATETIME NULL
	, loadError VARCHAR(400)
	, CONSTRAINT PK_fileId PRIMARY KEY (fileId ASC)
)
create index idx_FileLoad_lastModified on tfmload.FileLoad(lastModified)
GO

if object_id('tfmload.Error') is not null
  drop table tfmload.Error
GO
CREATE TABLE tfmload.Error
(
	  Operation VARCHAR(100)
	, [Table] VARCHAR(100)
	, workflowId INT NOT NULL
	, correlationId VARCHAR(50)
	, ErrorNumber INT NULL
	, ErrorSeverity INT NULL
	, ErrorState INT NULL
	, ErrorProcedure NVARCHAR(128)
	, ErrorLine INT NULL
	, ErrorMessage NVARCHAR(4000)
	, TIMESTAMP DATETIME NOT NULL
)
create index idx_Error_timestamp on tfmload.Error(TIMESTAMP)
GO
CREATE TABLE [tfmload].[RequestKeyAttributes]
(
	  [keyName] VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT('')
	, [keyValue] VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT('')
	, [transactionId] BIGINT NOT NULL
	, CONSTRAINT [PK_transactionId_KeyAttr] PRIMARY KEY ([keyName] ASC, [keyValue] ASC, [transactionId] ASC)
)

ALTER TABLE [tfmload].[RequestKeyAttributes] WITH CHECK ADD CONSTRAINT [FK_transactionId_KeyAttr] FOREIGN KEY([transactionId]) REFERENCES [tfmload].[Request] ([transactionId])
ALTER TABLE [tfmload].[RequestKeyAttributes] CHECK CONSTRAINT [FK_transactionId_KeyAttr]
GOuse TFM_Archive
GO
if schema_id('tfmload') is not null
  drop schema tfmload
go
create schema tfmload
GO

if object_id('tfmload.Payload') is not null
  drop table tfmload.Payload
GO
CREATE TABLE tfmload.Payload
(
	  transactionId bigint NOT NULL
	, activityId bigint NOT NULL
	, payload VARCHAR(MAX)
	, FormatType VARCHAR(10)
	, EventType VARCHAR(20)
)

GO

if object_id('tfmload.Activity') is not null
  drop table tfmload.Activity
GO
CREATE TABLE tfmload.Activity
(
	  activityId bigint NOT NULL
	, tranStepId bigint NOT NULL
	, activityName VARCHAR(40)
	, outcome VARCHAR(10)
	, tfmSourceApp VARCHAR(20)
	, tfmDestinationApp VARCHAR(20)
	, timestamp DATETIME
	, duration_ms INT
	, hostAddress VARCHAR(40)
	, hostName VARCHAR(40)
	, CONSTRAINT PK_activityId PRIMARY KEY (activityId ASC)
)

GO

if object_id('tfmload.Step') is not null
  drop table tfmload.Step
GO
CREATE TABLE tfmload.Step
(
	  tranStepId bigint NOT NULL
	, transactionId bigint NOT NULL
	, stepId SMALLINT NOT NULL
	, timestamp DATETIME NOT NULL
	, CONSTRAINT PK_tranStepId PRIMARY KEY (tranStepId ASC)
)

CREATE NONCLUSTERED INDEX IX_Step_transactionId ON tfmload.Step (transactionId ASC)
INCLUDE (tranStepId)

GO

if object_id('tfmload.RequestLoad') is not null
  drop table tfmload.RequestLoad
GO
CREATE TABLE tfmload.RequestLoad
(
	  requestId bigint NOT NULL
	, transactionId bigint NOT NULL
	, activityId bigint NOT NULL
	, lastModified DATETIME
	, replay CHAR(1)
	, loadStatus CHAR(7)
	, loadStarted DATETIME
	, loadEnded DATETIME
	, loadError VARCHAR(400)
	, CONSTRAINT PK_requestId PRIMARY KEY (requestId ASC)
)

GO

if object_id('tfmload.Request') is not null
  drop table tfmload.Request
GO
CREATE TABLE tfmload.Request
(
	  transactionId bigint NOT NULL
	, workflowId INT NOT NULL
	, fileId INT NOT NULL
	, correlationId VARCHAR(40)
	, hostAddress VARCHAR(40)
	, hostName VARCHAR(40)
	, currentSystem VARCHAR(20)
	, outcome VARCHAR(10)
	, timestamp DATETIME
	, duration_ms INT
	, CONSTRAINT PK_transactionId PRIMARY KEY (transactionId ASC)
)

CREATE NONCLUSTERED INDEX idx_correlationId ON tfmload.Request (correlationId ASC)

CREATE UNIQUE NONCLUSTERED INDEX idx_transactionId ON tfmload.Request (timestamp ASC, transactionId ASC)

GO

if object_id('tfmload.FileLoad') is not null
  drop table tfmload.FileLoad
GO
CREATE TABLE tfmload.FileLoad
(
	  fileId INT NOT NULL
	, Name VARCHAR(100)
	, URL VARCHAR(200)
	, lastModified DATETIME NULL
	, replay CHAR(1)
	, loadStatus CHAR(7)
	, loadStarted DATETIME NULL
	, loadEnded DATETIME NULL
	, loadError VARCHAR(400)
	, CONSTRAINT PK_fileId PRIMARY KEY (fileId ASC)
)
create index idx_FileLoad_lastModified on tfmload.FileLoad(lastModified)
GO

if object_id('tfmload.Error') is not null
  drop table tfmload.Error
GO
CREATE TABLE tfmload.Error
(
	  Operation VARCHAR(100)
	, [Table] VARCHAR(100)
	, workflowId INT NOT NULL
	, correlationId VARCHAR(50)
	, ErrorNumber INT NULL
	, ErrorSeverity INT NULL
	, ErrorState INT NULL
	, ErrorProcedure NVARCHAR(128)
	, ErrorLine INT NULL
	, ErrorMessage NVARCHAR(4000)
	, TIMESTAMP DATETIME NOT NULL
)
create index idx_Error_timestamp on tfmload.Error(TIMESTAMP)
GO
CREATE TABLE [tfmload].[RequestKeyAttributes]
(
	  [keyName] VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT('')
	, [keyValue] VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT('')
	, [transactionId] BIGINT NOT NULL
	, CONSTRAINT [PK_transactionId_KeyAttr] PRIMARY KEY ([keyName] ASC, [keyValue] ASC, [transactionId] ASC)
)

ALTER TABLE [tfmload].[RequestKeyAttributes] WITH CHECK ADD CONSTRAINT [FK_transactionId_KeyAttr] FOREIGN KEY([transactionId]) REFERENCES [tfmload].[Request] ([transactionId])
ALTER TABLE [tfmload].[RequestKeyAttributes] CHECK CONSTRAINT [FK_transactionId_KeyAttr]
GO