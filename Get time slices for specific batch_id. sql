select 
max(cast(time_after_new_order as char(19))) as [exec_time for sp_new_order]
--,min(datediff(mcs,time_before_new_order,time_after_new_order)) as min_in_mcs_over_5_sec_interval,
,avg(datediff(mcs,time_before_new_order,time_after_new_order)) as avg_RunTime_in_mcs_over_5_sec_interval 
,count(1) as proc_execs_over_5_sec_interval
--,max(datediff(mcs,time_before_new_order,time_after_new_order)) as max_in_mcs_over_5_sec_interval
from new_order_metrics
GROUP BY DATEADD(second, -DATEDIFF(second, CAST(convert(char(19), time_after_new_order, 108) AS DATE), convert(char(19), time_after_new_order, 108)) % 5, convert(char(19), time_after_new_order, 108))
order by [exec_time for sp_new_order]

--Average run time in mcs across the whole run
;with run_time
as
(select min(time_before_new_order) [Start of run],max(time_after_new_order) as [End of run], datediff(ss, min(time_before_new_order),max(time_after_new_order)) run_time_sec,
avg(datediff(mcs,time_before_new_order,time_after_new_order)) as [Avg sp_new_order execution in mcs]
from new_order_metrics)
select [Start of run],[End of run],
case when run_time_sec/3600 > 0 then cast(run_time_sec/3600 as varchar(2))+' hr ' else '' end+
case when (run_time_sec%3600)/60 > 0 then cast((run_time_sec%3600)/60 as varchar(2))+' min ' else '' end+
cast(run_time_sec%3600-((run_time_sec%3600)/60)*60 as varchar(2))+' sec ' as [Run duration],
[Avg sp_new_order execution in mcs]
from  run_time

select 
max(cast(time_after_fill_order as char(19))) as [exec_time for sp_fill_order]
--,min(datediff(mcs,time_before_fill_order,time_after_fill_order)) as min_in_mcs_over_5_sec_interval,
,avg(datediff(mcs,time_before_fill_order,time_after_fill_order)) as avg_RunTime_in_mcs_over_5_sec_interval 
,count(1) as proc_execs_over_5_sec_interval
--,max(datediff(mcs,time_before_fill_order,time_after_fill_order)) as max_in_mcs_over_5_sec_interval
from fill_order_metrics
where time_before_fill_order > '2017-06-21 14:00'
GROUP BY DATEADD(second, -DATEDIFF(second, CAST(convert(char(19), time_after_fill_order, 108) AS DATE), convert(char(19), time_after_fill_order, 108)) % 5, convert(char(19), time_after_fill_order, 108))
order by [exec_time for sp_fill_order]

--Average run time in mcs across the whole run
;with run_time
as
(select min(time_before_fill_order) [Start of run],max(time_after_fill_order) as [End of run], datediff(ss, min(time_before_fill_order),max(time_after_fill_order)) run_time_sec,
avg(datediff(ms,time_before_fill_order,time_after_fill_order)) as [Avg sp_fill_order in ms]
from fill_order_metrics
where time_before_fill_order > '2017-06-21 14:00'
)
select [Start of run],[End of run],
case when run_time_sec/3600 > 0 then cast(run_time_sec/3600 as varchar(2))+' hr ' else '' end+
case when (run_time_sec%3600)/60 > 0 then cast((run_time_sec%3600)/60 as varchar(2))+' min ' else '' end+
cast(run_time_sec%3600-((run_time_sec%3600)/60)*60 as varchar(2))+' sec ' as [Run duration],
[Avg sp_fill_order in ms]
from  run_time

select 
max(cast(time_after_get_order_summary as char(19))) as [exec_time for get_order_summary_metrics]
--,min(datediff(mcs,time_before_get_order_summary,time_after_get_order_summary)) as min_in_mcs_over_5_sec_interval
,avg(datediff(mcs,time_before_get_order_summary,time_after_get_order_summary)) as avg_RunTime_in_mcs_over_5_sec_interval
,count(1) as proc_execs_over_5_sec_interval 
--,max(datediff(mcs,time_before_get_order_summary,time_after_get_order_summary)) as max_in_mcs_over_5_sec_interval
from get_order_summary_metrics
where time_before_get_order_summary > '2017-06-21 14:00'
GROUP BY DATEADD(second, -DATEDIFF(second, CAST(convert(char(19), time_after_get_order_summary, 108) AS DATE), convert(char(19), time_after_get_order_summary, 108)) % 5, convert(char(19), time_after_get_order_summary, 108))
order by [exec_time for get_order_summary_metrics]

--Average run time in mcs across the whole run
;with run_time
as
(select min(time_before_get_order_summary) [Start of run],max(time_after_get_order_summary) as [End of run], datediff(ss, min(time_before_get_order_summary),max(time_after_get_order_summary)) run_time_sec,
avg(datediff(mcs,time_before_get_order_summary,time_after_get_order_summary)) as [Avg get_order_summary_metrics execution in mcs]
from get_order_summary_metrics
where time_before_get_order_summary > '2017-06-21 14:00')
select [Start of run],[End of run],
case when run_time_sec/3600 > 0 then cast(run_time_sec/3600 as varchar(2))+' hr ' else '' end+
case when (run_time_sec%3600)/60 > 0 then cast((run_time_sec%3600)/60 as varchar(2))+' min ' else '' end+
cast(run_time_sec%3600-((run_time_sec%3600)/60)*60 as varchar(2))+' sec ' as [Run duration],
[Avg get_order_summary_metrics execution in mcs]
from  run_time