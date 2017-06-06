CREATE UNIQUE CLUSTERED INDEX accountIDIdx
    ON dbo.AccountActivity(accountID)

CREATE UNIQUE CLUSTERED INDEX PrimaryKey
    ON dbo.acctlist2(accountNumber,accountSystemRN,versionNumber)

CREATE UNIQUE CLUSTERED INDEX AKBDBrokerCodeAcct
    ON dbo.BDBrokerCodeAcct(accountNumber,accountSystemRN,brokerID,brokerCodeIssuer,businessDefinitionID,brokerRelationshipType)

CREATE UNIQUE CLUSTERED INDEX AKBrokerAccount
    ON dbo.BrokerAccount(accountNumber,accountSystemRN,brokerID)

CREATE UNIQUE CLUSTERED INDEX BDIDDriverSeq_IDX
    ON dbo.BusinessDefinitionDetailVer(businessDefinitionIDFK,businessDefinitionSeqno,versionID)

CREATE UNIQUE CLUSTERED INDEX CrossEntityAcctsIDX
    ON dbo.CrossEntityAccounts(accountNumber,streamID,contraAccountNumber,contraStreamID)

CREATE UNIQUE CLUSTERED INDEX i1
    ON dbo.dba_testreplication(int_col)

CREATE UNIQUE CLUSTERED INDEX i1
    ON dbo.dba_testreplication2(int_col)

CREATE CLUSTERED INDEX C_ResourcesToResourceGroups
    ON dbo.E3ResourcesToResourceGroups(resourceType,resourceAttr1,resourceGroupName)

CREATE UNIQUE CLUSTERED INDEX P2ExchangeID
    ON dbo.P2Exchange(mdExch,issueType,exchangeDescription,ISOcountryCode,marketSegment)

CREATE CLUSTERED INDEX rdEntitleIdx
    ON dbo.RDEntitlement(userID,entType)

CREATE UNIQUE CLUSTERED INDEX rs_lastcommit_idx
    ON dbo.rs_lastcommit(origin)

CREATE UNIQUE CLUSTERED INDEX rs_threads_idx
    ON dbo.rs_threads(id)

CREATE UNIQUE CLUSTERED INDEX TradingNameAudit_IDX
    ON dbo.TradingNameAudit(TrdNameAuditID)
  WITH MAX_ROWS_PER_PAGE = 150

CREATE CLUSTERED INDEX TradingNameVerAltKey
    ON dbo.TradingNameVer(replacementVersionID,tradingNameID,versionID)

CREATE INDEX acctID
    ON dbo.AccountActivity(acctID,accountID)

CREATE INDEX acctID
    ON dbo.AccountCorrespondentProduct(acctID,accountID)

CREATE INDEX acctID
    ON dbo.AccountCorrespondentProductVer(acctID,accountID)

CREATE INDEX acctID
    ON dbo.AccountCreditData(acctID,accountID)

CREATE INDEX accountID
    ON dbo.AccountFuturesProduct(accountID)

CREATE INDEX acctID
    ON dbo.AccountFXProduct(acctID,accountID)

CREATE INDEX accountNumber
    ON dbo.AccountIDTAPSAccount(accountNumber,accountSystem,accountID)

CREATE INDEX AccountInitiationAcctID_IDX
    ON dbo.AccountInitiation(accountID)

CREATE INDEX accountID
    ON dbo.AccountPortfolioSweepProduct(accountID)

CREATE INDEX accountID
    ON dbo.AccountRegionalData(accountID)

CREATE UNIQUE INDEX AKAcctBulkKSENumber
    ON dbo.AcctBulkKSENumber(bulkKSENumber,accountID,orderPlacerPartyID,principalPartyID)

CREATE INDEX ABVRepVer
    ON dbo.AcctBulkKSENumberVer(replacementVersionID,acctBulkKSENumberID)

CREATE INDEX AcctGroupCoverageGroup_CovID
    ON dbo.AcctGroupCoverageGroup(coverageGroupIDFK)

CREATE INDEX AcctGroupTAPSAcct_acctID
    ON dbo.AcctGroupTAPSAcct(accountIDFK)

CREATE INDEX tableName
    ON dbo.BadAccountID(tableName,accountNumber,accountSystemRN,accountID,correctAccountID)

CREATE INDEX acctNumSys
    ON dbo.BinaryAccountRelationship(accountNumber,accountSystemRN)

CREATE UNIQUE CLUSTERED INDEX BDIDDriverSeq_IDX
    ON dbo.BusinessDefinitionDetail(businessDefinitionIDFK,businessDefinitionSeqno)

CREATE UNIQUE CLUSTERED INDEX cBusinessDefinitionDetailIDX
    ON dbo.cbusinessdefinitiondetail(businessDefinitionIDFK,businessLineRN,businessLineRegionRN,productRN,underlyingProductRN,countryOfIssueRN,countryOfIssuerRN,businessLineOfficeRN,transactionTypeRN,exchangeRN,businessCapacityRN,settlementCcyRN,outOfCurrencyRN)

CREATE INDEX darwinManagedIDX
    ON Accounts.DarwinAccountScopeRegion(darwinManagedRN)

CREATE UNIQUE CLUSTERED INDEX EMPIDX
    ON dbo.employee_types(employeeTypeID)

CREATE INDEX approve_employeeTypeIDX
    ON dbo.employeeType_response_rights(approve_employeeTypeID)

CREATE INDEX x0
    ON dbo.mp1(partyID)

CREATE INDEX employeeNumber
    ON dbo.MSPerson(employeeNumber)

CREATE INDEX srce
    ON dbo.ORDProcessActivity(srce,id)

CREATE INDEX modifiedTS
    ON dbo.ORDUserEvent(modifiedTS)

CREATE UNIQUE INDEX IDPartyExchangeListing
    ON dbo.PartyExchangeListing(partyIDFK,mdExch,issueType,exchangeDescription,ISOcountryCode,marketSegment)

CREATE INDEX XversionID
    ON dbo.PartySiteVer(versionID)

CREATE INDEX XversionID
    ON dbo.PartyVer(versionID)

CREATE INDEX ardgOidX
    ON dbo.PostalAddress_NULLGeoCode(addrArdgOid)

CREATE INDEX TAPSISOCode
    ON dbo.RDRCountry(TAPScode,ISOcode)

CREATE INDEX idx
    ON dbo.RefName_check(refID)

CREATE INDEX lastUpdateTS
    ON dbo.RRParticipant(lastUpdateTS)

CREATE UNIQUE INDEX TAPSAccountVerPK
    ON dbo.TAPSAccountVer(accountNumber,accountSystemRN,versionNumber)

CREATE INDEX accountID
    ON dbo.TAPSCustomerDesiStreetAccount(accountID)

CREATE INDEX TAPSGeneralAddressAcctID_IDX
    ON dbo.TAPSGeneralAddress(accountID)

CREATE INDEX TAPSGAInactiveAcctID_IDX
    ON dbo.TAPSGeneralAddressInactive(accountID)

CREATE INDEX TAPSGAT_AcctIDType
    ON dbo.TAPSGeneralAddressType(accountID,nameAddressTypeFK)

CREATE INDEX TAPSGATI_AccNumSysType
    ON dbo.TAPSGeneralAddressTypeInactive(accountNumberFK,accountSystemRN,nameAddressTypeFK)

CREATE INDEX usertype_idx
    ON Accounts.TIDFavorite(msdwUserId,type,subtype)

CREATE UNIQUE INDEX formIDX
    ON dbo.TIDForm(formId)

CREATE INDEX cookiePackage_idx
    ON dbo.TIDPackage(cookie,packageType)

CREATE INDEX TNDIDTNIN
    ON dbo.TNDIdentifier(TNDIdentifierID,tradingNameIdentifierName)

CREATE INDEX TNIDTNDIDTITM
    ON dbo.TNDIdentifierDivision(tradingNameIDFK,TNDIdentifierIDFK,TNDInterestTypeRN,mandatoryIndicator)

CREATE INDEX TNDID
    ON dbo.TNDInterest(tradingNameDefinitionIDFK)

CREATE UNIQUE INDEX X
    ON Accounts.TNLAccount(tradingNameLocationIDFK,accountNumber,accountSystemRN)

CREATE CLUSTERED INDEX tableNameIDX
    ON dbo.TPDCounter(tableName)

CREATE INDEX TradingNameGroupDesi_TNID
    ON dbo.TradingNameGroupDesi(tradingNameIDFK)

CREATE INDEX AcctIDTNLAccount
    ON dbo.TradingNameLocationAccount(accountIDFK)

CREATE UNIQUE INDEX PartyIDTradingNameParty
    ON dbo.TradingNameParty(partyIDFK)

CREATE UNIQUE CLUSTERED INDEX WFIDX
    ON dbo.workflow(workflowTypeID,workflow_order,employeeTypeID)

CREATE INDEX PWSIDX
    ON dbo.WorkflowSpecs(workflowTypeID,brloc,inGlCoSub,generalProduct,specificProduct,newRelationshipIndicator,mlPassed,usCitizenResident,DFI,bookingCompany,nonJPNResident)

CREATE UNIQUE CLUSTERED INDEX WFTTSID
    ON dbo.WorkflowTypes(workflowTypeID)

CREATE INDEX accountID
    ON dbo.AccountCorrespondentProduct(accountID)

CREATE UNIQUE INDEX accountID
    ON dbo.AccountIDTAPSAccount(accountID)

CREATE INDEX AccountParticipant_SiteRole
    ON dbo.AccountParticipant(siteIDFK,partyRoleRN,accountIDFK)

CREATE INDEX versionEffectiveTS
    ON dbo.AccountParticipantVer(versionEffectiveTS)

CREATE INDEX AccountProduct_genPrdIDX
    ON dbo.AccountProduct(generalProductRN)

CREATE INDEX ABVVer
    ON dbo.AcctBulkKSENumberVer(versionID,acctBulkKSENumberID)

CREATE INDEX PKAttributeValidation
    ON dbo.AttributeValidation(primaryKey)

CREATE INDEX versionID
    ON dbo.AttributeValidationVer(versionID)

CREATE INDEX asscAcctNumSys
    ON dbo.BinaryAccountRelationship(associatedAccountNumberRN,accountSystemRN)

CREATE UNIQUE INDEX BookingSelectionAKIND
    ON dbo.BookingSelection(glCoSub,bookingSelectionDesc)

CREATE INDEX BusDefAcct_accountidIDX
    ON dbo.BusinessDefAccount(accountIDFK)

CREATE UNIQUE INDEX BusDef_descriptionIDX
    ON dbo.BusinessDefinition(description)

CREATE INDEX XIF1BusinessDefinitionType
    ON dbo.BusinessDefinitionType(parentBusDefTypeRN)

CREATE INDEX XIF1BusinessDefinitionTypeAttr
    ON dbo.BusinessDefinitionTypeAttr(busDefTypeRN)

CREATE UNIQUE INDEX AKClearingBrokerReference
    ON dbo.ClearingBrokerReference(accountID,giveUpReference,clearingBrokerRefID,exchangeRN)

CREATE UNIQUE INDEX XAK1ClientProfile
    ON dbo.ClientProfile(clientProfileName)

CREATE UNIQUE INDEX XAK1ClientProfileStoredProc
    ON dbo.ClientProfileStoredProc(clientProfileID,storedProcType)

CREATE UNIQUE INDEX DarwinAcct_numSysIDX
    ON dbo.DarwinAccount(accountNumber,accountSystemRN)

CREATE INDEX darwinRegionIDX
    ON Accounts.DarwinAccountScopeRegion(darwinRegionRN)

CREATE INDEX can_approveIDX
    ON dbo.employeeType_response_rights(can_approve)

CREATE INDEX ExceptionPartySite_partyID
    ON dbo.ExceptionPartySite(partyID)

CREATE INDEX accountID_01
    ON dbo.FundAccount(accountID)

CREATE INDEX GeoLoc_parentIDX
    ON dbo.GeoLocation(geoParentIDFK)

CREATE INDEX XIF1GroupDesiCoverage
    ON dbo.GroupDesiCoverage(coverageGroupID)

CREATE INDEX XIF1GroupDesiCoverageVer
    ON dbo.GroupDesiCoverageVer(groupDesi,coverageGroupID,accountSystemCode)

CREATE UNIQUE INDEX IdentificationDocument_ind1
    ON dbo.IdentificationDocument(partyIDFK,jpnDocumentTypeRN,jpnDocumentType)

CREATE UNIQUE INDEX InvestmentExperience_ind1
    ON dbo.InvestmentExperience(partyIDFK,jpnInvestExperienceTypeRN,jpnInvestExperienceType)

CREATE UNIQUE INDEX XAK1JapanTradedProduct
    ON dbo.JapanTradedProduct(accountIDFK,jpnTradedProductRN,jpnTradedProductOther)

CREATE INDEX XIF348KoreanPartyAccount
    ON dbo.KoreanPartyAccount(accountID)

CREATE INDEX accIDKSEAccount
    ON dbo.KoreanStockExchangeAccount(accountID)

CREATE INDEX Membership_exchMembIDX
    ON dbo.Membership(exchangeMembershipTypeRN)

CREATE UNIQUE INDEX ObjectRestriction_AltKey
    ON dbo.ObjectRestriction(complianceEventID,objectID)

CREATE UNIQUE INDEX ObjectRestrictionTableAltKey
    ON dbo.ObjectRestrictionTable(tableID,objectRestrictionID,tableName)

CREATE INDEX modifiedTSSrceIdx
    ON dbo.ORDProcessActivity(modifiedTS,srce)

CREATE INDEX XnameIDParty
    ON dbo.Party(partyName,partyID)

CREATE INDEX AtIDPID
    ON dbo.PartyAttribute(attrName,attrValue,partyIDFK)

CREATE INDEX PAVRepVer
    ON dbo.PartyAttributeVer(replacementVersionID,partyAttributeID)

CREATE UNIQUE CLUSTERED INDEX ReplacementVidAltKey
    ON dbo.PartyConfirmSettlementVer(replacementVersionID,partyIDFK,versionID)

CREATE INDEX PartyExchange_partyIDX
    ON dbo.PartyExchange(partyIDFK)

CREATE INDEX PartyHierarchy_childIDX
    ON dbo.PartyHierarchy(childPartyIDFK)

CREATE UNIQUE INDEX PartySite_partyIDX
    ON dbo.PartySite(partyIDFK,postalAddressIDFK)

CREATE INDEX replacementVersionID
    ON dbo.PartySiteVer(replacementVersionID)

CREATE INDEX versionID
    ON dbo.PartyVer(versionID)

CREATE INDEX XgeoLocIDPostalAddr
    ON dbo.PostalAddress(geoLocationIDFK)

CREATE INDEX versionID
    ON dbo.PostalAddressVer(versionID)

CREATE INDEX rrIDAccountType
    ON dbo.RRParticipant(rrIDFK,accountNumber,accountSystemRN,tapsPersonnelType)

CREATE INDEX AcctIDStatusIDX
    ON dbo.TAPSAccount(accountID,accountStatus)

CREATE INDEX i1
    ON dbo.TAPSAccountVer(generalAccountUsageCode)

CREATE INDEX groupDesiIdx
    ON dbo.TAPSCustomerDesiStreetAccount(groupDesi)

CREATE INDEX acctIDfullName1
    ON dbo.TAPSGeneralAddress(accountID,fullName1,fullName2,mainAddressInd)

CREATE INDEX TAPSGeneralAddressFN1_IDX
    ON dbo.TAPSGeneralAddressInactive(fullName1)

CREATE INDEX lastUpdateTS
    ON dbo.TAPSGeneralAddressType(lastUpdateTS)

CREATE INDEX TAPSGATInactiveAcctID_IDX
    ON dbo.TAPSGeneralAddressTypeInactive(accountID,nameAddressTypeFK)

CREATE INDEX msdwUserId_idx
    ON Accounts.TIDFavoriteBusDefID(msdwUserId)

CREATE INDEX formName_idx
    ON dbo.TIDForm(formName)

CREATE UNIQUE INDEX packageIDX
    ON dbo.TIDPackage(packageId)

CREATE INDEX userrole_idx
    ON dbo.TIDPartySiteFavorite(msdwUserId,roleId)

CREATE INDEX userrole_idx
    ON dbo.TIDRRFavorite(msdwUserId,roleId)

CREATE INDEX userlogin_idx
    ON dbo.TIDUser(userLoginName)

CREATE INDEX userlogin_idx
    ON dbo.TIDUserTest(userLoginName)

CREATE INDEX primAcctSecGrCode_idx
    ON dbo.TIDWorkgroup(primaryAcctSecGrCode)

CREATE INDEX TNDIDTNAR
    ON dbo.TNDAccount(tradingNameDefinitionIDFK,TNDAccountRoleRN)

CREATE INDEX TNDvid
    ON dbo.TNDAccountVer(versionID)

CREATE UNIQUE INDEX TNLBDBookingSelIDX
    ON dbo.TNLBDBookingSelection(businessDefinitionID,tradingNameLocationID,bookingSelectionID)

CREATE INDEX BDID_nonuniqIdx
    ON dbo.TNLBDOrderCapacity(businessDefinitionID)

CREATE INDEX XversionID
    ON dbo.TNLBDOrderCapacityVer(versionID)

CREATE UNIQUE INDEX XAK1TNLClientIdentifier
    ON dbo.TNLClientIdentifier(tradingNameLocationIDFK,clientIdentifierName,clientIdentifierValue)

CREATE UNIQUE INDEX TNLClientIdentifierCodeAK
    ON dbo.TNLClientIdentifierCode(tradingNameLocationID,clientIdentifierTypeCode,clientIdentifierCode,businessProcessCode,bookingSelectionID,businessDefinitionID)

CREATE INDEX TN_prntIDX
    ON dbo.TradingName(parentTradingNameFK)

CREATE INDEX operationTS
    ON dbo.TradingNameAudit(operationTS)

CREATE INDEX TNDIDTNDI
    ON dbo.TradingNameDefinitionDetail(tradingNameDefinitionIDFK,TNDIdentifierIDFK)

CREATE UNIQUE INDEX TNLoc_tnlocIDX
    ON dbo.TradingNameLocAlias(tradingNameLocationIDFK,foreignSystemRN,foreignSystemLocationRN,tradingNameLocAlias)

CREATE INDEX TNLoc_tnIDX
    ON dbo.TradingNameLocation(tradingNameIDFK)

CREATE INDEX versionId
    ON dbo.TradingNameLocationAccountVer(versionID)

CREATE INDEX XIF1TradingNameLocBusDef
    ON dbo.TradingNameLocBusDef(businessDefinitionID)

CREATE INDEX TNLBDCVRepVer
    ON dbo.TradingNameLocBusDefCoverageV(replacementVersionID,coverageGroupIDFK,tradingNameLocationIDFK,businessDefinitionIDFK)

CREATE UNIQUE INDEX TNLocExch_tnlExcCcrt
    ON dbo.TradingNameLocExchange(tradingNameLocationIDFK,exchangeRN,clientClearingRelTypeRN)

CREATE INDEX kerberosID
    ON dbo.UserUpdateAccount(kerberosID)

CREATE INDEX ETIDX
    ON dbo.workflow(employeeTypeID)

CREATE UNIQUE INDEX accountNumberDupKey
    ON dbo.AccountIDTAPSAccount(accountNumber,accountSystem)
  WITH IGNORE_DUP_KEY

CREATE INDEX AccountParticipant_acctIDX
    ON dbo.AccountParticipant(accountIDFK,partyRoleRN)

CREATE UNIQUE CLUSTERED INDEX ReplacementVidAltKey
    ON dbo.AttributeValidationVer(replacementVersionID,tableName,attributeName,primaryKey,versionID)

CREATE INDEX BusinessDefAccount_acctIDX
    ON dbo.BusinessDefAccount(accountIDFK)

CREATE INDEX acctID
    ON dbo.ClearingBrokerReference(acctID,accountID)

CREATE INDEX updatedFlagIDX
    ON Accounts.DarwinAccountScopeRegion(updatedFlag)

CREATE INDEX EMPTYPEID
    ON dbo.employeeType_response_rights(employeeTypeID)

CREATE UNIQUE INDEX ExceptionPartySite_siteID
    ON dbo.ExceptionPartySite(siteID,partyID,exceptionID,causeCode)

CREATE INDEX Membership_partyExchIDX
    ON dbo.Membership(partyIDFK,exchangeRNFK)

CREATE INDEX XtnIDParty
    ON dbo.Party(tradingNameIDFK)

CREATE INDEX AtIDPIDRN
    ON dbo.PartyAttribute(attrNameRN,attrValueRN,partyIDFK)

CREATE INDEX PAVVer
    ON dbo.PartyAttributeVer(versionID,partyAttributeID)

CREATE INDEX PartyHierarchy_parentIDX
    ON dbo.PartyHierarchy(parentPartyIDFK)

CREATE INDEX PartySite_tnlocX
    ON dbo.PartySite(tradingNameLocationIDFK)

CREATE INDEX partyIDFK
    ON dbo.PartySiteVer(partyIDFK)

CREATE INDEX replacementVersionID
    ON dbo.PartyVer(replacementVersionID)

CREATE INDEX versionID
    ON dbo.PostalAddress(versionID)

CREATE INDEX replacementVersionID
    ON dbo.PostalAddressVer(replacementVersionID)

CREATE INDEX accountSysNumRRlastUpdateTS
    ON dbo.RRParticipant(lastUpdateTS,accountNumber,accountSystemRN,rrIDFK)

CREATE INDEX OpenDateAcctStatusIDX
    ON dbo.TAPSAccount(accountOpenDate,accountStatus)

CREATE INDEX lastUpdateTS
    ON dbo.TAPSAccountVer(lastUpdateTS)

CREATE INDEX fullName
    ON dbo.TAPSGeneralAddress(mainAddressInd,accountNumber,accountSystemRN,fullName1,fullName2,fullName3,fullName4)

CREATE INDEX packageId_idx
    ON dbo.TIDForm(packageId)

CREATE INDEX packageState_idx
    ON dbo.TIDPackage(packageState)

CREATE INDEX workgroupName_idx
    ON dbo.TIDUser(workgroupName)

CREATE INDEX workgroupName_idx
    ON dbo.TIDUserTest(workgroupName)

CREATE INDEX workgroupName_idx
    ON dbo.TIDWorkgroup(workgroupName)

CREATE INDEX TNDreplvid
    ON dbo.TNDAccountVer(replacementVersionID)

CREATE INDEX XIF3TNLBDOrderCapacity
    ON dbo.TNLBDOrderCapacity(orderCapacityCode,orderSubCapacityCode)

CREATE INDEX TN_ultprntIDX
    ON dbo.TradingName(ultimatePrntTradingNameFK)

CREATE INDEX TNDIDTNIV
    ON dbo.TradingNameDefinitionDetail(TNDIdentifierIDFK,tradingNameIdentifierValue)

CREATE INDEX TNLGeoLocation
    ON dbo.TradingNameLocation(geoLocationRNFK)

CREATE INDEX XIF2TradingNameLocBusDef
    ON dbo.TradingNameLocBusDef(tradingNameLocationID)

CREATE INDEX TNLBDCVVer
    ON dbo.TradingNameLocBusDefCoverageV(versionID,coverageGroupIDFK,tradingNameLocationIDFK,businessDefinitionIDFK)

CREATE INDEX lastUpdateTS
    ON dbo.UserUpdateAccount(lastUpdateTS)

CREATE INDEX mIDX
    ON dbo.workflow(employee_no_must_match)

CREATE INDEX modifiedTS
    ON dbo.AccountIDTAPSAccount(modifiedTS)

CREATE INDEX AccountParticipant_partyIDX
    ON dbo.AccountParticipant(partyIDFK)

CREATE UNIQUE INDEX IDX
    ON dbo.employeeType_response_rights(employeeTypeID,approve_employeeTypeID)

CREATE INDEX versionID
    ON dbo.Party(versionID)

CREATE INDEX PAVer
    ON dbo.PartyAttribute(versionID,partyAttributeID)

CREATE INDEX lastUpdateTS
    ON dbo.PartyAttributeVer(lastUpdateTS)

CREATE INDEX XptySitePartySite
    ON dbo.PartySite(partyIDFK,siteID)

CREATE INDEX RegionScopeStatusIDX
    ON dbo.TAPSAccount(darwinRegionRN,darwinManagedRN,accountStatus)

CREATE INDEX acctID
    ON dbo.TAPSAccountVer(acctID,accountID)

CREATE INDEX TAPSGeneralAddressFN1_IDX
    ON dbo.TAPSGeneralAddress(fullName1)

CREATE INDEX savedPackage_idx
    ON dbo.TIDPackage(savedPackageName,workgroupName,packageType)

CREATE UNIQUE INDEX XAK1TradingName
    ON dbo.TradingName(tradingName)

CREATE INDEX XIF3TradingNameLocBusDef
    ON dbo.TradingNameLocBusDef(orderExecCapacityInstructCode)

CREATE INDEX acctID
    ON dbo.AccountIDTAPSAccount(acctID,accountID)

CREATE UNIQUE INDEX XacctIDSiteRole
    ON dbo.AccountParticipant(accountIDFK,siteIDFK,partyRoleRN)

CREATE INDEX PIDAtID
    ON dbo.PartyAttribute(partyIDFK,attrName,attrValue)

CREATE INDEX XsiteDunsPartySite
    ON dbo.PartySite(dunsXref,siteID)

CREATE INDEX ScopeStatusIDX
    ON dbo.TAPSAccount(darwinManagedRN,accountStatus)

CREATE INDEX i1
    ON dbo.TAPSGeneralAddress(BOAddressInd,accountNumber,accountSystemRN,nameAddressSeqNum)

CREATE INDEX TIDPackage_TypeIDX
    ON dbo.TIDPackage(packageType)

CREATE INDEX orderPlacerAliasForAccount
    ON dbo.AccountParticipant(orderPlacerAliasForAcct)

CREATE INDEX PIDAtIDRN
    ON dbo.PartyAttribute(partyIDFK,attrNameRN,attrValueRN)

CREATE INDEX XsiteTDBPartySite
    ON dbo.PartySite(tdbXref,siteID)

CREATE INDEX acctDunsNumIDX
    ON dbo.TAPSAccount(accountDunsNumber,accountNumber,accountSystemRN)

CREATE INDEX lastUpdateTS
    ON dbo.TAPSGeneralAddress(lastUpdateTS)

CREATE INDEX workgrouppackage_idx
    ON dbo.TIDPackage(workgroupName,packageType)

CREATE INDEX versionID
    ON dbo.AccountParticipant(versionID)

CREATE INDEX lastUpdateTS
    ON dbo.PartyAttribute(lastUpdateTS)

CREATE INDEX creationTS
    ON dbo.PartySite(creationTS)

CREATE INDEX acctLastUpdateTSIDX
    ON dbo.TAPSAccount(lastUpdateTS)

CREATE INDEX TKTrustFundNumber
    ON dbo.AccountParticipant(TKTrustFundNumber,accountIDFK,partyIDFK)

CREATE INDEX versionID
    ON dbo.PartySite(versionID)

CREATE INDEX glCoSubStatusScopeRegion
    ON dbo.TAPSAccount(glCoSub,accountStatus,darwinManagedRN,darwinRegionRN)

CREATE INDEX postalAddressIDFK
    ON dbo.PartySite(postalAddressIDFK)

CREATE INDEX acctID
    ON dbo.TAPSAccount(acctID,accountID)

CREATE INDEX ii2
    ON dbo.TAPSAccount(specificAccountUsageRN,specificAccountUsageCode)

CREATE INDEX ii1
    ON dbo.TAPSAccount(generalAccountUsageRN,generalAccountUsageCode)

CREATE INDEX accountshortNameIndex
    ON dbo.TAPSAccount(shortName)
