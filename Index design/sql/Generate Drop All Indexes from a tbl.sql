declare @tbl varchar(200) = 'srf_main.MasterAgreementDetails'
declare idx_crsr  cursor fast_forward forward_only for
select 'drop index '+name+' on '+@tbl
from sys.indexes
where object_id = object_id(@tbl)
declare @sql varchar(300)
open idx_crsr
while 1 = 1
begin 
	fetch idx_crsr into @sql
	if @@fetch_status <> 0
		break	
	print @sql
	exec @sql
end
close idx_crsr
deallocate idx_crsr
print 'check if all indexes were dropped'
exec sp_helpindex @tbl