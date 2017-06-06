use master
go
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetReportingTable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_GetReportingTable]
go
/****** Object:  StoredProcedure [dbo].[sp_GetReportingTable]    Script Date: 03/19/2009 22:10:39 ******/

go
SET ANSI_NULLS ON
go

go
SET QUOTED_IDENTIFIER OFF
go


Create Procedure sp_GetReportingTable
(@TableName varchar(50),
 @pFilter VARCHAR(500) = '',
 @pSort VARCHAR(500) = '',
 @pPage INT = 1,
 @pPageRows INT = 10,
 @pKeys VARCHAR(500) = '',
 @dbg char(1) = 'N'		--IB_0917: new parameter will print generated sql to debug: @dbg = 'Y' 
)
as
/*************************************************************************
09/17/2009 
Ilya	Fixed this SP; search --IB_0917 for description of all chages made 
*************************************************************************/


SET NOCOUNT ON

Declare @column  varchar(100),
@status tinyint,
@lookUpTable varchar(100),
@lookUpColumn varchar(100),
@lookupID  varchar(100),
@query nvarchar(max),       --IB_0917: fix to modified SP, was 4000 in prod and changed to 2000 in modified SP; breaks for DTMXExposureTagPaths; changed to max
@columns nvarchar(2000),
@columnsCopy nvarchar(2000),
@fromClause  nvarchar(1000),
@keyID  nvarchar(2000),
@vRowStart INT,
@vTotalRows INT,
@totalPages float

declare @a table(cnt int)

set @lookUpTable = ''
set @lookUpColumn = ''
set @lookupID = ''
set @fromClause = '  from ' + @TableName + ' with (NOLOCK) ' --IB_0917: added with (NOLOCK) from prod
set @keyID = ''
set @columns = ' '
set @pSort = ''
set @columnsCopy = ' ' --IB_0917: fix to modified SP


if @pSort = '' or @pSort is null
	select top 1 @pSort = [name] from syscolumns where id = object_id(@TableName)

Declare sourceColumns CURSOR FORWARD_ONLY
For
select name,status from syscolumns where id =
(select id from sysobjects where name =  @TableName and xtype='U')

OPEN sourceColumns

FETCH NEXT FROM sourceColumns
INTO @column,@status

WHILE @@FETCH_STATUS = 0
BEGIN
 set @lookUpTable = ''
 set @lookUpColumn = ''
 set @lookupID = ''

 if db_name() = 'SecurityNew'   --IB_0917: fix to modified SP
   select @lookUpTable = LookupTable, @lookUpColumn = LookupColumn, @lookupID = LookupID from SecurityNew..ReportingLookup (NOLOCK) where TableName =  @TableName and ColumnName= @column    
 else
   select @lookUpTable = LookupTable, @lookUpColumn = LookupColumn, @lookupID = LookupID from RiskBook..ReportingLookup (NOLOCK) where TableName =  @TableName and ColumnName= @column

 set @keyID = @keyID +  '+ ' + '''|''' + ' +' + ' cast([' + @TableName + '].[' + @column + '] as nvarchar(300)) '

 if (@lookUpTable <> '' and @lookUpColumn <> '')
  begin
   set @columns = @columns + '[' + @lookUpTable + '].[' + @lookUpColumn + '] as [' + @column + '],'
   set @columnsCopy = @columnsCopy + '[' + @column + '],'  --IB_0917: fix to modified SP

   --check for including the left outer only once for every table
   if(CharIndex(' left outer join ' + @lookUpTable ,@fromClause) = 0)
      begin
       set @fromClause = @fromClause + ' left outer join ' + @lookUpTable + ' (NOLOCK) on [' + @TableName + '].[' + @column + '] = ' + @lookUpTable + '.' + @lookupID
      end
  end
 else
  begin
   if( @status = 0x80)
    set @columns = @columns + ' cast([' + @column + '] as varchar) [' + @column + '],'
   else
    set @columns = @columns + '[' + @column + '],'

    set @columnsCopy = @columns --IB_0917: fix to modified SP
  end

 FETCH NEXT FROM sourceColumns
    INTO @column,@status
END

CLOSE sourceColumns
DEALLOCATE sourceColumns

if(@pKeys = '')
Begin
 set @keyID = @keyID + ' as keyID '
 set @keyID = substring(@keyID,8,len(@keyID))
End
else
Begin
 set @keyID = @pKeys + ' as keyID '
End

/****  IB_0917: removed from modified SP, this is incorrect
insert @a exec('select count(*) from ' + @TableName)
select @totalRows = cnt from @a
****/

set @query = 'select count(*) ' + @fromClause  --IB_0917: fix to modified SP 

IF @pFilter != '' AND @pFilter IS NOT NULL  --IB_0917: fix to modified SP      
  set @query = @query + ' ' + @pFilter

if @dbg = 'Y'
  print @query

insert @a exec(@query)					  --IB_0917: fix to modified SP 
select @vTotalRows = cnt from @a

-- If page number = 0, set it to the first page  
if @pPage = 0 set @pPage = 1

-- If page number is beyond the last page, set page to the last page       
IF (@pPage * @pPageRows) > @vTotalRows       
BEGIN       
SET @pPage = @vTotalRows / @pPageRows       
IF (@vTotalRows % @pPageRows) != 0       
 SET @pPage = @pPage + 1       
END 

SET @vRowStart = ((@pPage - 1) * @pPageRows) + 1       
If @vRowStart < 1      
Set @vRowStart = 1  

--set @columnsCopy = @columns --IB_0917: bug when query gets generated thru RiskBook..ReportingLookup 

--remove last coma
set @columns = substring(@columns,1,len(@columns)-1) + ' ,' + @keyID
set @columnsCopy = substring(@columnsCopy,1,len(@columnsCopy)-1) --IB_0917: fix to modified SP

set @query = 'with ' + @TableName 
			+ '_results as(select row_number() over (order by '+ @pSort +') as ''RowNumber'', ' 
			+ @columns  + ' ' + @fromClause + case when @pFilter != '' AND @pFilter IS NOT NULL then @pFilter else '' end + ')select '		--IB_0917: fix to modified SP: added filter and removed top from select
			+ @columnsCopy + ', keyID from ' + @TableName + '_results ' + 'where RowNumber between ' + CAST(@vRowStart AS VARCHAR(10)) +       
                                            ' AND ' + CAST((@vRowStart + @pPageRows - 1) AS VARCHAR(10)) --IB_0917: fix to modified SP 

if @dbg = 'Y'
  print @query

execute (@query)

SET @totalPages  = ( @vTotalRows * 1.0  ) /  ( @pPageRows * 1.0 )       
SELECT @vTotalRows AS totalRows, CEILING(@totalPages)  AS Pages, @pPage AS page      
      
Return 



go
grant execute on sp_GetReportingTable to public
go
