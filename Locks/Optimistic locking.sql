The following example illustrates how I use rowversion datatype to implement optimistic concurrency under SQL Server's default READ COMMITTED isolation level.

	First, we'll build a new table called Part with a rowversion added to it.

------------------------------------------------------------------
create table dbo.Part
(
partid int identity(1,1) not null primary key,
partname nvarchar(50) not null unique,
sku nvarchar(50) not null,
rowid rowversion not null
)
go

insert into dbo.Part (partname, sku)
select 'Widget', 'default sku'
go
------------------------------------------------------------------


	Now, in a new Management Studio connection, run the following script


------------------------------------------------------------------
declare @rowid rowversion

select @rowid = rowid
from dbo.Part
where partid = 1

-- wait 30 seconds to simulate
-- a user examining the row and
-- making a data modification
waitfor delay '00:00:30'


update dbo.Part
set sku = 'connection 1: updated'
where partid = 1
and rowid = @rowid

if @@rowcount = 0
begin
      if not exists (select 1 from dbo.Part where partid = 1)
          print 'this row was deleted by another user'
      else
          print 'this row was updated by another user.'
end
go
------------------------------------------------------------------


	Now, in another Management Studio connection, run the following script while the previous script is running


------------------------------------------------------------------

update dbo.Part
set sku = 'connection 2: updated'
where partid = 1
go
------------------------------------------------------------------


	You'll receive the following message in the results pane of the first connection:


------------------------------------------------------------------

(0 row(s) affected)
  
this row was updated by aother user.
------------------------------------------------------------------


Re-run the first connection but this time run the following script to delete the part in a separate connection while the previous script is running

------------------------------------------------------------------
delete from dbo.Part
where partid = 1
go
------------------------------------------------------------------


You'll now receive the following message in the results pane of the first connection:


------------------------------------------------------------------

(0 row(s) affected)
  
this row was deleted by aother user
------------------------------------------------------------------
