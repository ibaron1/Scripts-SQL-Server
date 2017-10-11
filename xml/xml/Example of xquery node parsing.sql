
set transaction isolation level read uncommitted
set nocount on

	set @OFC_ExtractPriordate = coalesce(@OFC_ExtractPriordate, cast(getdate() as date))

    declare @startdate datetime, @enddate datetime

	select @startdate = case
		when datename(dw, @OFC_ExtractPriordate) = 'Monday'
		then dateadd(dd,-3,@OFC_ExtractPriordate)
		when datename(dw, @OFC_ExtractPriordate) = 'Sunday'
		then dateadd(dd,-2,@OFC_ExtractPriordate)
		else dateadd(dd,-1,@OFC_ExtractPriordate) end,
		@enddate = cast((cast(dateadd(dd, -1, @OFC_ExtractPriordate) as varchar(10))+' 23:59:59.998') as datetime)
	
	IF OBJECT_ID('srf_main.orc_OutputXML') IS NOT NULL
    drop table srf_main.orc_OutputXML

	IF OBJECT_ID('srf_main.orc_Output') IS NOT NULL
		drop table srf_main.orc_Output

	IF OBJECT_ID('srf_main.orc_Pending') IS NOT NULL
		drop table srf_main.orc_Pending

	IF OBJECT_ID('srf_main.orc_Corrected') IS NOT NULL
		drop table srf_main.orc_Corrected
	
    IF OBJECT_ID('tempdb.dbo.#orc_OutputXML') IS NOT NULL
    drop table #orc_OutputXML
        
    IF OBJECT_ID('tempdb.dbo.#tmp2') IS NOT NULL
    drop table #tmp2
    
    select distinct tm.MsgType,XmlString,t.publishertradeid, t.PublisherTradeVersion, tm.arrivaldatetime
	into #requiredclmns 
	from srf_main.Trade t 
		join srf_main.TradeMessage tm on tm.TradeId=t.TradeId
				left join srf_main.TradeMessagePayload tmp with (forceseek) 
				on tmp.TradeMessageId=tm.TradeMessageId
				where tm.arrivaldatetime between @startdate and @enddate
				and tmp.xmltype='BCML'
				and tm.MsgType in ('CONFIRM','DOCUMENT')
				and tmp.xmlstring is not null
				AND ISNULL(t.publishertradeid,'')<>'' -- Added Mithilesh 27-09-2013
				--and tm.ReportingJuridictions = 'CFTC'
				--AND tm.ReportingJuridictions<>'CBR' --  Added Mithilesh 30-10-2013 excluding Russia
				AND ISNULL(T.ReportingJurisdiction,'!') <>'CBR' --  Added Mithilesh 30-10-2013 excluding Russia


	--Cut the MQ framework header JIRA SRF-2258,  JIRA SRF-2609   
	update #requiredclmns
	set XmlString = stuff(XmlString, 1, charindex('<?xml version',XmlString)-1,'')
	where XmlString not like '<?xml version%'
	
	--Remove not valid part from the end of xml document JIRA SRF-2609  
	update #requiredclmns
	set XmlString = stuff(XmlString, charindex('</BCTrade>',XmlString)+len('</BCTrade>'),100,'')
	where XmlString like '%</BCTrade>_%'

	--Remove not valid part from the end of xml document JIRA SRF-2609 
	update #requiredclmns
	set XmlString = stuff(XmlString, charindex('</BCConfirmationDocument>',XmlString)+len('</BCConfirmationDocument>'),100,'')
	where XmlString like '%</BCConfirmationDocument>_%'


	
	select MsgType,cast(REPLACE(XmlString, '"UTF-8"','"UTF-16"') as xml) as XmlString,publishertradeid, PublisherTradeVersion, arrivaldatetime
	into #requiredclmnsXml
	from #requiredclmns

	select publishertradeid, PublisherTradeVersion,MsgType, arrivaldatetime,
	stuff((select ';'+ T.C.value('.', 'varchar(20)') 
	from #requiredclmnsXml as a cross apply
		XmlString.nodes('declare namespace bc="http://uri.barcapint.com/BarCapML"; 
					/bc:BCTrade/bc:trade/bc:tradeHeader/bc:clearing/bc:mandatoryClearing/bc:mandatoryClearingJurisdiction') as T(C)
	where a.publishertradeid = b.publishertradeid 
		and a.PublisherTradeVersion = b.PublisherTradeVersion
		and a.MsgType = b.MsgType
		and a.arrivaldatetime = b.arrivaldatetime
	for xml path('')
	)
	,1,1,'') as MandatoryClearingIndicator
    into #MandatoryClearingIndicator
	from #requiredclmnsXml as b
	group by publishertradeid, PublisherTradeVersion,MsgType, arrivaldatetime
	
  