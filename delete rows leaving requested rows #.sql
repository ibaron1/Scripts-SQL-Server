set nocount on
go
DECLARE 
@exec_activity int = 5000000
,@order_activity int = 10000000
,@order_summary int = 10000000
,@count INT = 200000;

WHILE (select rows from sysindexes where object_name(id) = 'exec_activity' and indid in (0,1)) > @exec_activity
BEGIN
  delete TOP (@count) from exec_activity

  select @count = 
	case when (rows-@exec_activity) < @count then rows-@exec_activity
	else @count
	end
  from sysindexes where object_name(id) = 'exec_activity' and indid  in (0,1)
END 

set  @count = 200000

WHILE (select rows from sysindexes where object_name(id) = 'order_activity' and indid  in (0,1)) > @order_activity
BEGIN
  delete TOP (@count) from order_activity

  select @count = 
	case when (rows-@order_activity) < @count then rows-@order_activity
	else @count
	end
  from sysindexes where object_name(id) = 'order_activity' and indid  in (0,1)
END 

set  @count = 200000

WHILE (select rows from sysindexes where object_name(id) = 'order_summary' and indid in (0,1)) > @order_summary
BEGIN
  delete TOP (@count) from order_summary

  select @count = 
	case when (rows-@order_summary) < @count then rows-@order_summary
	else @count
	end
  from sysindexes where object_name(id) = 'order_summary' and indid  in (0,1)
END 
