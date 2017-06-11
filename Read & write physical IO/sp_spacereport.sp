IF OBJECT_ID('dbo.sp_spacereport') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.sp_spacereport
    IF OBJECT_ID('dbo.sp_spacereport') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.sp_spacereport >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.sp_spacereport >>>'
END
go
create procedure sp_spacereport
( @summary_only int = 0 )
as
/*
$Id: sp_spacereport.sql,v 1.11 2005/02/22 03:15:32 tomi Exp $
*/
begin
declare @name			varchar(30)
, @object_id		int
, @low			double precision
, @rows			numeric(10,0)
, @reserved		double precision
, @data			double precision
, @index_size		double precision
, @index_text_all       double precision
, @text_image           double precision
, @unused		double precision
, @total_rows		double precision
, @total_reserved	double precision
, @total_data		double precision
, @total_index_size	double precision
, @total_text_image     double precision
, @total_unused		double precision
, @total_db		double precision
, @remaining_data            varchar(18)
, @remaining_data_inter double precision
, @remaining_data_p     double precision
, @data_space_only           varchar(18)
, @data_space_only_p    double precision
, @log_space_only            varchar(18)
, @log_space_size            varchar(18)
, @free_percentage_p    double precision
, @free_percentage           varchar(10)
, @pgsize               numeric(2,0)

select @pgsize = @@maxpagesize/1024
print ""
select @data_space_only = str(sum(size)/(1024/@pgsize),12,2) from master.dbo.sysusages where dbid=db_id() and segmap in (3,7)
select @remaining_data_inter = sum(case when segmap in (3,7) then curunreservedpgs(dbid,lstart,unreservedpgs) else 0 end) from master.dbo.sysusages where dbid = db_id()
select @remaining_data = str(@remaining_data_inter*@@maxpagesize/1048576,12,2)

select @log_space_only = isnull(str(sum(size)/(1024/@pgsize),10,2),"data and log mixed") from master.dbo.sysusages where dbid=db_id() and segmap =4

if ( @log_space_only <> "data and log mixed" )
begin
    select @log_space_size = @log_space_only + " MB"
end
else
begin
    select @log_space_size = @log_space_only
end

select @data_space_only_p = convert(numeric(10,2),@data_space_only)
select @remaining_data_p  = convert(numeric(10,2),@remaining_data)
 
select @free_percentage_p = (@remaining_data_p/@data_space_only_p)*100.00

select @free_percentage = str(@free_percentage_p,8,2)
select	"DATABASE NAME "= db_name(), "   DATASPACE SIZE   "= @data_space_only + " MB", "   REMAINING SPACE "= @remaining_data + " MB", "     LOG SIZE  " = @log_space_size, "   FREE PERCENTAGE" = @free_percentage + " %"



if( @summary_only= 0 )
BEGIN
create
 table #sum
(
name		varchar(30)	    NULL
, rowss		varchar(16)	    NULL
, reserved	varchar(12)	    NULL
, data		varchar(12)	    NULL
, index_size	varchar(12)	    NULL
, text_image    varchar(12)         NULL
, unused	varchar(12)	    NULL
)

select	@total_rows		= 0
, @total_reserved	= 0.0
, @total_data		= 0.0
, @total_index_size	= 0.0
, @total_text_image     = 0.0
, @total_unused		= 0.0

select @low = low
from master.dbo.spt_values
where	number	= 1
and	type	= "E"

select @name = min(name)
from sysobjects
where type="U"

while @name is not null
begin
/* this is not quite right - it ignores same name/different owners */

select @object_id = id
from sysobjects
where name = @name and type="U"

select	@rows		= convert(numeric(10,0),sum(isnull(rowcnt(doampg),0) ))
, @reserved	= sum((isnull(reserved_pgs(id, doampg),0) + isnull(reserved_pgs(id, ioampg),0) )) * @low/@pgsize*2
, @data		= sum(isnull(data_pgs(id, doampg),0) ) * @low/@pgsize*2
from sysindexes
where id = @object_id

select @index_size = sum(isnull(data_pgs(id,ioampg),0) ) * @low/@pgsize*2 from sysindexes where id = @object_id and indid !=255
select @index_text_all = sum(isnull(data_pgs(id,ioampg),0) ) * @low/@pgsize*2 from sysindexes where id = @object_id
select @text_image = @index_text_all - @index_size

select @unused = @reserved - (@data + @index_text_all)

select	@total_rows		= @total_rows + @rows
, @total_reserved	= @total_reserved + @reserved
, @total_data		= @total_data + @data
, @total_index_size	= @total_index_size + @index_size
, @total_text_image     = @total_text_image + @text_image
, @total_unused		= @total_unused + @unused

insert #sum	(
name
, rowss
, reserved
, data
, index_size
, text_image
, unused
)
values	(
@name
, convert(varchar(16),@rows)
, convert(varchar(12),str(@reserved	/ (2048/@pgsize) / 1024.0, 8,4))
, convert(varchar(12),str(@data	/ (2048/@pgsize) / 1024.0, 8,4))
, convert(varchar(12),str(@index_size	/ (2048/@pgsize) / 1024.0, 8,4))
, convert(varchar(12),str(@text_image   / (2048/@pgsize) / 1024.0, 8,4))
, convert(varchar(12),str(@unused	/ (2048/@pgsize) / 1024.0, 8,4))
)

select @name = min(name)
from sysobjects
where	type	= "U"
and	name	> @name
end

/* convert to MBytes */

select	@total_reserved		= @total_reserved / (2048/@pgsize) / 1024
, @total_data		= @total_data / (2048/@pgsize) / 1024
, @total_index_size	= @total_index_size / (2048/@pgsize) / 1024
, @total_text_image     = @total_text_image / (2048/@pgsize) / 1024
, @total_unused		= @total_unused / (2048/@pgsize) / 1024

/*
select @total_db = sum(size) / (1024/@pgsize)
from master.dbo.sysusages_view
where dbid = db_id() and segmap=3
*/
/* send back results to screen */

set nocount on


print ""

select	name		= convert(char(30),name)
, "rows (ESTIMATED)"	= convert(char(16),space(16 - char_length(rowss))	+ rowss)
, "        reserved"	= convert(char(12),space(12 - char_length(reserved))	+ reserved)	+ " MB"
, "            data"	= convert(char(12),space(12 - char_length(data))	+ data)		+ " MB"
, "      index size"	= convert(char(12),space(12 - char_length(index_size))	+ index_size)	+ " MB"
, " text/image size"    = convert(char(12),space(12 - char_length(text_image))  + text_image)   + " MB"
, "alloc'd not used"	= convert(char(12),space(12 - char_length(unused))	+ unused)	+ " MB"
from #sum
order by convert(float,reserved) DESC

print ""

select	TOTAL			= space(30)
, "total rows"		= convert(char(16),space(16 - char_length(str(@total_rows)))+ str(@total_rows))
, "total reserved"	= convert(char(12),space(12 - char_length(convert(varchar,str(@total_reserved, 8,4))))+ convert(varchar,str(@total_reserved, 8,4)))+ " MB"
, "total data"		= convert(char(12),space(12 - char_length(convert(varchar,str(@total_data, 8,4))))+ convert(varchar,str(@total_data, 8,4)))+ " MB"
, "total index"		= convert(char(12),space(12 - char_length(convert(varchar,str(@total_index_size, 8,4))))+ convert(varchar,str(@total_index_size, 8,4)))+ " MB"
, "total text/image"		= convert(char(12),space(12 - char_length(convert(varchar,str(@total_text_image, 8,4))))+ convert(varchar,str(@total_text_image, 8,4)))+ " MB"
, "total unused"	= convert(char(12),space(12 - char_length(convert(varchar,str(@total_unused, 8,4))))+ convert(varchar,str(@total_unused, 8,4)))+ " MB"


print ""
print "The rowcounts above are estimated using Sybase special functions."
print "Any number above 2,127,483,647 is probably inaccurate and is an"
print "indication that update statistics should be run on that table."
END
set nocount off

return 0
end

go
EXEC sp_procxmode 'dbo.sp_spacereport','unchained'
go
IF OBJECT_ID('dbo.sp_spacereport') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.sp_spacereport >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.sp_spacereport >>>'
go
GRANT EXECUTE ON dbo.sp_spacereport TO public
go
