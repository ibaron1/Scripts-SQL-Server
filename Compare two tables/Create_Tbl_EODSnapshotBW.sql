if OBJECT_ID('srf_main.EODSnapshotBW') is not null
  drop table srf_main.EODSnapshotBW
go
CREATE TABLE [srf_main].[EODSnapshotBW](
	[comment] [varchar](100) NULL,
	[version] [varchar](100) NULL,
	[messageType] [varchar](100) NULL,
	[action] [varchar](100) NULL,
	[transactionType] [varchar](100) NULL,
	[usiPrefix] [varchar](100) NULL,
	[usiValue] [varchar](100) NULL,
	[primaryAssetClass] [varchar](100) NULL,
	[secondaryAssetClass] [varchar](100) NULL,
	[eventIDParty1] [varchar](100) NULL,
	[eventIDParty2] [varchar](100) NULL,
	[dataSubmitterLEIprefix] [varchar](100) NULL,
	[dataSubmitterLEIvalue] [varchar](100) NULL,
	[submittedForPrefix] [varchar](100) NULL,
	[submittedForValue] [varchar](100) NULL,
	[tradeParty1Role] [varchar](100) NULL,
	[tradeParty1Prefix] [varchar](100) NULL,
	[tradeParty1value] [varchar](100) NULL,
	[tradeParty2Role] [varchar](100) NULL,
	[tradeParty2Prefix] [varchar](100) NULL,
	[tradeParty2value] [varchar](100) NULL,
	[productIDprefix] [varchar](100) NULL,
	[productIDvalue] [varchar](100) NULL,
	[executionTimestamp] [varchar](100) NULL,
	[executionVenuePrefix] [varchar](100) NULL,
	[executionVenue] [varchar](100) NULL,
	[brokerIdParty1prefix] [varchar](100) NULL,
	[brokerIdParty1value] [varchar](100) NULL,
	[brokerIdParty2prefix] [varchar](100) NULL,
	[brokerIdParty2value] [varchar](100) NULL,
	[clearingDCOprefix] [varchar](100) NULL,
	[clearingDCOvalue] [varchar](100) NULL,
	[clearingExceptionPartyprefix] [varchar](100) NULL,
	[clearingExceptionPartyValue] [varchar](100) NULL,
	[effectiveDate] [varchar](100) NULL,
	[scheduledTerminationDate] [varchar](100) NULL,
	[priceNotationPriceType1] [varchar](100) NULL,
	[priceNotationPrice1] [varchar](100) NULL,
	[additionalPriceNotationPriceType] [varchar](100) NULL,
	[additionalPriceNotationPrice] [varchar](100) NULL,
	[underlyingAsset] [varchar](100) NULL,
	[referenceEntity] [varchar](100) NULL,
	[notionalAmount1] [varchar](100) NULL,
	[notionalCurrencyUnits1] [varchar](100) NULL,
	[fixedRate] [varchar](100) NULL,
	[paymentFrequencyPeriod1] [varchar](100) NULL,
	[paymentFrequencyPeriodMultiplier1] [varchar](100) NULL,
	[nonstandardFlag] [varchar](100) NULL,
	[offMarketFlag] [varchar](100) NULL,
	[embeddedOptionOnSwap] [varchar](100) NULL,
	[optionStrikePrice] [varchar](100) NULL,
	[optionType] [varchar](100) NULL,
	[optionstyle] [varchar](100) NULL,
	[optioPpremiumCurrency] [varchar](100) NULL,
	[optionPremium] [varchar](100) NULL,
	[optionLockoutDate] [varchar](100) NULL,
	[optionExpiration] [varchar](100) NULL,
	[buyerLEIprefix] [varchar](100) NULL,
	[buyerLEIvalue] [varchar](100) NULL,
	[mandatoryClearingIndicator] [varchar](100) NULL,
	[collateralized] [varchar](100) NULL,
	[settlementCurrency] [varchar](100) NULL,
	[reportingJurisdiction] [varchar](100) NOT NULL,
	[party1ReportingObligation] [varchar](100) NULL,
	[party2ReportingObligation] [varchar](100) NULL,
	[tradeParty1TransactionId] [varchar](100) NULL,
	[tradeParty2TransactionId] [varchar](100) NULL,
	[asOfDateTime] [varchar](100) NULL,
	[valuationDate] [varchar](100) NULL,
	[mTMValue] [varchar](100) NULL,
	[mTMCurrency] [varchar](100) NULL,
	[valuationSource] [varchar](100) NULL,
	[valuationReferenceModel] [varchar](100) NULL,
	[priorUSIprefix] [varchar](100) NULL,
	[priorUSIvalue] [varchar](100) NULL,
	[executionAgentParty1Prefix] [varchar](100) NULL,
	[executionAgentParty1Value] [varchar](100) NULL,
	[executionAgentParty2Prefix] [varchar](100) NULL,
	[executionAgentParty2Value] [varchar](100) NULL,
	[clearingBrokerParty1Prefix] [varchar](100) NULL,
	[clearingBrokerParty1Value] [varchar](100) NULL,
	[clearingBrokerParty2Prefix] [varchar](100) NULL,
	[clearingBrokerParty2Value] [varchar](100) NULL,
	[clearingBrokerParty1Id_ccpleg] [varchar](100) NULL,
	[clearingBrokerParty2Id_ccpleg] [varchar](100) NULL,
	[clearingBrokerParty1Id_clientleg] [varchar](100) NULL,
	[clearingBrokerParty2Id_clientleg] [varchar](100) NULL,
	[clearedProductID] [varchar](100) NULL,
	[brokerLocationParty1] [varchar](100) NULL,
	[brokerLocationParty2] [varchar](100) NULL,
	[deskLocationParty1] [varchar](100) NULL,
	[deskLocationParty2] [varchar](100) NULL,
	[traderLocationParty1] [varchar](100) NULL,
	[traderLocationParty2] [varchar](100) NULL,
	[salesLocationParty1] [varchar](100) NULL,
	[salesLocationParty2] [varchar](100) NULL,
	[settlementAgentParty1prefix] [varchar](100) NULL,
	[settlementAgentParty1value] [varchar](100) NULL,
	[settlementAgentParty2prefix] [varchar](100) NULL,
	[settlementAgentParty2value] [varchar](100) NULL,
	[allocationIndicator] [varchar](100) NULL,
	[voluntarySubmissionOnTradeParty1] [varchar](100) NULL,
	[voluntarySubmissionOnTradeParty2] [varchar](100) NULL,
	[additionalRepository1Prefix] [varchar](100) NULL,
	[additionalRepository1LEI] [varchar](100) NULL,
	[additionalRepository1tradeId] [varchar](100) NULL,
	[additionalRepository2Prefix] [varchar](100) NULL,
	[additionalRepository2LEI] [varchar](100) NULL,
	[additionalRepository2tradeId] [varchar](100) NULL,
	[additionalRepository3Prefix] [varchar](100) NULL,
	[additionalRepository3LEI] [varchar](100) NULL,
	[additionalRepository3tradeId] [varchar](100) NULL,
	[electronicConfirmation] [varchar](100) NULL,
	[eventProcessingID] [varchar](100) NULL,
	[dTCCTRI] [varchar](100) NULL,
	[masterDocumentTransactionType] [varchar](100) NULL,
	[masterDocumentDate] [varchar](100) NULL,
	[documentationType] [varchar](100) NULL,
	[masterAgreementType] [varchar](100) NULL,
	[masterAgreementDate] [varchar](100) NULL,
	[tradeDate] [varchar](100) NULL,
	[firstPaymentDate] [varchar](100) NULL,
	[restructuringEvents] [varchar](100) NULL,
	[additionalTerms] [varchar](100) NULL,
	[independentAmountPaymentPercent] [varchar](100) NULL,
	[independentAmountPayer] [varchar](100) NULL,
	[independentAmountReceiver] [varchar](100) NULL,
	[singlePaymentAmount] [varchar](100) NULL,
	[singlePaymentCurrency] [varchar](100) NULL,
	[singlePaymentDate] [varchar](100) NULL,
	[calculationAgentBusinessCenter] [varchar](100) NULL,
	[excludedDeliverables] [varchar](100) NULL,
	[initialPaymentAmount] [varchar](100) NULL,
	[initialPaymentCurrency] [varchar](100) NULL,
	[singleInitialPaymentAmountPayer] [varchar](100) NULL,
	[singleInitialPaymentAmountReceiver] [varchar](100) NULL,
	[annexDate] [varchar](100) NULL,
	[postTradeTransactionDate] [varchar](100) NULL,
	[postTradeEffectiveDate] [varchar](100) NULL,
	[affectedNotionalAmount] [varchar](100) NULL,
	[affectedNotionalCurrency] [varchar](100) NULL,
	[outstandingNotionalAmount] [varchar](100) NULL,
	[outstandingNotionalCurrency] [varchar](100) NULL,
	[postTradePaymentAmount] [varchar](100) NULL,
	[postTradePaymentCurrency] [varchar](100) NULL,
	[postTradePaymentDate] [varchar](100) NULL,
	[postTradePaymentPayer] [varchar](100) NULL,
	[postTradePaymentReceiver] [varchar](100) NULL,
	[fullFirstCalculationPeriodApplicable] [varchar](100) NULL,
	[exitMessage] [varchar](100) NULL,
	[exitAdditionalMessage] [varchar](100) NULL,
	[calculationAgent] [varchar](100) NULL,
	[additionalMatrixProvisions] [varchar](100) NULL,
	[attachmentPoint] [varchar](100) NULL,
	[exhaustionPoint] [varchar](100) NULL,
	[modifiedEquityDelivery] [varchar](100) NULL,
	[settledEntityMatrixSource] [varchar](100) NULL,
	[settledEntityMatrixDate] [varchar](100) NULL,
	[firstPaymentPeriodAccrualStartDate] [varchar](100) NULL,
	[businessDay] [varchar](100) NULL,
	[referencePolicyApplicable] [varchar](100) NULL,
	[referencePrice] [varchar](100) NULL,
	[fixedAmountPaymentDelayApplicable] [varchar](100) NULL,
	[stepUpProvisionsApplicable] [varchar](100) NULL,
	[wACCapInterestProvisionApplicable] [varchar](100) NULL,
	[interestShortfallCapApplicable] [varchar](100) NULL,
	[interestShortfallCapBasis] [varchar](100) NULL,
	[interestShortfallCompoundingApplicable] [varchar](100) NULL,
	[rateSource] [varchar](100) NULL,
	[optionalEarlyTerminationApplicable] [varchar](100) NULL,
	[designatedMaturity] [varchar](100) NULL,
	[dateOfCreditAgreement] [varchar](100) NULL,
	[facilityType] [varchar](100) NULL,
	[bloombergID] [varchar](100) NULL,
	[nameofBorrower] [varchar](100) NULL,
	[insurer] [varchar](100) NULL,
	[legalFinalMaturityDate] [varchar](100) NULL,
	[designatedPriority] [varchar](100) NULL,
	[originalPrincipalAmount] [varchar](100) NULL,
	[initialFactor] [varchar](100) NULL,
	[securedListApplicable] [varchar](100) NULL,
	[cashSettlementOnly] [varchar](100) NULL,
	[deliveryOfCommitments] [varchar](100) NULL,
	[continuity] [varchar](100) NULL,
	[underlyingFixedRatePayerBuyer] [varchar](100) NULL,
	[underlyingFloatRatePayerSeller] [varchar](100) NULL,
	[quotingStyle] [varchar](100) NULL,
	[swaptionSettlementStyle] [varchar](100) NULL,
	[underlyingMasterDocumentTransactionType] [varchar](100) NULL,
	[underlyingMasterDocumentDate] [varchar](100) NULL,
	[exerciseEventType] [varchar](100) NULL,
	[recoveryPrice] [varchar](100) NULL,
	[fixedSettlement] [varchar](100) NULL,
	[referenceObligation] [varchar](100) NULL,
	[referenceEntityID] [varchar](100) NULL,
	[dCOTradeIdentifiers] [varchar](100) NULL,
	[tradeParty1USPersonIndicator] [varchar](100) NULL,
	[tradeParty1CFTCFinancialEntityStatus] [varchar](100) NULL,
	[tradeParty2USPersonIndicator] [varchar](100) NULL,
	[tradeParty2CFTCFinancialEntityStatus] [varchar](100) NULL,
	[largeSizeTrade] [varchar](100) NULL,
	[dataSubmitterMessageID] [varchar](100) NULL,
	[underlyingAssetIDType] [varchar](100) NULL,
	[basketOpenUnits] [varchar](100) NULL,
	[basketWeightPercentage] [varchar](100) NULL,
	[cCPForUnderlyingSwap] [varchar](100) NULL,
	[lifecycleEvent] [varchar](100) NULL,
	[reportingDelegationModel] [varchar](100) NULL,
	[beneficiaryIDParty1Prefix] [varchar](100) NULL,
	[beneficiaryIDParty1Value] [varchar](100) NULL,
	[beneficiaryIDParty2Prefix] [varchar](100) NULL,
	[beneficiaryIDParty2Value] [varchar](100) NULL,
	[tradeParty1Domicile] [varchar](100) NULL,
	[tradeParty2Domicile] [varchar](100) NULL,
	[tradeParty1CorporateSector] [varchar](100) NULL,
	[tradeParty2CorporateSector] [varchar](100) NULL,
	[directlylinkedtocommercialactivityortreasuryfinancing] [varchar](100) NULL,
	[directlylinkedtocommercialactivityortreasuryfinancingParty2] [varchar](100) NULL,
	[clearingThreshold] [varchar](100) NULL,
	[clearingThresholdParty2] [varchar](100) NULL,
	[clearingTimestamp] [varchar](100) NULL,
	[compressedTrade] [varchar](100) NULL,
	[collateralizedParty2] [varchar](100) NULL,
	[valuationDatetimeParty2] [varchar](100) NULL,
	[mTMValueParty2] [varchar](100) NULL,
	[mTMCurrencyParty2] [varchar](100) NULL,
	[collateralportfoliocode] [varchar](100) NULL,
	[collateralportfoliocodeParty2] [varchar](100) NULL,
	[valueofthecollateral] [varchar](100) NULL,
	[valueofthecollateralParty2] [varchar](100) NULL,
	[currencyofthecollateralvalue] [varchar](100) NULL,
	[currencyofthecollateralvalueParty2] [varchar](100) NULL,
	[valuationTypeParty1] [varchar](100) NULL,
	[valuationTypeParty2] [varchar](100) NULL,
	[intragroup] [varchar](100) NULL,
	[tradeParty1NonFinancialEntityJurisdiction] [varchar](100) NULL,
	[tradeParty2NonFinancialEntityJurisdiction] [varchar](100) NULL,
	[clearingStatus] [varchar](100) NULL,
	[tradeParty1BranchLocation] [varchar](100) NULL,
	[tradeParty2BranchLocation] [varchar](100) NULL,
	[uTIPrefix] [varchar](100) NULL,
	[uTI] [varchar](100) NULL,
	[tradingcapacity] [varchar](100) NULL,
	[tradingcapacityParty2] [varchar](100) NULL,
	[mTMValueCCP] [varchar](100) NULL,
	[mTMCurrencyCCP] [varchar](100) NULL,
	[valuationTypeCCP] [varchar](100) NULL,
	[valuationDatetimeCCP] [varchar](100) NULL,
	[confirmationDateTime] [varchar](100) NULL,
	[priorUTIPrefix] [varchar](100) NULL,
	[priorUTI] [varchar](100) NULL,
	[tradeParty1FinancialEntityJurisdiction] [varchar](100) NULL,
	[tradeParty2FinancialEntityJurisdiction] [varchar](100) NULL,
	[partyRegion] [varchar](100) NULL,
	[counterpartyRegion] [varchar](100) NULL,
	[masterAgreementVersion] [varchar](100) NULL,
	[cobDate] [date] NOT NULL,
	[publisher] [varchar](100) NOT NULL
)

create unique index i on srf_main.EODSnapshotBW(cobDate,publisher,reportingJurisdiction,tradeParty1TransactionId,tradeParty2TransactionId)

go

