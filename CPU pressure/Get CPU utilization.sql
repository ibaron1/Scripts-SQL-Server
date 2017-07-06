 ;with minMax
 as
 (select min(time_after_new_order) as StartTime,
         max(time_after_new_order) as EndTime
  from new_order_metrics
  union all
  select min(time_after_fill_order),
         max(time_after_fill_order)
  from fill_order_metrics
  union all
  select min(time_before_get_order_summary),
         max(time_before_get_order_summary)
  from get_order_summary)
select * from dbo.udf_GetCPUUsage()
cross apply minMax
where exists
(select 1 from  minMax
 group by EndTime
 having [Event Time] between min(minMax.StartTime) and max(minMax.EndTime))


--==============================================================--

declare @min_time_before datetime2, @min_time_after datetime2

select @min_time_before = min(time_before_new_order), 
       @min_time_after = max(time_after_new_order)
from dbo.new_order_metrics

select * from dbo.udf_GetCPUUsage()
where [Event Time] between @min_time_before and @min_time_after 
order by [Event Time]

select avg([SQLProcessUtilization%])
from dbo.udf_GetCPUUsage()
where [Event Time] between @min_time_before and @min_time_after 