 DECLARE @myDoc xml --nvarchar(max)
 
    SET @myDoc = 
'<BCTrade xmlns="http://uri.barcapint.com/BarCapML">
  <header>
    <version edition="4" major="13" minor="0" branchNumber="15" branchMajor="0" branchMinor="1" revision="0" name="credit" build="1">4.13.0_15.0.1_credit_1</version>
  </header>
  <event>
    <eventName>New</eventName>
    <eventId>
      <id type="echelonEventId">SE2306169</id>
    </eventId>
    <date>2013-09-13</date>
    <time>04:26:10</time>
    <effectiveDate>2013-09-13</effectiveDate>
    <effectiveTime>04:26:10</effectiveTime>
    <executionDate>2013-09-13</executionDate>
    <executionTime>04:26:10</executionTime>
    <verificationStatus>Unverified</verificationStatus>
    <initiatingUserId>
      <id type="adSamAccountName">msobel1</id>
    </initiatingUserId>
  </event>
  <trade>
    <tradeHeader>
      <tradeId>
        <id type="echelonTradeId" version="1">S2296040</id>
        <alternateId type="sdapsTradeId" version="0">45136784</alternateId>
      </tradeId>
      <USI>
        <namespace>1030209452</namespace>
        <transaction>
          <id type="sdapsUSI">1004SDAPS45136784ZZZZZZZZZZZZZZZ</id>
        </transaction>
      </USI>
      <legalEntity>
        <partyId>
          <id type="sdsCounterpartyId">40001104</id>
          <alternateId type="dtccParticipantId">00006Z05</alternateId>
        </partyId>
      </legalEntity>
      <counterParty>
        <partyId>
          <id type="sdsCounterpartyId">40168443</id>
          <alternateId type="dtccParticipantId">00004T83</alternateId>
        </partyId>
      </counterParty>
      <tradeDate>2013-09-13</tradeDate>
      <tradeTime>00:26:10</tradeTime>
      <mifidDateTime>2013-09-13T04:26:10Z</mifidDateTime>
      <foTradeState>ACTIVE</foTradeState>
      <traderId>
        <id type="adSamAccountName">sobelmic</id>
      </traderId>
      <tradingDesk>
        <id type="frontarenaTradingDesk">HY</id>
      </tradingDesk>
      <tradeLocation>
        <id type="fpmlBusinessCenter">USNY</id>
      </tradeLocation>
      <book>
        <id type="sdapsBook">1225</id>
      </book>
      <medium>
        <id type="bcTradingMedium">DMX</id>
      </medium>
      <ecn>
        <ecnName>
          <id type="bcEcnName">Off-Facility</id>
        </ecnName>
      </ecn>
      <clearing>
        <clearingStatus>
          <id type="bcClearingStatus">Pending</id>
        </clearingStatus>
        <ccpName>
          <id type="bcCcpName">ICE-US</id>
        </ccpName>
        <mandatoryClearing>
          <mandatoryClearingJurisdiction>CFTC</mandatoryClearingJurisdiction>
          <mandatoryClearingJurisdiction>ESMA</mandatoryClearingJurisdiction>
          <mandatoryClearingJurisdiction>JFSA</mandatoryClearingJurisdiction>
        </mandatoryClearing>
      </clearing>
      <settlementInstructionType>
        <id type="bcSettlementInstructionType">Standard</id>
      </settlementInstructionType>
    </tradeHeader>
    <productType>
      <mainType>
        <id type="bcProductMainType">CdsIndexSwap</id>
      </mainType>
      <subType>
        <id type="bcProductSubType">IndexCdx</id>
      </subType>
    </productType>
    <creditDefaultSwap>
      <generalTerms>
        <buyOrSell>Sell</buyOrSell>
        <effectiveDate>
          <unadjustedDate>2012-09-20</unadjustedDate>
          <dateAdjustments>
            <businessDayConvention>Following</businessDayConvention>
            <businessCenters>
              <businessCenter>
                <id type="fpmlBusinessCenter">GBLO</id>
              </businessCenter>
              <businessCenter>
                <id type="fpmlBusinessCenter">USNY</id>
              </businessCenter>
            </businessCenters>
          </dateAdjustments>
        </effectiveDate>
        <scheduledTerminationDate>
          <unadjustedDate>2017-12-20</unadjustedDate>
          <dateAdjustments>
            <businessDayConvention>Following</businessDayConvention>
            <businessCenters>
              <businessCenter>
                <id type="fpmlBusinessCenter">GBLO</id>
              </businessCenter>
              <businessCenter>
                <id type="fpmlBusinessCenter">USNY</id>
              </businessCenter>
            </businessCenters>
          </dateAdjustments>
        </scheduledTerminationDate>
        <indexReferenceInformation>
          <referenceEntity>
            <entityId>
              <id type="red">2I65BYCV5</id>
              <alternateId type="ESMI">0</alternateId>
              <alternateId type="SDAPS">0</alternateId>
              <alternateId type="SDS">41205899</alternateId>
            </entityId>
            <entityName>CDX.NA.IG.19</entityName>
            <recoveryRate>0.4</recoveryRate>
          </referenceEntity>
          <initialFactor>1.0</initialFactor>
          <indexAnnexDate>2012-09-20</indexAnnexDate>
        </indexReferenceInformation>
      </generalTerms>
      <feeLeg>
        <periodicPayment>
          <payOrReceive>Receive</payOrReceive>
          <paymentFrequency>
            <periodMultiplier>3</periodMultiplier>
            <period>M</period>
          </paymentFrequency>
          <firstPeriodStartDate>2013-06-20</firstPeriodStartDate>
          <firstPaymentDate>2013-09-20</firstPaymentDate>
          <rollConvention>20</rollConvention>
          <fixedAmountCalculation>
            <fixedRate>0.01</fixedRate>
            <marketFixedRate>
              <fixedRate>0.000050</fixedRate>
              <rateType>SPREAD</rateType>
            </marketFixedRate>
            <dayCountFraction>
              <id type="bcDayCountFraction">Act/360</id>
            </dayCountFraction>
          </fixedAmountCalculation>
          <initialNotional>
            <currency>
              <id type="grdCurrency">USD</id>
            </currency>
            <amount>10000000.00</amount>
          </initialNotional>
          <payInArrears>true</payInArrears>
        </periodicPayment>
      </feeLeg>
      <protectionTerms>
        <calculationAmount>
          <currency>
            <id type="grdCurrency">USD</id>
          </currency>
          <amount>10000000</amount>
        </calculationAmount>
        <creditEvents>
          <failureToPay>
            <paymentRequirement>
              <currency>
                <id type="grdCurrency">USD</id>
              </currency>
              <amount>1000000</amount>
            </paymentRequirement>
          </failureToPay>
          <restructuring>
            <restructuringType>
              <id type="fpmlRestructuringType">NORE</id>
            </restructuringType>
          </restructuring>
          <creditEventNotice>
            <notifyingParty>
              <buyer>
                <partyId>
                  <id type="sdsCounterpartyId">40168443</id>
                </partyId>
              </buyer>
              <seller>
                <partyId>
                  <id type="sdsCounterpartyId">40001104</id>
                </partyId>
              </seller>
            </notifyingParty>
          </creditEventNotice>
        </creditEvents>
        <obligations>
          <category>BorrowedMoney</category>
        </obligations>
        <contractRecovery>
          <recoveryRate>0.4</recoveryRate>
          <recoveryType>ParMinusRecov</recoveryType>
        </contractRecovery>
      </protectionTerms>
      <settlementType />
      <cashSettlementTerms />
    </creditDefaultSwap>
    <payment>
      <payOrReceive>PAY</payOrReceive>
      <otherParty>
        <partyId>
          <id type="sdsCounterpartyId">40168443</id>
        </partyId>
      </otherParty>
      <paymentAmount>
        <currency>
          <id type="grdCurrency">USD</id>
        </currency>
        <amount>444588.88</amount>
      </paymentAmount>
      <adjustedValueDate>2013-09-18</adjustedValueDate>
      <paymentType>
        <id type="bcPaymentType">Fee</id>
      </paymentType>
    </payment>
    <calculationAgent>
      <calculationAgentParty>Barclays</calculationAgentParty>
    </calculationAgent>
    <calculationAgentBusinessCenter>
      <id type="fpmlBusinessCenter">USNY</id>
    </calculationAgentBusinessCenter>
    <documentation>
      <masterConfirmation>
        <masterConfirmationType>
          <id scheme="http://uri.barcapint.com/schemes/types/BarCapML/masterConfirmationType" type="fpmlMasterConfirmationType">2003CreditIndex</id>
        </masterConfirmationType>
      </masterConfirmation>
      <contractualTermsSupplement>
        <type>
          <id scheme="http://uri.barcapint.com/schemes/types/BarCapML/contractualSupplement" type="fpmlContractualSupplement">CDX</id>
        </type>
      </contractualTermsSupplement>
      <contractualMatrix>
        <matrixType>
          <id type="fpmlMatrixType">SettlementMatrix</id>
        </matrixType>
        <matrixTerm>
          <id scheme="http://uri.barcapint.com/schemes/types/BarCapML/creditMatrixTransactionType" type="fpmlCreditMatrixTransactionType" />
        </matrixTerm>
      </contractualMatrix>
    </documentation>
  </trade>
  <tactical>
    <salesCreditTrade>false</salesCreditTrade>
    <reporting>
      <reportingObligation>
        <reportingJurisdiction>CFTC</reportingJurisdiction>
        <reportingParty>Barcap</reportingParty>
      </reportingObligation>
      <confirmationReportingType>Electronic</confirmationReportingType>
      <upi>Credit:Index:CDX:CDXIG</upi>
      <doNotReportRt>false</doNotReportRt>
      <doNotReportPet>true</doNotReportPet>
      <blockSpread>0.5</blockSpread>
    </reporting>
  </tactical>
</BCTrade>'
declare @t table (myDoc xml)

insert @t values(@myDoc)

select myDoc.query('declare namespace bc="http://uri.barcapint.com/BarCapML"; 
					/bc:BCTrade/bc:trade/bc:tradeHeader/bc:clearing/bc:mandatoryClearing/bc:mandatoryClearingJurisdiction') as x
from @t


select 
T.C.value('.', 'varchar(20)') as mandatoryClearingJurisdiction
from @t cross apply
myDoc.nodes('declare namespace bc="http://uri.barcapint.com/BarCapML"; 
					/bc:BCTrade/bc:trade/bc:tradeHeader/bc:clearing/bc:mandatoryClearing/bc:mandatoryClearingJurisdiction') as T(C)


select substring(cast(@myDoc as nvarchar(max)), 1, 10)
				
;with xmlnamespaces('http://uri.barcapint.com/BarCapML' as "bc")
				SELECT T.C.value('.', 'varchar(20)') as mandatoryClearingJurisdiction
				FROM @myDoc.nodes('(/bc:BCTrade/bc:trade/bc:tradeHeader/bc:clearing/bc:mandatoryClearing/bc:mandatoryClearingJurisdiction)') as T(C)


-- produce all elements from xml as a semi-column separated list 				
  select stuff((
	select ';'+ T.C.value('.', 'varchar(20)') 
	from @t as a cross apply
		myDoc.nodes('declare namespace bc="http://uri.barcapint.com/BarCapML"; 
					/bc:BCTrade/bc:trade/bc:tradeHeader/bc:clearing/bc:mandatoryClearing/bc:mandatoryClearingJurisdiction') as T(C)
	where a.rowNum = b.rowNum
	for xml path('')
	)
	,1,1,'')
	from @t as b
	group by b.rowNum
