CREATE UNIQUE CLUSTERED INDEX pKey
    ON dbo.A(childParty)

CREATE UNIQUE CLUSTERED INDEX accountIDIdx
    ON dbo.AccountActivity(accountID)

CREATE UNIQUE CLUSTERED INDEX AKBDBrokerCodeAcct
    ON dbo.BDBrokerCodeAcct(accountNumber,accountSystemRN,brokerID,brokerCodeIssuer,businessDefinitionID,brokerRelationshipType)

CREATE UNIQUE CLUSTERED INDEX AKBrokerAccount
    ON dbo.BrokerAccount(accountNumber,accountSystemRN,brokerID)

CREATE UNIQUE CLUSTERED INDEX CrossEntityAcctsIDX
    ON dbo.CrossEntityAccounts(accountNumber,streamID,contraAccountNumber,contraStreamID)

CREATE UNIQUE CLUSTERED INDEX i1
    ON dbo.dba_testreplication(int_col)

CREATE CLUSTERED INDEX C_ResourcesToResourceGroups
    ON dbo.E3ResourcesToResourceGroups(resourceType,resourceAttr1,resourceGroupName)

CREATE UNIQUE CLUSTERED INDEX rs_lastcommit_idx
    ON dbo.rs_lastcommit(origin)

CREATE UNIQUE CLUSTERED INDEX rs_threads_idx
    ON dbo.rs_threads(id)

CREATE UNIQUE CLUSTERED INDEX TradingNameAudit_IDX
    ON dbo.TradingNameAudit(TrdNameAuditID)

CREATE INDEX acctID
    ON dbo.AccountActivity(acctID,accountID)

CREATE INDEX acctID
    ON dbo.AccountCorrespondentProduct(acctID,accountID)

CREATE INDEX acctID
    ON dbo.AccountCreditData(acctID,accountID)

CREATE INDEX acctID
    ON dbo.AccountFuturesProduct(acctID,accountID)

CREATE INDEX acctID
    ON dbo.AccountFXProduct(acctID,accountID)

CREATE INDEX accountNumber
    ON dbo.AccountIDTAPSAccount(accountNumber,accountSystem,accountID)

CREATE INDEX AccountInitiationAcctID_IDX
    ON dbo.AccountInitiation(accountID)

CREATE INDEX acctID
    ON dbo.AccountIRAProduct(acctID,accountID)

CREATE INDEX acctID
    ON dbo.AccountOptionsProduct(acctID,accountID)

CREATE INDEX acctID
    ON dbo.AccountPortfolioSweepProduct(acctID,accountID)

CREATE INDEX acctID
    ON dbo.AccountProductData(acctID,accountID)

CREATE INDEX AQBQP_AccQIQa
    ON dbo.AccountQIBQP(accountIDFK,qibIndRN,qualifierExpTS)

CREATE INDEX acctID
    ON dbo.AccountRegionalData(acctID,accountID)

CREATE INDEX acctID
    ON dbo.AccountTokyoProduct(acctID,accountID)

CREATE UNIQUE INDEX AKAcctBulkKSENumber
    ON dbo.AcctBulkKSENumber(bulkKSENumber,accountID,orderPlacerPartyID,principalPartyID)

CREATE INDEX AcctGroupCoverageGroup_CovID
    ON dbo.AcctGroupCoverageGroup(coverageGroupIDFK)

CREATE INDEX AcctGroupTAPSAcct_acctID
    ON dbo.AcctGroupTAPSAcct(accountIDFK)

CREATE INDEX acctNumSys
    ON dbo.BinaryAccountRelationship(accountNumber,accountSystemRN)

CREATE INDEX BDD_AssBLRBLOTTSLO
    ON dbo.BusinessDefinitionDetail(businessDefinitionIDFK,productTypeCode,businessLineRegionCode,businessLineOfficeCode,transactionTypeCode,settlementLocationCode)

CREATE INDEX acctID
    ON dbo.ClearingBrokerReference(acctID,accountID)

CREATE INDEX acctID
    ON dbo.DIAlternateDeliveryCode(acctID,accountID)

CREATE INDEX acctID
    ON dbo.DIDTC(acctID,accountID)

CREATE INDEX acctID
    ON dbo.DIGovernment(acctID,accountID)

CREATE INDEX acctID
    ON dbo.DIPhysical(acctID,accountID)

CREATE INDEX JapanTradedProduct_i1
    ON dbo.JapanTradedProduct(accountIDFK)

CREATE INDEX employeeNumIDX
    ON dbo.MSPerson(employeeNumber)

CREATE UNIQUE INDEX IDPartyExchangeListing
    ON dbo.PartyExchangeListing(partyIDFK,mdExch,issueType,exchangeDescription,ISOcountryCode,marketSegment)

CREATE INDEX PQIB_PidPasQIQ
    ON dbo.PartyQIBQP(partyIDFK,partyAs,qibIndRN,qualifierExpTS)

CREATE INDEX acctid_IDX
    ON dbo.PCSCustomerProfile(accountID)

CREATE INDEX rrIDOnlyIdx
    ON dbo.RRParticipant(rrIDFK)

CREATE UNIQUE INDEX nc1
    ON dbo.t1(name,city)

CREATE INDEX accountID
    ON dbo.TAPSCustomerDesiStreetAccount(accountID)

CREATE INDEX accountNumfullNameIDX
    ON dbo.TAPSGeneralAddress(accountNumber,accountSystemRN,nameAddressSeqNum,fullName1,fullName2)

CREATE INDEX lastUpdateTS
    ON dbo.TAPSGeneralAddressInactive(lastUpdateTS)

CREATE INDEX TAPSGAT_AcctIDType
    ON dbo.TAPSGeneralAddressType(accountID,nameAddressTypeFK)

CREATE INDEX TAPSGATI_AccNumSysType
    ON dbo.TAPSGeneralAddressTypeInactive(accountNumberFK,accountSystemRN,nameAddressTypeFK)

CREATE INDEX TradingNameGroupDesi_TNID
    ON dbo.TradingNameGroupDesi(tradingNameIDFK)

CREATE INDEX AcctIDTNLAccount
    ON dbo.TradingNameLocationAccount(accountIDFK)

CREATE UNIQUE INDEX PartyIDTradingNameParty
    ON dbo.TradingNameParty(partyIDFK)

CREATE INDEX acctID
    ON dbo.AccountIDTAPSAccount(acctID,accountID)

CREATE INDEX AccountParticipant_acctIDX
    ON dbo.AccountParticipant(accountIDFK,partyRoleRN)

CREATE INDEX AccountProduct_genPrdIDX
    ON dbo.AccountProduct(generalProductRN)

CREATE INDEX PKAttributeValidation
    ON dbo.AttributeValidation(primaryKey)

CREATE INDEX asscAcctNumSys
    ON dbo.BinaryAccountRelationship(associatedAccountNumberRN,accountSystemRN)

CREATE INDEX BDA_AccIDBusDef
    ON dbo.BusinessDefAccount(accountIDFK,businessDefinitionIDFK)

CREATE INDEX BDIDdivisionIDX
    ON dbo.BusinessDefinition(businessDefinitionID,divisionCode)

CREATE INDEX BDIDCodeIDX
    ON dbo.BusinessDefinitionDetail(businessDefinitionIDFK,businessLineCode,businessLineRegionCode,businessLineOfficeCode,productTypeCode,underlyingProductTypeCode,countryOfIssueCode,countryOfIssuerCode)

CREATE INDEX XIF1BusinessDefinitionTypeAttr
    ON dbo.BusinessDefinitionTypeAttr(busDefTypeRN)

CREATE UNIQUE INDEX AKClearingBrokerReference
    ON dbo.ClearingBrokerReference(accountID,giveUpReference,clearingBrokerRefID,exchangeRN)

CREATE INDEX CoverageGroupRole_IDFK_IDX
    ON dbo.CoverageGroupRole(coverageGroupIDFK,coverageGroupRoleCode,coverageGroupParentRoleCode)

CREATE UNIQUE INDEX DarwinAcct_numSysIDX
    ON dbo.DarwinAccount(accountNumber,accountSystemRN)

CREATE INDEX accountID_01
    ON dbo.FundAccount(accountID)

CREATE INDEX GeoLoc_parentIDX
    ON dbo.GeoLocation(geoParentIDFK)

CREATE INDEX XIF1GroupDesiCoverage
    ON dbo.GroupDesiCoverage(coverageGroupID)

CREATE INDEX accIDKSEAccount
    ON dbo.KoreanStockExchangeAccount(accountID)

CREATE INDEX Membership_exchMembIDX
    ON dbo.Membership(exchangeMembershipTypeRN)

CREATE CLUSTERED INDEX partyName
    ON dbo.Party(partyName,partyID)

CREATE INDEX AtIDPID
    ON dbo.PartyAttribute(attrName,attrValue,partyIDFK)

CREATE INDEX PartyExchange_partyIDX
    ON dbo.PartyExchange(partyIDFK)

CREATE INDEX PartyHierarchy_childIDX
    ON dbo.PartyHierarchy(childPartyIDFK)

CREATE INDEX creationTS
    ON dbo.PartySite(creationTS)

CREATE INDEX XgeoLocIDPostalAddr
    ON dbo.PostalAddress(geoLocationIDFK)

CREATE INDEX acctDunsNumIDX
    ON dbo.TAPSAccount(accountDunsNumber,accountNumber,accountSystemRN)

CREATE INDEX AccountIndicatorIdx
    ON dbo.TAPSCustomerDesiStreetAccount(accountNumber,accountSystemRN,cashIndicator,marginIndicator,codIndicator)

CREATE INDEX acctIDfullName1
    ON dbo.TAPSGeneralAddress(accountID,fullName1,fullName2,mainAddressInd)

CREATE INDEX TAPSGAInactiveAcctID_IDX
    ON dbo.TAPSGeneralAddressInactive(accountID)

CREATE INDEX TAPSGAT_AcctNumType
    ON dbo.TAPSGeneralAddressType(accountNumberFK,accountSystemRN,nameAddressTypeFK,nameAddressSeqNumFK)

CREATE INDEX lastUpdateTS
    ON dbo.TAPSGeneralAddressTypeInactive(lastUpdateTS)

CREATE INDEX userlogin_idx
    ON dbo.TIDUser(userLoginName)

CREATE INDEX primAcctSecGrCode_idx
    ON dbo.TIDWorkgroup(primaryAcctSecGrCode)

CREATE INDEX TNDIDTNAR
    ON dbo.TNDAccount(tradingNameDefinitionIDFK,TNDAccountRoleRN)

CREATE INDEX TNDIDTNIN
    ON dbo.TNDIdentifier(TNDIdentifierID,tradingNameIdentifierName)

CREATE INDEX TNIDTNDIDTITM
    ON dbo.TNDIdentifierDivision(tradingNameIDFK,TNDIdentifierIDFK,TNDInterestTypeRN,mandatoryIndicator)

CREATE INDEX TNDID
    ON dbo.TNDInterest(tradingNameDefinitionIDFK)

CREATE INDEX BS
    ON dbo.TNLBDBookingSelection(tradingNameLocationID,businessDefinitionID,preferredFlag,bookingSelectionID)

CREATE INDEX BDID_nonuniqIdx
    ON dbo.TNLBDOrderCapacity(businessDefinitionID)

CREATE UNIQUE INDEX XAK1TNLClientIdentifier
    ON dbo.TNLClientIdentifier(tradingNameLocationIDFK,clientIdentifierName,clientIdentifierValue)

CREATE UNIQUE INDEX TNLClientIdentifierCodeAK
    ON dbo.TNLClientIdentifierCode(tradingNameLocationID,clientIdentifierTypeCode,clientIdentifierCode,businessProcessCode,bookingSelectionID,businessDefinitionID)

CREATE INDEX TN_prntIDX
    ON dbo.TradingName(parentTradingNameFK)

CREATE INDEX operationTS
    ON dbo.TradingNameAudit(operationTS)

CREATE INDEX TradingNameDefinition_i1
    ON dbo.TradingNameDefinition(tradingNameIDFK,tradingNameDefinitionID)

CREATE INDEX TNDIDTNDI
    ON dbo.TradingNameDefinitionDetail(tradingNameDefinitionIDFK,TNDIdentifierIDFK)

CREATE INDEX TNLoc_tnlocIDX
    ON dbo.TradingNameLocAlias(tradingNameLocationIDFK)

CREATE INDEX lastUpdateTS
    ON dbo.TradingNameLocation(lastUpdateTS)

CREATE INDEX XIF1TradingNameLocBusDef
    ON dbo.TradingNameLocBusDef(businessDefinitionID)

CREATE INDEX AccountParticipant_partyIDX
    ON dbo.AccountParticipant(partyIDFK)

CREATE INDEX acctID
    ON dbo.BinaryAccountRelationship(acctID,accountID)

CREATE INDEX BusDefAcct_accountidIDX
    ON dbo.BusinessDefAccount(accountIDFK)

CREATE UNIQUE INDEX BusDef_descriptionIDX
    ON dbo.BusinessDefinition(description)

CREATE INDEX CodeIDX
    ON dbo.BusinessDefinitionDetail(businessLineCode,businessLineRegionCode,businessLineOfficeCode,productTypeCode,underlyingProductTypeCode,countryOfIssueCode,countryOfIssuerCode)

CREATE INDEX CoverageGroupRole_IDFKRole_IDX
    ON dbo.CoverageGroupRole(coverageGroupIDFK,coverageGroupRoleCode,coverageGroupRoleRN,coverageGroupParentRoleRN)

CREATE INDEX FA_AccNumNameSh
    ON dbo.FundAccount(accountID,clientIdentifierTypeCode,fundShortName,fundName)

CREATE INDEX Membership_partyExchIDX
    ON dbo.Membership(partyIDFK,exchangeRNFK)

CREATE INDEX partyIDtradingNameID_IDX
    ON dbo.Party(partyID,tradingNameIDFK)

CREATE INDEX AtIDPIDRN
    ON dbo.PartyAttribute(attrNameRN,attrValueRN,partyIDFK)

CREATE INDEX PartyHierarchy_parentIDX
    ON dbo.PartyHierarchy(parentPartyIDFK)

CREATE INDEX lastUpdateTS
    ON dbo.PartySite(lastUpdateTS)

CREATE INDEX acctID
    ON dbo.TAPSAccount(acctID,accountID)

CREATE INDEX groupDesiAccountIdx
    ON dbo.TAPSCustomerDesiStreetAccount(groupDesi,accountNumber,accountSystemRN)

CREATE INDEX fullName
    ON dbo.TAPSGeneralAddress(mainAddressInd,accountNumber,accountSystemRN,fullName1,fullName2,fullName3,fullName4)

CREATE INDEX TAPSGATInactiveAcctID_IDX
    ON dbo.TAPSGeneralAddressTypeInactive(accountID,nameAddressTypeFK)

CREATE INDEX workgroupName_idx
    ON dbo.TIDUser(workgroupName)

CREATE INDEX XIF3TNLBDOrderCapacity
    ON dbo.TNLBDOrderCapacity(orderCapacityCode,orderSubCapacityCode)

CREATE INDEX TN_ultprntIDX
    ON dbo.TradingName(ultimatePrntTradingNameFK)

CREATE INDEX TNDIDTNIV
    ON dbo.TradingNameDefinitionDetail(TNDIdentifierIDFK,tradingNameIdentifierValue)

CREATE INDEX TNLoc_tnIDX
    ON dbo.TradingNameLocation(tradingNameIDFK)

CREATE INDEX XIF2TradingNameLocBusDef
    ON dbo.TradingNameLocBusDef(tradingNameLocationID)

CREATE INDEX BINACR_AccNumSysAsoc
    ON dbo.BinaryAccountRelationship(accountNumber,accountSystemRN,associatedAccountNumberRN)

CREATE INDEX BusinessDefAccount_acctIDX
    ON dbo.BusinessDefAccount(accountIDFK)

CREATE INDEX DivisionCodeIDX
    ON dbo.BusinessDefinition(divisionCode,businessDefinitionID)

CREATE UNIQUE CLUSTERED INDEX BDIDDriverSeq_IDX
    ON dbo.BusinessDefinitionDetail(businessDefinitionIDFK,businessDefinitionSeqno)

CREATE INDEX parentGroupRoleIDX
    ON dbo.CoverageGroupRole(coverageGroupParentRoleRN)

CREATE INDEX FAShortNameTypeIDX
    ON dbo.FundAccount(fundShortName,clientIdentifierTypeCode)

CREATE INDEX updTimePartyIDTrNameIdx
    ON dbo.Party(lastUpdateTS,partyID,tradingNameIDFK)

CREATE INDEX PAVer
    ON dbo.PartyAttribute(versionID,partyAttributeID)

CREATE UNIQUE INDEX PartySite_partyIDX
    ON dbo.PartySite(partyIDFK,postalAddressIDFK)

CREATE INDEX acctIDLoad
    ON dbo.TAPSAccount(acctID,accountID)

CREATE INDEX groupDesiIdx
    ON dbo.TAPSCustomerDesiStreetAccount(groupDesi)

CREATE INDEX lastUpdateTS
    ON dbo.TAPSGeneralAddress(lastUpdateTS)

CREATE INDEX TradingName_i1
    ON dbo.TradingName(tradingNameID,tradingName)

CREATE INDEX XIF3TradingNameLocBusDef
    ON dbo.TradingNameLocBusDef(orderExecCapacityInstructCode)

CREATE INDEX AP_AccIDParTKPT
    ON dbo.AccountParticipant(accountIDFK,partyRoleRN,TKTrustFundNumber,primaryTrusteeIndRN)

CREATE INDEX assocAcctNubAcctNum
    ON dbo.BinaryAccountRelationship(associatedAccountNumberRN,accountNumber,accountSystemRN)

CREATE INDEX XnameIDParty
    ON dbo.Party(partyName,partyID)

CREATE INDEX PIDAtID
    ON dbo.PartyAttribute(partyIDFK,attrName,attrValue)

CREATE INDEX PartySite_postalAddID
    ON dbo.PartySite(postalAddressIDFK,siteID,partyIDFK)

CREATE INDEX AcctIDStatusIDX
    ON dbo.TAPSAccount(accountID,accountStatus)

CREATE INDEX TAPSGeneralAddressAcctID_IDX
    ON dbo.TAPSGeneralAddress(accountID)

CREATE INDEX lastUpdateTS
    ON dbo.AccountParticipant(lastUpdateTS)

CREATE INDEX XtnIDParty
    ON dbo.Party(tradingNameIDFK,partyID)

CREATE INDEX PartySite_tnlocX
    ON dbo.PartySite(tradingNameLocationIDFK)

CREATE INDEX acctLastUpdateTSIDX
    ON dbo.TAPSAccount(lastUpdateTS)

CREATE INDEX TAPSGeneralAddressFN1_IDX
    ON dbo.TAPSGeneralAddress(fullName1)

CREATE INDEX QSFund
    ON dbo.AccountParticipant(accountIDFK,partyRoleRN,siteIDFK,orderPlacerAliasForAcct,TKTrustFundNumber)

CREATE INDEX QSPartySite
    ON dbo.PartySite(siteID,partyIDFK)

CREATE INDEX brloc
    ON dbo.TAPSAccount(brloc)

CREATE UNIQUE INDEX XacctIDSiteRole
    ON dbo.AccountParticipant(accountIDFK,siteIDFK,partyRoleRN)

CREATE INDEX siteIDPartyID
    ON dbo.PartySite(siteID,partyIDFK,tradingNameLocationIDFK)

CREATE INDEX genlSpecGlCoSubIDX
    ON dbo.TAPSAccount(generalAccountUsageRN,specificAccountUsageRN,glCoSub,accountStatus,accountNumber,accountSystemRN)

CREATE INDEX XptySitePartySite
    ON dbo.PartySite(partyIDFK,siteID)

CREATE INDEX glCoSubStatusScopeRegion
    ON dbo.TAPSAccount(glCoSub,accountStatus,darwinManagedRN,darwinRegionRN)

CREATE INDEX XsiteDunsPartySite
    ON dbo.PartySite(dunsXref,siteID)

CREATE INDEX ii1
    ON dbo.TAPSAccount(generalAccountUsageRN,generalAccountUsageCode)

CREATE INDEX XsiteTDBPartySite
    ON dbo.PartySite(tdbXref,siteID)

CREATE INDEX ii2
    ON dbo.TAPSAccount(specificAccountUsageRN,specificAccountUsageCode)

CREATE INDEX OpenDateAcctStatusIDX
    ON dbo.TAPSAccount(accountOpenDate,accountStatus)

CREATE INDEX RegionScopeStatusIDX
    ON dbo.TAPSAccount(darwinRegionRN,darwinManagedRN,accountStatus)

CREATE INDEX TAAsNAIDAstAsGl
    ON dbo.TAPSAccount(shortName,accountID,accountStatus,accountSystemRN,glCoSub)

CREATE INDEX TA_GenaccSpecAcc
    ON dbo.TAPSAccount(generalAccountUsageRN,specificAccountUsageRN)

CREATE INDEX TAPS_NumSysStaID
    ON dbo.TAPSAccount(accountNumber,accountSystemRN,accountStatus,accountID)
