declare @Uptime dec(5,3) = 99.999 ;
--Specify the uptime level to calculate 
 
DECLARE @UptimeInterval VARCHAR( 5) ='WEEK' ; 
--Specify WEEK, MONTH, or YEAR SET @UptimeInterval = 'YEAR' ; 

DECLARE @SecondsPerInterval FLOAT ; 
--Calculate seconds per interval 
SET @SecondsPerInterval = 
( SELECT CASE                 
WHEN @UptimeInterval = 'YEAR'                                 
THEN 60* 60* 24* 365.243                 
WHEN @UptimeInterval = 'MONTH'                                 
THEN 60* 60* 24* 30.437                 
WHEN @UptimeInterval = 'WEEK'                                 
THEN 60* 60* 24* 7  END)

declare @UptimeSeconds dec(12,4);

--Calculate uptime

set @UptimeSeconds = @SecondsPerInterval*(100-@Uptime)/100;

--Format results

select convert(varchar(12),floor(@UptimeSeconds/60/60/24)) +' day(s), '
+convert(varchar(12),floor(@UptimeSeconds/60/60%24)) +' hour(s), '
+convert(varchar(12),floor(@UptimeSeconds/60%60)) +' minute(s), '
+convert(varchar(12),floor(@UptimeSeconds%60)) +' second(s).';
