
/* Sccsid = "%Z% generic/sproc/%M% %I% %G%" */
/*	4.8	1.1	06/14/90	sproc/src/spaceused */
 
/*
** Messages for "sp_spaceused"          17830
**
** 17460, "Object must be in the current database." 
** 17461, "Object does not exist in this database."
** 17830, "Object is stored in 'sysprocedures' and
** 	   has no space allocated directly."
** 17831, "Views don't have space allocated."
** 17832, "Not avail."
*/

/*
** IMPORTANT NOTE:
** This stored procedure uses the built-in function object_id() in the
** where clause of a select query. If you intend to change this query
** or use the object_id() or db_id() builtin in this procedure, please read the
** READ.ME file in the $DBMS/generic/sproc directory to ensure that the rules
** pertaining to object-id's and db-id's outlined there, are followed.
*/

create procedure sp_spaceused
@objname varchar(92) = null,		/* the object we want size on */
@list_indices int = 0			/* don't sum all indices, list each */
as

declare @type	smallint		/* the object type */
declare @msg	varchar(1024)		/* message output */
declare @dbname varchar(30)             /* database name */
declare @tabname varchar(30)            /* table name */
declare @length	int
declare @isarchivedb int		/* Is this an archive database? */


if @@trancount = 0
begin
	set chained off
end

set transaction isolation level 1

/* Determine if this is an archive database. */
if exists (select * from master.dbo.sysdatabases
                            where dbid = db_id()
                            and (status3 & 4194304) = 4194304)
        select @isarchivedb = 1
else
	select @isarchivedb = 0

/*
**  Check to see that the objname is local.
*/
if @objname is not null
begin
	/*
        ** Get the dbname and ensure that the object is in the
        ** current database. Also get the table name - this is later
        ** needed to see if information is being requested for syslogs.
        */
        execute sp_namecrack @objname,
                             @db = @dbname output,
                             @object = @tabname output
        if @dbname is not NULL
	begin
		/*
		** 17460, "Object must be in the current database." 
		*/
		if (@dbname != db_name())
		begin
			raiserror 17460
			return (1)
		end
	end

	/*
	**  Does the object exist?
	*/
	if not exists (select *
                        from sysobjects
                                where id = object_id(@objname))
	begin
		/*
		** 17461, "Object does not exist in this database."
		*/
		raiserror 17461
		return (1)
	end

	/* Get the object type */
        select @type = sysstat & 7
                from sysobjects
                        where id = object_id(@objname)
	/*
	**  See if it's a space object.
	**  types are:
	**	0 - trigger
	**	1 - system table
	**	2 - view
	**	3 - user table
	**	4 - sproc
	**	6 - default
	**	7 - rule
	*/
	if not exists (select *
			from sysindexes
				where id = object_id(@objname)
					and indid < 2)
	begin
		if @type in (0, 4, 6, 7)
		begin
			/*
			** 17830, "Object is stored in 'sysprocedures' and
			** 	   has no space allocated directly."
			*/
			raiserror 17830
			return (1)
		end

		if @type = 2
		begin
			/*
			** 17831, "Views don't have space allocated."
			*/
			raiserror 17831
			return (1)
		end
	end

end

/*
**  If @objname is null, then we want summary data.
*/
set nocount on
if @objname is null
begin
	declare @slog_res_pgs numeric(20, 9),  	/* number of reserved pgs. in syslogs */
		@slog_dpgs numeric(20, 9) 	/* number of data pages in syslogs */
	
	if (@isarchivedb = 0)
	begin
		/* This is a normal database. */
		select distinct database_name = db_name(), database_size =
			ltrim(str(sum(size) / (1048576 / d.low), 10, 1)) + " MB"
			from master.dbo.sysusages, master.dbo.spt_values d
				where dbid = db_id()
					and d.number = 1
					and d.type = "E"
				having dbid = db_id()
					and d.number = 1
					and d.type = "E"
	end
	else
	begin
		/* This is an archive database. */
		declare @scratchdb sysname
		declare @dbsize int
		declare @sizestr varchar(128)

		/*
		** The original diskmap is stored in the sysaltusages catalog
		** in the scratch database with a location = 4.
		** Read the scratch database name from sysattributes first.
		*/
		select @scratchdb = convert(sysname, char_value)
		from master.dbo.sysattributes
		where 	class=28
			and object_type="D"
			and object=db_id()
			and attribute=0

		select @sizestr = 'select @dbsize=sum(size) from ' +
				@scratchdb + '.dbo.sysaltusages'+
				' where dbid=' + convert(char,db_id()) +
				' and location = 4'
		exec (@sizestr)
		
		select distinct 
			database_name = db_name(), 
			original_size =
				ltrim(str(@dbsize / (1048576 / d.low), 10, 1)) 
					+ " MB",
			modified_pages_size = 
				ltrim(str(sum(size) / (1048576 / d.low), 10, 1)) 
					+ " MB",
			unused = 
				ltrim(str(sum(unreservedpgs) / (1048576 / d.low), 10, 1)) 
					+ " MB"
		from master.dbo.sysusages, master.dbo.spt_values d
			where dbid = db_id()
				and d.number = 1
				and d.type = "E"
			having dbid = db_id()
				and d.number = 1
				and d.type = "E"
	end
	print ""

	/*
	** Obtain the page count for syslogs table. 
	** 
	** The syslogs system table has only data (no index does exist).
	** Built-in functions reserved_pgs(8, doampg) and data_pgs(8, doampg) 
	** will always return the same value.  This is due to the fact that
	** syslogs pages are allocated an extent worth at a time and all log
	** pages in this extent are set as in use.  This is why we aren't able 
	** to determine the amount of unused syslogs pages by simply doing
	** reserved_pgs - data_pgs.
	**
	** Also note that syslogs table doesn't have OAM pages.  However,
	** builtin functions reserved_pgs() and data_pgs() handle syslogs
	** as a special case.
	*/
	declare @doampg int
	select @doampg = doampg from sysindexes where id = 8
	select @slog_res_pgs = convert(numeric(20, 9), reserved_pgs(8, @doampg)),
	       @slog_dpgs = convert(numeric(20, 9), data_pgs(8, @doampg))

	/*
	** Obtain the page count for all the objects in the current
	** database; except for 'syslogs' (id = 8). Store the results
	** in a temp. table (#pgcounts).
	**
	** Note that we first retrieve the needed information from
	** sysindexes and we only then apply the OAM builtin system
	** functions on that data.  The reason being we want to relax
	** keeping the sh_int table lock on sysindexes for the duration
	** of the command.
	*/
	select distinct
		s.name,
		s.id,
		res_pgs = 0,
		low = d.low,
		dpgs = convert(numeric(20, 9), s.doampg),
		ipgs = convert(numeric(20, 9), s.ioampg),
		unused = convert(numeric(20, 9), 0)
	into #pgcounts 
	from sysindexes s, master.dbo.spt_values d
		where s.id != 8
			and d.number = 1 
			and d.type = "E" 
		having d.number = 1
			and d.type = "E"

	update #pgcounts set
		res_pgs = reserved_pgs(id, dpgs) + reserved_pgs(id, ipgs),
		dpgs = convert(numeric(20, 9), data_pgs(id, dpgs)),
		ipgs = convert(numeric(20, 9), data_pgs(id, ipgs)),
		unused = convert(numeric(20, 9),
			  (reserved_pgs(id, dpgs) + reserved_pgs(id, ipgs)) -
			     (data_pgs(id, dpgs) + data_pgs(id, ipgs)))

	/*
	** Compute the summary results by adding page counts from
	** individual data objects. Add to the count the count of 
	** pages for 'syslogs'.  Convert the total pages to space
	** used in Kilo bytes.
	*/
	select distinct reserved = convert(char(15), convert(varchar(11),
		convert(numeric(11, 0), (sum(res_pgs) + @slog_res_pgs) *
			(low / 1024))) + " " + "KB"),
		data = convert(char(15), convert(varchar(11),
			convert(numeric(11, 0), (sum(dpgs) + @slog_dpgs) *
			(low / 1024))) + " " + "KB"),
		index_size = convert(char(15), convert(varchar(11),
			convert(numeric(11, 0),  sum(ipgs) * (low / 1024)))
			+ " " + "KB"),
		unused = convert(char(15), convert(varchar(11),
			convert(numeric(11, 0), sum(unused) * (low / 1024)))
			+ " " + "KB")
	from #pgcounts
end

/*
**  We want a particular object.
*/
else
begin
	if (@tabname = "syslogs") /* syslogs */
	begin
		declare @free_pages	int, /* log free space in pages */
			@clr_pages	int, /* log space reserved for CLRs */
			@total_pages	int, /* total allocatable log space */
			@used_pages	int, /* allocated log space */
			@ismixedlog	int  /* mixed log & data database ? */

		select @ismixedlog = status2 & 32768
			from master.dbo.sysdatabases where dbid = db_id()

		select @clr_pages = lct_admin("reserved_for_rollbacks", 
						db_id())
		select @free_pages = lct_admin("logsegment_freepages", db_id())
				     - @clr_pages

		select @total_pages = sum(u.size)
		from master.dbo.sysusages u
		where u.segmap & 4 = 4
		and u.dbid = db_id()

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

		select	name = convert(char(15), @tabname),
			total_pages = convert(char(15), @total_pages),
			free_pages = convert(char(15), @free_pages),
			used_pages = convert(char(15), @used_pages),
			reserved_pages = convert(char(15), @clr_pages)
	end
	else
	begin
		/*
		** Obtain the page count for the target object in the current
		** database and store them in the temp table #pagecounts.
		**
		** Note that we first retrieve the needed information from
		** sysindexes and we only then apply the OAM builtin system
		** functions on that data.  The reason being we want to relax
		** keeping the sh_int table lock on sysindexes for the duration
		** of the command.
		*/
		select  name = o.name,
			iname = i.name, 
			i.id,
			low = d.low,
			rowtotal = 0,
			reserved = convert(numeric(20, 9), 0),
			data = convert(numeric(20, 9), i.doampg),
			index_size = convert(numeric(20, 9), i.ioampg),
			unused = convert(numeric(20, 9), 0)
		into #pagecounts
		from sysobjects o, sysindexes i, master.dbo.spt_values d
				where i.id = object_id(@objname)
					and o.id = i.id
					and d.number = 1
					and d.type = "E"
		update #pagecounts set
			rowtotal = rowcnt(data),
			reserved = convert(numeric(20, 9),
				(reserved_pgs(id, data) +
				reserved_pgs(id, index_size))),
			data = convert(numeric(20, 9), data_pgs(id, data)),
			index_size = convert(numeric(20, 9),
				data_pgs(id, index_size)),
			unused = convert(numeric(20, 9),
				((reserved_pgs(id, data) +
				reserved_pgs(id, index_size)) -
				(data_pgs(id, data) +
				data_pgs(id, index_size))))

	    if (@list_indices = 1)
	    begin
		select @length = max(datalength(iname))
			from #pagecounts
		if (@length > 20)
	        	select  index_name = iname,
				size = convert(char(10), convert(varchar(11),
		    	       	       convert(numeric(11, 0),
							index_size / 1024 *
			        			low)) + " " + "KB"),
		    		reserved = convert(char(10), 
					   convert(varchar(11),
		    	       	   	   convert(numeric(11, 0),
						   reserved / 1024 * 
			       			   low)) + " " + "KB"),
		    		unused = convert(char(10), convert(varchar(11),
		    		 	 convert(numeric(11, 0), unused / 1024 *
							low)) + " " + "KB")
	        	from #pagecounts
		else
			select  index_name = convert(char(20), iname),
				size = convert(char(10), convert(varchar(11),
		    	       	       convert(numeric(11, 0),
							index_size / 1024 *
			        			low)) + " " + "KB"),
		    		reserved = convert(char(10), 
					   convert(varchar(11),
		    	       	   	   convert(numeric(11, 0),
						   reserved / 1024 * 
			       			   low)) + " " + "KB"),
		    		unused = convert(char(10), convert(varchar(11),
		    		 	 convert(numeric(11, 0), unused / 1024 *
							low)) + " " + "KB")
	        	from #pagecounts

	    end

	    select @length = max(datalength(name))
		from #pagecounts

	    if (@length > 20)
	        select distinct name,
		    rowtotal = convert(char(11), sum(rowtotal)),
		    reserved = convert(char(15), convert(varchar(11),
		    	       convert(numeric(11, 0), sum(reserved) *
			       (low / 1024))) + " " + "KB"),
		    data = convert(char(15), convert(varchar(11),
		    	       convert(numeric(11, 0), sum(data) * (low / 1024)))
			       + " " + "KB"),
		    index_size = convert(char(15), convert(varchar(11),
		    		convert(numeric(11, 0), sum(index_size) *
				(low / 1024))) + " " + "KB"),
		    unused = convert(char(15), convert(varchar(11),
		    		convert(numeric(11, 0), sum(unused) *
				(low / 1024))) + " " + "KB")
	        from #pagecounts
	    else
	        select distinct name = convert(char(20), name),
		    rowtotal = convert(char(11), sum(rowtotal)),
		    reserved = convert(char(15), convert(varchar(11),
		    	       convert(numeric(11, 0), sum(reserved) *
			       (low / 1024))) + " " + "KB"),
		    data = convert(char(15), convert(varchar(11),
		    	       convert(numeric(11, 0), sum(data) * (low / 1024)))
			       + " " + "KB"),
		    index_size = convert(char(15), convert(varchar(11),
		    		convert(numeric(11, 0), sum(index_size) *
				(low / 1024))) + " " + "KB"),
		    unused = convert(char(15), convert(varchar(11),
		    		convert(numeric(11, 0), sum(unused) *
				(low / 1024))) + " " + "KB")
	        from #pagecounts
	end
end
return (0)

