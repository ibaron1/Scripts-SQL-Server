select o1.order_id, o1.version_num, o1.db_update_time, o2.version_num, o2.db_update_time 
from order_activity as o1
join order_activity as o2
on o1.order_id = o2.order_id
where o2.version_num = o1.version_num+1
and o1.db_update_time >= o2.db_update_time
and o1.version_num < (select max(version_num) as max_version_num from order_activity)
order by o1.order_id,o1.version_num, o2.order_id,o2.version_num

--verify
select order_id, version_num, db_update_time
from order_activity
where order_id = '05261-000000000000037359' and version_num in (5,6)

select order_id, version_num, db_update_time
from order_activity
where order_id = '05261-000000000000037360' and version_num in (5,6)