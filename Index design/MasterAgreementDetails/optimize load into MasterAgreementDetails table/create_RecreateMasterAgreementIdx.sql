if OBJECT_ID('srf_main.RecreateMasterAgreementIdx') is not null
  drop proc srf_main.RecreateMasterAgreementIdx
go
-- ===================================================
-- Author: Eli Baron
-- Create date: 2014-10-0a9
-- Description: To recreate indexes for a table
-- ===================================================
create proc srf_main.RecreateMasterAgreementIdx
@tbl varchar(200) = 'srf_main.MasterAgreementDetails'
as
set nocount on

declare @IndexDefinition varchar(8000)

declare idx_crsr  cursor fast_forward forward_only for
select IndexDefinition
from srf_main.SaveMasterAgreementDetailsIdx

open idx_crsr
while 1 = 1
begin 
	fetch idx_crsr into @IndexDefinition
	if @@fetch_status <> 0
		break	
	exec(@IndexDefinition)
end
close idx_crsr
deallocate idx_crsr

exec sp_recompile @tbl
