select object_name(id) as [table], 
cast(rows as varchar(20))+ '   '+case when object_name(id) like '%_metrics' 
	then 'executions'
	else 'rows' end as [#]
from sysindexes
where object_name(id) in 
('new_order_metrics','fill_order_metrics', 'get_order_summary_metrics',
 'order_summary', 'order_activity','exec_activity')
and indid in (0,1)
order by case when object_name(id) like '%_metrics' 
	then 'executions'
	else 'rows' end, [table] desc

/*
select top 4 *,datediff(mcs,time_before_new_order,time_after_new_order) as Run_rime_mcs
from new_order_metrics
where cast(time_before_new_order as date) = '2017-06-20'
order by time_before_new_order desc

select top 2 * from order_summary
order by db_update_time desc
*/

