
if object_id('dbo.FileStage') is not null
  drop table dbo.FileStage;
if object_id('dbo.FileLoad') is not null
  drop table dbo.FileLoad;
create table dbo.FileLoad
(fileId int default abs(checksum(rand())),
 fileNam varchar(100),
 fileURL varchar(200),
 lastModified datetime,
 delta smallint, -- file=0, delta changes=1-N 
 replay char(1) null,
 loadStatus char(7), -- success, failure
 loadStarted datetime,
 loadEnded datetime,
 constraint PK_fileId primary key clustered (fileId, delta)); 
create table dbo.FileStage
(fileId int,
 delta smallint,
 _rawStr varchar(max) null,
 constraint FK_fileId foreign key (fileId, delta) references dbo.FileLoad(fileId, delta));
create index idx_fileId on dbo.FileStage(fileId, delta);
