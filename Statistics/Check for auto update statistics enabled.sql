
--database
select name, is_auto_update_stats_on , is_auto_update_stats_async_on 
from sys.databases

--table
exec sp_autostats 'srf_main.MasterAgreementDetails'; --display only

exec sp_autostats 'srf_main.MasterAgreementDetails', 'ON'; --or OFF change; null - display

exec sp_autostats 'srf_main.MasterAgreementDetails', 'ON', idx; --or OFF change; null - display for index

------ this will turn sync auto update stats off
update statistics  srf_main.CounterParty with norecompute

------ this will turn sync auto update stats on
update statistics  srf_main.CounterParty




