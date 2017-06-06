CREATE NONCLUSTERED INDEX AccountInitiationAcctID_IDX
    ON dbo.AccountInitiation(accountID)
go
CREATE NONCLUSTERED INDEX accountNumber
    ON dbo.AccountIDTAPSAccount(accountNumber,accountSystem,accountID)
go
CREATE NONCLUSTERED INDEX AccountParticipant_partyIDX
    ON dbo.AccountParticipant(partyIDFK)
go
CREATE NONCLUSTERED INDEX AcctGroupCoverageGroup_CovID
    ON dbo.AcctGroupCoverageGroup(coverageGroupIDFK)
go
CREATE NONCLUSTERED INDEX acctID
    ON dbo.AccountActivity(acctID,accountID)
go
CREATE NONCLUSTERED INDEX acctID
    ON dbo.AccountCorrespondentProduct(acctID,accountID)
go
CREATE NONCLUSTERED INDEX acctID
    ON dbo.AccountCreditData(acctID,accountID)
go
CREATE NONCLUSTERED INDEX acctID
    ON dbo.AccountFuturesProduct(acctID,accountID)
go
CREATE NONCLUSTERED INDEX acctID
    ON dbo.AccountFXProduct(acctID,accountID)
go
CREATE NONCLUSTERED INDEX acctID
    ON dbo.AccountIDTAPSAccount(acctID,accountID)
go
CREATE NONCLUSTERED INDEX AccountInitiationAcctID_IDX
    ON dbo.AccountInitiation(accountID)
go
CREATE NONCLUSTERED INDEX acctID
    ON dbo.AccountIRAProduct(acctID,accountID)
go
CREATE NONCLUSTERED INDEX acctID
    ON dbo.AccountOptionsProduct(acctID,accountID)
go
CREATE NONCLUSTERED INDEX acctID
    ON dbo.AccountPortfolioSweepProduct(acctID,accountID)
go
CREATE NONCLUSTERED INDEX acctID
    ON dbo.AccountProductData(acctID,accountID)
go
CREATE NONCLUSTERED INDEX acctID
    ON dbo.AccountRegionalData(acctID,accountID)
go
CREATE NONCLUSTERED INDEX acctID
    ON dbo.AccountTokyoProduct(acctID,accountID)
go
CREATE NONCLUSTERED INDEX acctID
    ON dbo.BinaryAccountRelationship(acctID,accountID)
go
CREATE NONCLUSTERED INDEX acctID
    ON dbo.ClearingBrokerReference(acctID,accountID)
go
CREATE NONCLUSTERED INDEX acctID
    ON dbo.DIAlternateDeliveryCode(acctID,accountID)
go
CREATE NONCLUSTERED INDEX acctID
    ON dbo.DIDTC(acctID,accountID)
go
CREATE NONCLUSTERED INDEX acctID
    ON dbo.DIGovernment(acctID,accountID)
go
CREATE NONCLUSTERED INDEX acctID
    ON dbo.DIPhysical(acctID,accountID)
go

CREATE NONCLUSTERED INDEX acctID
    ON dbo.TAPSAccount(acctID,accountID)
go
CREATE NONCLUSTERED INDEX acctIDLoad
    ON dbo.TAPSAccount(acctID,accountID)
go
CREATE NONCLUSTERED INDEX assocAcctNubAcctNum
    ON dbo.BinaryAccountRelationship(associatedAccountNumberRN,accountNumber,accountSystemRN)
go
CREATE NONCLUSTERED INDEX AtIDPID
    ON dbo.PartyAttribute(attrName,attrValue,partyIDFK)
go
CREATE NONCLUSTERED INDEX BusinessDefAccount_acctIDX
    ON dbo.BusinessDefAccount(accountIDFK)
go
CREATE CLUSTERED INDEX C_ResourcesToResourceGroups
    ON dbo.E3ResourcesToResourceGroups(resourceType,resourceAttr1,resourceGroupName)
go
CREATE NONCLUSTERED INDEX lastUpdateTS
    ON dbo.TAPSGeneralAddressInactive(lastUpdateTS)
go
CREATE NONCLUSTERED INDEX Membership_exchMembIDX
    ON dbo.Membership(exchangeMembershipTypeRN)
go
CREATE NONCLUSTERED INDEX Membership_partyExchIDX
    ON dbo.Membership(partyIDFK,exchangeRNFK)
go
CREATE NONCLUSTERED INDEX parentGroupRoleIDX
    ON dbo.CoverageGroupRole(coverageGroupParentRoleRN)
go
CREATE NONCLUSTERED INDEX PartyExchange_partyIDX
    ON dbo.PartyExchange(partyIDFK)
go
CREATE NONCLUSTERED INDEX PartyHierarchy_childIDX
    ON dbo.PartyHierarchy(childPartyIDFK)
go
CREATE NONCLUSTERED INDEX PAVer
    ON dbo.PartyAttribute(versionID,partyAttributeID)
go
CREATE NONCLUSTERED INDEX AtIDPID
    ON dbo.PartyAttribute(attrName,attrValue,partyIDFK)
go
CREATE NONCLUSTERED INDEX PKAttributeValidation
    ON dbo.AttributeValidation(primaryKey)
go
CREATE NONCLUSTERED INDEX primAcctSecGrCode_idx
    ON dbo.TIDWorkgroup(primaryAcctSecGrCode)
go
CREATE NONCLUSTERED INDEX RegionScopeStatusIDX
    ON dbo.TAPSAccount(darwinRegionRN,darwinManagedRN,accountStatus)
go
CREATE NONCLUSTERED INDEX RegionScopeStatusIDX
    ON dbo.TAPSAccount(darwinRegionRN,darwinManagedRN,accountStatus)
go
CREATE NONCLUSTERED INDEX TAPSGAInactiveAcctID_IDX
    ON dbo.TAPSGeneralAddressInactive(accountID)
go
CREATE NONCLUSTERED INDEX TAPSGATI_AccNumSysType
    ON dbo.TAPSGeneralAddressTypeInactive(accountNumberFK,accountSystemRN,nameAddressTypeFK)
go
CREATE NONCLUSTERED INDEX TNDIDTNIV
    ON dbo.TradingNameDefinitionDetail(TNDIdentifierIDFK,tradingNameIdentifierValue)
go
CREATE NONCLUSTERED INDEX TNIDTNDIDTITM
    ON dbo.TNDIdentifierDivision(tradingNameIDFK,TNDIdentifierIDFK,TNDInterestTypeRN,mandatoryIndicator)
go
CREATE UNIQUE NONCLUSTERED INDEX TNLClientIdentifierCodeAK
    ON dbo.TNLClientIdentifierCode(tradingNameLocationID,clientIdentifierTypeCode,clientIdentifierCode,businessProcessCode,bookingSelectionID,businessDefinitionID)
CREATE UNIQUE CLUSTERED INDEX TradingNameAudit_IDX
    ON dbo.TradingNameAudit(TrdNameAuditID)
  WITH MAX_ROWS_PER_PAGE = 150
go
CREATE NONCLUSTERED INDEX userlogin_idx
    ON dbo.TIDUser(userLoginName)
go
CREATE NONCLUSTERED INDEX workgroupName_idx
    ON dbo.TIDUser(workgroupName)
go
CREATE NONCLUSTERED INDEX workgroupName_idx
    ON dbo.TIDUser(workgroupName)
go
CREATE NONCLUSTERED INDEX XIF1GroupDesiCoverage
    ON dbo.GroupDesiCoverage(coverageGroupID)
go
CREATE NONCLUSTERED INDEX XIF1TradingNameLocBusDef
    ON dbo.TradingNameLocBusDef(businessDefinitionID)
go
CREATE NONCLUSTERED INDEX XIF2TradingNameLocBusDef
    ON dbo.TradingNameLocBusDef(tradingNameLocationID)
go
CREATE NONCLUSTERED INDEX XIF3TNLBDOrderCapacity
    ON dbo.TNLBDOrderCapacity(orderCapacityCode,orderSubCapacityCode)
go
CREATE NONCLUSTERED INDEX XIF3TradingNameLocBusDef
    ON dbo.TradingNameLocBusDef(orderExecCapacityInstructCode)
go
CREATE NONCLUSTERED INDEX XsiteDunsPartySite
    ON dbo.PartySite(dunsXref,siteID)
go
CREATE INDEX lastUpdateTS
    ON dbo.TAPSGeneralAddressTypeInactive(lastUpdateTS)
go
CREATE UNIQUE INDEX nc1
    ON dbo.t1(name,city)
go


