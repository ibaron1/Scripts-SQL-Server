
set nocount on

declare proc_cursor cursor fast_forward for 
select name from sys.sysobjects 
where name = 'EODValuationProcessingRewrite'

create table #procparam_parsed
(procExec varchar(4000), parameter# int null)

create table #procparam
(rowNumber int, procname varchar(400),paramname varchar(200),datatype varchar(20),paramtype varchar(6))
 
declare @procname varchar(400), @params# int, @param_cur int
declare @procExec varchar(4000)
 
open proc_cursor
fetch proc_cursor into @procname
           
while (@@fetch_status = 0)  
begin

	insert #procparam
	select row_number() over(order by o.name) as rowNumber,
	o.name as procname,
	c.name as paramname, 
	t.name as datatype,
	case isoutparam 
	when 0 then 'input'
	when 1 then 'output' 
	else '' end as paramtype
	from sys.sysobjects o left join sys.syscolumns c
	on o.id = c.id
	left join sys.types t
	on c.xtype = t.user_type_id
	where o.name = @procname

	select @params# = count(*) from #procparam where paramname is not null
	and paramtype = 'input'
	
	insert #procparam_parsed
	select 'use '+db_name(),@params#
	insert #procparam_parsed
	select 'GO',null
	insert #procparam_parsed
	select 'declare @return int, @start datetime',null
	insert #procparam_parsed
	select 'select @start = getdate()',null
	insert #procparam_parsed
	select ' ',null

	insert #procparam_parsed
	select 'declare '+paramname+' '+datatype,null
	from #procparam
	where procname = @procname
	and paramtype = 'output'

print @procname+' ,parameter# = '+cast(@params# as varchar(3))
	
	set @procExec = 'EXEC @return = '+@procname+' '
	
	if @params# > 0
	begin   
	  set @param_cur = 1
         
		while @param_cur <= @params#
		begin    		
			select @procExec = @procExec+paramname+' = '+
			case when paramtype = 'input' then
				case when datatype like '%char' then ''' '''
					when datatype like '%datetime%' or datatype = 'time' then '''1/1/1999'''
					when datatype like 'text' then ''' '''
					else '0' end
			else paramname+' '+paramtype end +			  			    
			case when @param_cur < @params# then ',' else '' end
			from #procparam
			where rowNumber = @param_cur

			set @param_cur = @param_cur + 1 				
		end
	end

    insert #procparam_parsed
    select @procExec,null

    insert #procparam_parsed
    select ' ',null
    insert #procparam_parsed
    select 'select @return as return_code',null
    insert #procparam_parsed
    select 'select datediff(ms, @start, getdate()) as RunTime_ms',null
    insert #procparam_parsed
    select 'GO',null

    insert #procparam_parsed
    select '/*'+replicate('=',100)+'*/',null

    truncate table #procparam

    fetch proc_cursor into @procname
end

close proc_cursor 
deallocate proc_cursor

select procExec, isnull(cast(parameter# as varchar(3)),'') as [Number of parameters] 
from #procparam_parsed
--order by parameter# 

drop table #procparam
drop table #procparam_parsed


