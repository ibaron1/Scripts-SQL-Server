
/*********************************************************************************************
 In all dependent objects for the table (views, procs, triggers)
 evaluate WHERE, HAVING, GROUP BY, ORDER BY clauseS to evaluate the column for candidate index 

Use isql with -b to get rid of query headers  
*********************************************************************************************/

use GPS
go

set nocount on

declare @tbl varchar(30), @clmn varchar(30)



set @tbl = 'pr_secmast'

set @clmn = 'smoundsecid' 

select distinct object_name(d.id) ProcOrView, o.type
into #dependObj
from sysdepends d, sysobjects o 
where d.id = o.id
and object_name(depid) = @tbl
order by o.type 


select 'Find procs/views/triggers with the column for candidate index'
select ''
select distinct d.ProcOrView, 
case when d.type='P' then 'Proc' 
	when d.type='V' then 'View'
	when d.type='TR' then 'Trigger' end as Type
into #tmp   
from syscomments c, #dependObj d
where object_name(c.id) = d.ProcOrView
and c.text like '%'+@tbl+'%' and c.text like '%'+@clmn+'%'

select ''
select 'Procs/views/triggers dependent on table: '+char(9)+@tbl, 'for candidate index on column: '+char(9)+@clmn+' - '+convert(varchar(4), count(*)) from #tmp
select ''
select 'List of objects with this table and column(s):'
select ''
select * from #tmp order by Type, ProcOrView
select ''
select 'Total number of procs/views/triggers dependent on table '+@tbl+' - '+convert(varchar(4), count(*)) from #dependObj
select ''
select 'Evaluate column for WHERE, HAVING, GROUP BY, ORDER BY clauseS in these objects:'
select ''
select d.ProcOrView,
	case when d.type='P' then 'Proc' 
	when d.type='V' then 'View'
	when d.type='TR' then 'Trigger' end as Type,char(10)+replicate(char(1),87)+char(10),
c.text+char(10)+char(10) 
from syscomments c, #dependObj d
where object_name(c.id) = d.ProcOrView
and c.text like '%'+@tbl+'%' and c.text like '%'+@clmn+'%' 


drop table #dependObj, #tmp
go
exit
