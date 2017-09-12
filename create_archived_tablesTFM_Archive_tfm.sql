use TFM_Archive
GO
create schema tfm; 
GO

if object_id('tfm.Request') is not null
  drop table tfm.Request
GO

select * into tfm.Request
from TFM.tfm.Request where 1=2

CREATE NONCLUSTERED INDEX idx_correlationId ON tfm.Request (correlationId ASC)

CREATE UNIQUE NONCLUSTERED INDEX idx_transactionId ON tfm.Request (timestamp ASC, transactionId ASC)

GO

if object_id('tfm.Step') is not null
  drop table tfm.Step
GO

select * into tfm.Step
from TFM.tfm.Step where 1=2

CREATE NONCLUSTERED INDEX IX_Step_transactionId ON tfm.Step (transactionId ASC)
INCLUDE (tranStepId)

GO

if object_id('tfm.Activity') is not null
  drop table tfm.Activity
GO

select * into tfm.Activity
from TFM.tfm.Activity where 1=2

CREATE NONCLUSTERED INDEX idx_Activity_tranStepId ON tfm.Activity (tranStepId ASC, timestamp ASC)
INCLUDE (activityId)

CREATE NONCLUSTERED INDEX IX_Activity_timestamp ON tfm.Activity (timestamp ASC)
INCLUDE (tranStepId)

GO

if object_id('tfm.Payload') is not null
  drop table tfm.Payload
GO

select * into tfm.Payload
from TFM.tfm.Payload where 1=2

GO

if object_id('tfm.RequestKeyAttributes') is not null
  drop table tfm.RequestKeyAttributes
GO

select * into tfm.RequestKeyAttributes
from TFM.tfm.RequestKeyAttributes where 1=2

CREATE NONCLUSTERED INDEX i_transactionId_RequestKeyAttributes ON tfm.RequestKeyAttributes (transactionId ASC)

GO

CREATE TABLE tfm.RequestPayloadSummary
(
	  transactionId BIGINT NOT NULL
	, keyAttributesSummary VARCHAR(MAX) NULL
	, CONSTRAINT PK_RequestPayloadId PRIMARY KEY (transactionId ASC)
)

GO

