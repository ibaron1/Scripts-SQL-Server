
declare @run_time int = 13080 --in sec

print 'Run time: '+case when @run_time/3600 > 0 then cast(@run_time/3600 as varchar(2))+' hr ' else '' end+
case when (@run_time%3600)/60 > 0 then cast((@run_time%3600)/60 as varchar(2))+' min ' else '' end+
cast(@run_time%3600-((@run_time%3600)/60)*60 as varchar(2))+' sec '
