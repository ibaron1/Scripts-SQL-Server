use master
go
if exists (select '1' from sysobjects where name = 'sp_MigrateRenamedTableDependencies')
  drop proc sp_MigrateRenamedTableDependencies
go
create proc sp_MigrateRenamedTableDependencies
@table varchar(100)
as
declare @sql varchar(400)
declare @t table(sql varchar(400))
set nocount on
/*************************************************************** 
   Original table name with dependencies renamed as <tbl>_old 
   New table renamed after the original table as <tbl>
***************************************************************/  
insert @t
select distinct 'exec sp_refreshsqlmodule '+object_name(d.id)
from sysdepends d join sysobjects o
on d.id = o.id
and object_name(depid) = @table
declare change_dep_crsr cursor for select sql from @t
open change_dep_crsr
while 1=1 
begin
  fetch next from change_dep_crsr into @sql
  if @@fetch_status = -1
 break
  begin try
    exec(@sql)
  end try
  begin catch
    select
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_LINE() AS ErrorLine,
        ERROR_MESSAGE() AS ErrorMessage
 if XACT_STATE() = -1
   rollback tran
 if XACT_STATE() = 1
   commit tran
  end catch
end
close change_dep_crsr
deallocate change_dep_crsr
go
exec sys.sp_MS_marksystemobject sp_MigrateRenamedTableDependencies
go
grant execute on sp_MigrateRenamedTableDependencies to public
go
