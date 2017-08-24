select
cast(round(1.0 * (
select count(1) from
(select distinct order_id,version_num
from order_summary) as t) /
(select COUNT(1)
 from order_summary), 4) as DEC(5,4))
 as [Column's selectivity]