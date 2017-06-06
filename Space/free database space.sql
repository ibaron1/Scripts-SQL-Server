	declare @sqlCommand nvarchar(600), @dbname nvarchar(400) = db_name()
	set @starttime = getdate()
	print ''
	print 'Now compacting data in data files; their physical size do not change : '+cast(@starttime as varchar(24))
	set @sqlCommand = 'dbcc shrinkdatabase ('+@dbname+', notruncate)'
	exec (@sqlCommand)
	print 'End of compacting data : '+cast(getdate() as varchar(24))
	set @run_time = datediff(ss, @starttime, getdate())
	print 'Run time to compact data : '+cast((case when @run_time/3600 > 0 then @run_time/3600 else 0 end) as varchar(2))+' hr '+
	cast((case when (@run_time%3600)/60 > 0 then (@run_time%3600)/60 else 0 end) as varchar(2))+' min '+
	cast((case when @run_time%3600-((@run_time%3600)/60)*60 > 0 then @run_time%3600-((@run_time%3600)/60)*60 else 0 end) as varchar(2))+' sec '
