
@OFC_Extractdate date = NULL --- '10/21/2012'
WITH EXECUTE AS OWNER, recompile
as	
declare @OFC_Extractdate1 datetime
select @OFC_Extractdate1 = @OFC_Extractdate
begin

 
    
with xmlnamespaces('http://uri.barcapint.com/BarCapML' as "bc")
	(select distinct ---top 1000
				---cast(cast(tmp.xmlstring as varchar(max)) as xml) as xml,
				--cast(cast(tmp.xmlstring as varchar(max)) as xml).value('(/bc:BCTrade/bc:tactical/bc:reporting/bc:blockTrade)[1]','varchar(max)') as blockTrade,-- Commented Mithilesh 28 Feb 2013
				--cast(cast(REPLACE(tmp.xmlstring, '<?xml version="1.0" encoding="UTF-8"?>', '' ) as nvarchar(max)) as xml).value('(/bc:BCTrade/bc:tactical/bc:reporting/bc:blockTrade)[1]','varchar(max)') 
				case 
				when cast(cast(REPLACE(tmp.xmlstring, '<?xml version="1.0" encoding="UTF-8"?>', '' ) as nvarchar(max)) as xml).value('(/bc:BCTrade/bc:tactical/bc:reporting/bc:blockTrade)[1]','varchar(max)') = 'true' 
				then 'Pre-Allocation'
				when cast(cast(REPLACE(tmp.xmlstring, '<?xml version="1.0" encoding="UTF-8"?>', '' ) as nvarchar(max)) as xml).value('(/bc:BCTrade/bc:tactical/bc:reporting/bc:blockTrade)[1]','varchar(max)') = 'false' 
				then 'Post-Allocation'
				when cast(cast(REPLACE(tmp.xmlstring, '<?xml version="1.0" encoding="UTF-8"?>', '' ) as nvarchar(max)) as xml).value('(/bc:BCTrade/bc:trade/bc:tradeHeader/bc:relatedTrade/bc:role/bc:id[@type="Block"])[1]','varchar(max)') = 'Block'
				then 'Post-Allocation' 
				else ' ' end 
				as blockTrade,
				case when tm.MsgType in ('CONFIRM','DOCUMENT')
				then
				convert(varchar(24), dateadd(s, datediff(s,getdate(),getutcdate()),  
				cast(cast(REPLACE(tmp.xmlstring, '<?xml version="1.0" encoding="UTF-8"?>', '' ) as nvarchar(max)) as xml).value('(/bc:BCConfirmationDocument/bc:event/bc:date)[1]','varchar(20)')+' '+
				cast(cast(REPLACE(tmp.xmlstring, '<?xml version="1.0" encoding="UTF-8"?>', '' ) as nvarchar(max)) as xml).value('(/bc:BCConfirmationDocument/bc:event/bc:time)[1]','varchar(20)')), 
				20) 
				else NULL end as ConfirmationDateTime,
				t.publishertradeid, t.PublisherTradeVersion, tm.arrivaldatetime
				into srf_main.orc_OutputXML
				---tm.SRFEventType, t.executiondatetime, tm.arrivaldatetime, tm.submissiondatetime, t.publisher, t.publishertradeid, t.PublisherTradeVersion, t.producttype, t.productsubtype, tm.MsgType, tm.GTRMsgAction, tm.GTRMsgStatus, tm.SRFMsgStatus, tm.SRFMsgState, tm.arrivaldatetime, tmp.* 
	from 
				srf_main.Trade t(nolock)
				left join srf_main.TradeMessage tm (nolock)on tm.TradeId=t.TradeId
				left join srf_main.TradeMessagePayload tmp (nolock)on tmp.TradeMessageId=tm.TradeMessageId
				where convert(date,tm.arrivaldatetime) = @OFC_Extractdate1 
				and tmp.xmltype='BCML')---as blockTrade
				
				select * from srf_main.orc_OutputXML
				
end


