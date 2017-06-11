
/* Sccsid = "%Z% generic/sproc/%M% %I% %G%" */
/*	4.8	1.1	06/14/90	sproc/src/fixindex */
/*
** Messages for "sp_helpsegment"        17nnn
**
** 17520, "There is no such segment as '%1!'."
*/
create procedure sp_helpsegment
@segname varchar(30) = NULL		/* segment name */
as

declare @segbit         int,    /* this is the bit version of the segment # */
	@segment        int,    /* the segment number of the segment */
	@free_pages     int,    /* unused pages in segment */
	@factor         float,  /* conversion factor to convert to MB */
	@clr_pages	int,	/* Space reserved for CLRs */
	@total_pages	int,	/* total allocatable log space */
	@used_pages	int,	/* allocated log space */
	@ismixedlog	int	/* mixed log & data database ? */  


if @@trancount = 0
begin
	set chained off
end

set transaction isolation level 1

set nocount on

/*
**  If no segment name given, get 'em all.
*/
if @segname is null
begin
	/* Adaptive Server has expanded all '*' elements in the following statement */ select syssegments.segment, syssegments.name, syssegments.status
		from syssegments order by segment
	return (0)
end

/*
**  Make sure the segment exists
*/
if not exists (select *
	from syssegments
		where name = @segname)
begin
	/* 17520, "There is no such segment as '%1!'." */
	raiserror 17520, @segname
	return (1)
end

/*
**  Show the syssegment entry, then the fragments and size it is on,
**  then any dependent objects in the database.
*/
/* Adaptive Server has expanded all '*' elements in the following statement */ select syssegments.segment, syssegments.name, syssegments.status
	from syssegments
		where name = @segname

/*
**  Set the bit position for the segment.
*/
select @segment = segment
	from syssegments
		where name = @segname

/*
**  Now set the segments on @devname sysusages.
*/
if (@segment < 31)
	select @segbit = power(2, @segment)
else
	/*
	**  Since this is segment 31, power(2, 31) will overflow
	**  since segmap is an int.  We'll grab the machine-dependent
	**  bit mask from spt_values to set the right bit.
	*/
	select @segbit = low
		from master.dbo.spt_values
			where type = "E"
				and number = 2

/*
** Get factor for conversion of pages to megabytes from spt_values
*/
select @factor = convert(float, low) / 1048576.0
        from master.dbo.spt_values
        where number = 1 and type = "E"

select @total_pages = sum(u.size)
	from master.dbo.sysusages u
	where u.segmap & @segbit = @segbit
	and u.dbid = db_id()

select @ismixedlog = status2 & 32768
	from master.dbo.sysdatabases where dbid = db_id()

/*
** Select the sizes of the segments
*/
if (@segbit = 4)
begin
    select device = d.name,
	size = convert(varchar(20), round((sum(u.size) * @factor), 0)) + "MB"
	from master.dbo.sysusages u, master.dbo.sysdevices d
	    where u.segmap & @segbit = @segbit
		and u.dbid = db_id()
		and d.status & 2 = 2
		and u.vstart between d.low and d.high
	    group by d.name order by d.name

    select @clr_pages = lct_admin("reserved_for_rollbacks", db_id())
    select @free_pages = lct_admin("logsegment_freepages", db_id())
			- @clr_pages

    select free_pages = @free_pages

    if(@ismixedlog = 32768)
    begin
	/* 
	** For a mixed log and data database, we cannot
	** deduce the log used space from the total space
	** as it is mixed with data. So we take the expensive
	** way by scanning syslogs.
	*/
	select @used_pages = lct_admin("num_logpages", db_id())

	/* Account allocation pages as used pages */
	select @used_pages = @used_pages + (@total_pages / 256)
    end
    else
    begin
	/* Dedicated log database */
	select @used_pages = @total_pages - @free_pages 
			   - @clr_pages
    end
end
else
begin
    select device = d.name,
	size = convert(varchar(20), round((sum(u.size) * @factor), 0)) + "MB",
	free_pages = sum(curunreservedpgs(db_id(), u.lstart, u.unreservedpgs))
	from master.dbo.sysusages u, master.dbo.sysdevices d
            where u.segmap & @segbit = @segbit
		and u.dbid = db_id()
		and d.status & 2 = 2
		and u.vstart between d.low and d.high
	    group by d.name order by d.name

    select @free_pages = sum(curunreservedpgs(db_id(), u.lstart, u.unreservedpgs))
	from master.dbo.sysusages u
	    where u.segmap & @segbit = @segbit
		and u.dbid = db_id()

    select @used_pages = @total_pages - @free_pages
    select @clr_pages = 0
end

/*
** Select the dependent objects
*/
if exists (select *
		from sysindexes i, syssegments s
			where s.name = @segname
				and s.segment = i.segment)
begin
	select table_name = object_name(i.id), index_name = i.name, i.indid
		from sysindexes i, syssegments s
			where s.name = @segname
				and s.segment = i.segment
		order by table_name, indid
end

/*
** Print total_size, total_pages, free_pages, used_pages and reserved_pages
*/

select total_size = convert(varchar(15), 
	round(@total_pages * @factor, 0)) + "MB",
	total_pages = convert(char(15), @total_pages),
	free_pages = convert(char(15), @free_pages),
	used_pages = convert(char(15), @used_pages),
	reserved_pages = convert(char(15), @clr_pages)
		
return (0)

