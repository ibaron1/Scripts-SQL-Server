use master
go
if exists (select '1' from sysobjects where name = 'sp_DropStatisticsIfExists')
  drop proc sp_DropStatisticsIfExists
go
create proc sp_DropStatisticsIfExists
@table varchar(100),
@column varchar(100)
as
/****
 This SP must be run before altering a column
 1. after dropping PK constraint in case if statistics was additionally created for a column; 
    statistics on column is created when PK created; 
    dropping PK constraint drops a column statistics PK is based on but leaves any statistics additionally created on a column  
 or
 2. if statistics was explicitely created for a column; might be more than 1 statistics created for same column
 Created: 07-01-2009 by Ilya
****/
set nocount on
declare @clmn_stat_name varchar(400), @cnt int
declare @t table(clmn_stat_name varchar(400))
insert @t
select s.[name] 
from sys.stats s join sys.stats_columns sc
  on s.[object_id] = sc.[object_id]
  and s.[object_id] = object_id(@table)
  and s.stats_id = sc.stats_id
join sys.columns c
  on sc.[object_id] = c.[object_id]
  and sc.column_id = c.column_id
  and c.[name] = @column
select @cnt = count(*) from @t
set rowcount 1
while exists (select '1' from @t)
begin 
 select @clmn_stat_name = clmn_stat_name from @t
 print 'Dropping statistics '+@clmn_stat_name+' for column '+@column+' of table '+@table
 exec('drop statistics '+@table+'.'+@clmn_stat_name)
 delete @t    
end
set @clmn_stat_name = null
select @clmn_stat_name = s.[name] 
from sys.stats s join sys.stats_columns sc
  on s.[object_id] = sc.[object_id]
  and s.[object_id] = object_id(@table)
  and s.stats_id = sc.stats_id
join sys.columns c
  on sc.[object_id] = c.[object_id]
  and sc.column_id = c.column_id
  and c.[name] = @column
if @cnt > 0
 if @clmn_stat_name is null
  print 'Statistics was dropped for column '+@column+' of table '+@table
 else
 begin
  print 'Error: statistics was not dropped for column '+@column+' of table '+@table
  return 1
 end
go
exec sys.sp_MS_marksystemobject sp_DropStatisticsIfExists
go
grant execute on sp_DropStatisticsIfExists to public
go
