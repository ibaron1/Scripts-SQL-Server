select
cast(round(1.0 * (
select count(1) from
(select distinct Party1SDSID
from srf_main.MasterAgreementDetails) as t) /
(select COUNT(1)
 from srf_main.MasterAgreementDetails), 4) as DEC(5,4))
 as [Column's selectivity]
 
 
select
cast(round(1.0 * (
select count(1) from
(select distinct Party1SDSID, Party2SDSID
from srf_main.MasterAgreementDetails) as t) /
(select COUNT(1)
 from srf_main.MasterAgreementDetails), 4) as DEC(5,4))
 as [Column's selectivity]