if OBJECT_ID('srf_main.DropMasterAgreementIdx') is not null
  drop proc srf_main.DropMasterAgreementIdx
go
-- ===================================================
-- Author: Eli Baron
-- Create date: 2014-10-0a9
-- Description: To drop indexes from a table
-- ===================================================
create proc srf_main.DropMasterAgreementIdx
@tbl varchar(200) = 'srf_main.MasterAgreementDetails'
as
set nocount on
if exists (select 1 from sys.indexes where object_id = object_id(@tbl))
begin
declare idx_crsr  cursor fast_forward forward_only for
select 'drop index '+name+' on '+@tbl
from sys.indexes
where object_id = object_id(@tbl)
order by index_id desc
declare @sql varchar(300)
open idx_crsr
while 1 = 1
begin 
	fetch idx_crsr into @sql
	if @@fetch_status <> 0
		break	
	--print @sql
	exec(@sql)
end
close idx_crsr
deallocate idx_crsr
end