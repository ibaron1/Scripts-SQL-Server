SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- ==================================================================
-- Author: Eli Baron
-- Create date: 2017-06-09
-- ==================================================================
create function dbo.fn_diffsecond 
(@datel datetime,
@date2 datetime
)
returns bigint
as
begin
return	(convert(bigint, datediff(day, @datel, @date2)) * 24 * 60 * 60)
- (datediff(second, dateadd(day, datediff(day, 0, @datel), 0), @datel)) 
+	(datediff(second, dateadd(day, datediff(day, 0, @date2), 0), @date2))
end
go
--Example.
select	dbo.fn_diffsecond('1900-01-02 03:45:56', '9999-12-31 23:59:59')