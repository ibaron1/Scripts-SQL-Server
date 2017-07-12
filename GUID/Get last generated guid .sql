CREATE TABLE dbo.GuidPk (
    ColGuid uniqueidentifier NOT NULL DEFAULT NewSequentialID(), --sequential 36 char number; NEWID() non sequential number
    Col2    int              NOT NULL
)
GO

DECLARE @op TABLE (
    ColGuid uniqueidentifier
)

INSERT INTO dbo.GuidPk (
    Col2
)
OUTPUT inserted.ColGuid
INTO @op
VALUES (1)

SELECT * FROM @op

SELECT * FROM dbo.GuidPk


create table [dbo].[order_activity] 
(id uniqueidentifier constraint UC_order_activity_id unique clustered with fillfactor = 75 rowguidcol default newid(),
[order_id] varchar(24)  NOT NULL , [version_num] int  NOT NULL , 
[ex_dest] varchar(32)  NULL , [order_status] varchar(32)  NULL , [order_msg] varchar(max)  NULL , 
[action_type] varchar(32)  NULL , [action_by] varchar(32)  NULL , [db_update_time] datetime  NOT NULL,
constraint [FK_order_activity_ORDER_ID] foreign key (order_id) references [dbo].[order_summary] (order_id));