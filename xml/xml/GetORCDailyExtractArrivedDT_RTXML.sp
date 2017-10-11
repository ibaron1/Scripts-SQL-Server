USE [FALCON_SRF_Rates]
GO
/****** Object:  StoredProcedure [srf_main].[GetORCDailyExtractArrivedDT_RTXML]    Script Date: 06/05/2013 16:31:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [srf_main].[GetORCDailyExtractArrivedDT_RTXML] 
@OFC_Extractdate date = NULL --- '10/21/2012'
WITH EXECUTE AS OWNER, recompile
as	
set nocount on
  
;with xmlnamespaces('http://uri.barcapint.com/BarCapML' as "bc")
	(select distinct ---top 1000
				/*cast(cast(tmp.xmlstring as varchar(max)) as xml) as xml,
				--cast(cast(tmp.xmlstring as varchar(max)) as xml).value('(/bc:BCTrade/bc:tactical/bc:reporting/bc:blockTrade)[1]','varchar(max)') 
				as blockTrade,-- Commented Mithilesh 28 Feb 2013
				--cast(cast(REPLACE(tmp.xmlstring, '<?xml version="1.0" encoding="UTF-8"?>', '' ) as nvarchar(max)) 
				as xml).value('(/bc:BCTrade/bc:tactical/bc:reporting/bc:blockTrade)[1]','varchar(max)')
				*/ 
				case 
				when cast(cast(REPLACE(tmp.xmlstring, '<?xml version="1.0" encoding="UTF-8"?>', '' ) 
				as nvarchar(max)) as xml).value('(/bc:BCTrade/bc:trade/bc:tradeHeader/bc:tradeGroup/bc:groupType/bc:id)[1]','varchar(max)') <> 'allocation' 
				and cast(cast(REPLACE(tmp.xmlstring, '<?xml version="1.0" encoding="UTF-8"?>', '' ) 
				as nvarchar(max)) as xml).value('(/bc:BCTrade/bc:tactical/bc:reporting/bc:blockTrade)[1]','varchar(max)') = 'true' 
				then 'Pre-Allocation'
				
				when cast(cast(REPLACE(tmp.xmlstring, '<?xml version="1.0" encoding="UTF-8"?>', '' ) 
				as nvarchar(max)) as xml).value('(/bc:BCTrade/bc:tactical/bc:reporting/bc:blockTrade)[1]','varchar(max)') = 'true' 
				then 'Pre-Allocation'
				
				when cast(cast(REPLACE(tmp.xmlstring, '<?xml version="1.0" encoding="UTF-8"?>', '' ) 
				as nvarchar(max)) as xml).value('(/bc:BCTrade/bc:tactical/bc:reporting/bc:blockTrade)[1]','varchar(max)') = 'false' 
				and cast(cast(REPLACE(tmp.xmlstring, '<?xml version="1.0" encoding="UTF-8"?>', '' ) 
				as nvarchar(max)) as xml).value('(/bc:BCTrade/bc:trade/bc:tradeHeader/bc:tradeGroup/bc:groupType/bc:id)[1]','varchar(max)') = 'allocation' 
				then 'Post-Allocation' 
				
				else ' ' end 
				as blockTrade,
				case when tm.MsgType in ('CONFIRM','DOCUMENT')
				then
				convert(datetime, dateadd(s, datediff(s,getdate(),getutcdate()),  
				cast(cast(REPLACE(tmp.xmlstring, '<?xml version="1.0" encoding="UTF-8"?>', '' ) 
				as nvarchar(max)) as xml).value('(/bc:BCConfirmationDocument/bc:event/bc:date)[1]','varchar(20)')+' '+
				cast(cast(REPLACE(tmp.xmlstring, '<?xml version="1.0" encoding="UTF-8"?>', '' ) 
				as nvarchar(max)) as xml).value('(/bc:BCConfirmationDocument/bc:event/bc:time)[1]','varchar(20)')), 
				20) 
				else NULL end as ConfirmationDateTime,
				t.publishertradeid, t.PublisherTradeVersion, tm.arrivaldatetime
				into srf_main.orc_OutputXML
				---tm.SRFEventType, t.executiondatetime, tm.arrivaldatetime, tm.submissiondatetime, t.publisher, t.publishertradeid, 
				--t.PublisherTradeVersion, t.producttype, t.productsubtype, tm.MsgType, tm.GTRMsgAction, tm.GTRMsgStatus, tm.SRFMsgStatus, tm.SRFMsgState, tm.arrivaldatetime, tmp.* 
	from 
				srf_main.Trade t(nolock)
				left join srf_main.TradeMessage tm (nolock)on tm.TradeId=t.TradeId
				left join srf_main.TradeMessagePayload tmp (nolock)on tmp.TradeMessageId=tm.TradeMessageId
				where tm.arrivaldatetime >= @OFC_Extractdate and tm.arrivaldatetime < dateadd(d,1,@OFC_Extractdate)  
				and tmp.xmltype='BCML')---as blockTrade
				
create index i on srf_main.orc_OutputXML(PublisherTradeId, PublisherTradeversion)
				
				select * from srf_main.orc_OutputXML
				

