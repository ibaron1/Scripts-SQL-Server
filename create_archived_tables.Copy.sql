use TFM_Archive
GO
create schema tfm; 
GO

if object_id('tfm.Request') is not null
  drop table tfm.Request
GO
CREATE TABLE tfm.Request
(
	  transactionId INT NOT NULL 
	, workflowId INT  NOT NULL
	, fileId INT  NOT NULL
	, correlationId VARCHAR(40) NULL
	, hostAddress VARCHAR(40) NULL
	, hostName VARCHAR(40) NULL
	, currentSystem VARCHAR(20) NULL
	, outcome VARCHAR(10) NULL
	, timestamp DATETIME NULL
	, duration_ms INT NULL
	, CONSTRAINT PK_transactionId PRIMARY KEY (transactionId ASC)
)

CREATE NONCLUSTERED INDEX idx_correlationId ON tfm.Request (correlationId ASC)

CREATE UNIQUE NONCLUSTERED INDEX idx_transactionId ON tfm.Request (timestamp ASC, transactionId ASC)

GO

if object_id('tfm.Step') is not null
  drop table tfm.Step
GO
CREATE TABLE tfm.Step
(
	  tranStepId INT NOT NULL
	, transactionId INT  NOT NULL
	, stepId SMALLINT NULL
	, timestamp DATETIME NULL
	, duration_ms INT NULL
	, CONSTRAINT PK_tranStepId PRIMARY KEY (tranStepId ASC)
)

CREATE NONCLUSTERED INDEX IX_Step_transactionId ON tfm.Step (transactionId ASC)
INCLUDE (tranStepId)

GO

if object_id('tfm.Activity') is not null
  drop table tfm.Activity
GO
CREATE TABLE tfm.Activity
(
	  activityId INT NOT NULL
	, tranStepId INT  NOT NULL
	, activityName VARCHAR(40) NULL
	, outcome VARCHAR(10) NULL
	, tfmSourceApp VARCHAR(20) NULL
	, tfmDestinationApp VARCHAR(20) NULL
	, timestamp DATETIME NULL
	, duration_ms INT NULL
	, hostAddress VARCHAR(40) NULL
	, hostName VARCHAR(40) NULL
	, CONSTRAINT PK_activityId PRIMARY KEY (activityId ASC)
)


CREATE NONCLUSTERED INDEX idx_Activity_tranStepId ON tfm.Activity (tranStepId ASC, timestamp ASC)
INCLUDE (activityId)

CREATE NONCLUSTERED INDEX IX_Activity_timestamp ON tfm.Activity (timestamp ASC)
INCLUDE (tranStepId)

GO

if object_id('tfm.Payload') is not null
  drop table tfm.Payload
GO
CREATE TABLE tfm.Payload
(
	  transactionId INT  NOT NULL
	, activityId INT  NOT NULL
	, payload VARCHAR(MAX) NULL
	, FormatType VARCHAR(10) NULL
	, EventType VARCHAR(20) NULL
)

GO

if object_id('tfm.RequestKeyAttributes') is not null
  drop table tfm.RequestKeyAttributes
GO
CREATE TABLE tfm.RequestKeyAttributes
(
	  keyName VARCHAR(100) NOT NULL
	, keyValue VARCHAR(100) NOT NULL
	, transactionId INT NOT NULL
	, CONSTRAINT PK_transactionId_KeyAttr PRIMARY KEY (keyName ASC, keyValue ASC, transactionId ASC)
)


CREATE NONCLUSTERED INDEX i_transactionId_RequestKeyAttributes ON tfm.RequestKeyAttributes (transactionId ASC)

GO

