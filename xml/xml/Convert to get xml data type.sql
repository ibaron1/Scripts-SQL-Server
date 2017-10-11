select top 100 [PayloadId], [TradeMessageId], [XmlType], 
	cast(REPLACE(XmlString, '"UTF-8"','"UTF-16"') as xml) as XmlString
from [srf_main].[TradeMessagePayload]



;with cte as
(
select top 100 [PayloadId], [TradeMessageId], [XmlType], 
cast(REPLACE(XmlString, '"UTF-8"','"UTF-16"') as xml) as XmlString
from [srf_main].[TradeMessagePayload]
) 
select * from cte
where XmlString.exist('//*/text()[contains(., "sdsCounterpartyId")]')=1
