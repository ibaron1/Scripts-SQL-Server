CREATE UNIQUE CLUSTERED INDEX accountIDIdx
    ON dbo.AccountActivity(accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountActivity') AND name='accountIDIdx')
    PRINT '<<< CREATED INDEX dbo.AccountActivity.accountIDIdx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountActivity.accountIDIdx >>>'
go

CREATE UNIQUE CLUSTERED INDEX PrimaryKey
    ON dbo.acctlist2(accountNumber,accountSystemRN,versionNumber)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.acctlist2') AND name='PrimaryKey')
    PRINT '<<< CREATED INDEX dbo.acctlist2.PrimaryKey >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.acctlist2.PrimaryKey >>>'
go

CREATE UNIQUE CLUSTERED INDEX AKBDBrokerCodeAcct
    ON dbo.BDBrokerCodeAcct(accountNumber,accountSystemRN,brokerID,brokerCodeIssuer,businessDefinitionID,brokerRelationshipType)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.BDBrokerCodeAcct') AND name='AKBDBrokerCodeAcct')
    PRINT '<<< CREATED INDEX dbo.BDBrokerCodeAcct.AKBDBrokerCodeAcct >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.BDBrokerCodeAcct.AKBDBrokerCodeAcct >>>'
go

CREATE UNIQUE CLUSTERED INDEX AKBrokerAccount
    ON dbo.BrokerAccount(accountNumber,accountSystemRN,brokerID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.BrokerAccount') AND name='AKBrokerAccount')
    PRINT '<<< CREATED INDEX dbo.BrokerAccount.AKBrokerAccount >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.BrokerAccount.AKBrokerAccount >>>'
go

CREATE UNIQUE CLUSTERED INDEX BDIDDriverSeq_IDX
    ON dbo.BusinessDefinitionDetailVer(businessDefinitionIDFK,businessDefinitionSeqno,versionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.BusinessDefinitionDetailVer') AND name='BDIDDriverSeq_IDX')
    PRINT '<<< CREATED INDEX dbo.BusinessDefinitionDetailVer.BDIDDriverSeq_IDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.BusinessDefinitionDetailVer.BDIDDriverSeq_IDX >>>'
go

CREATE UNIQUE CLUSTERED INDEX CrossEntityAcctsIDX
    ON dbo.CrossEntityAccounts(accountNumber,streamID,contraAccountNumber,contraStreamID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.CrossEntityAccounts') AND name='CrossEntityAcctsIDX')
    PRINT '<<< CREATED INDEX dbo.CrossEntityAccounts.CrossEntityAcctsIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.CrossEntityAccounts.CrossEntityAcctsIDX >>>'
go

CREATE UNIQUE CLUSTERED INDEX i1
    ON dbo.dba_testreplication(int_col)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.dba_testreplication') AND name='i1')
    PRINT '<<< CREATED INDEX dbo.dba_testreplication.i1 >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.dba_testreplication.i1 >>>'
go

CREATE UNIQUE CLUSTERED INDEX i1
    ON dbo.dba_testreplication2(int_col)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.dba_testreplication2') AND name='i1')
    PRINT '<<< CREATED INDEX dbo.dba_testreplication2.i1 >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.dba_testreplication2.i1 >>>'
go

CREATE CLUSTERED INDEX C_ResourcesToResourceGroups
    ON dbo.E3ResourcesToResourceGroups(resourceType,resourceAttr1,resourceGroupName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.E3ResourcesToResourceGroups') AND name='C_ResourcesToResourceGroups')
    PRINT '<<< CREATED INDEX dbo.E3ResourcesToResourceGroups.C_ResourcesToResourceGroups >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.E3ResourcesToResourceGroups.C_ResourcesToResourceGroups >>>'
go

CREATE UNIQUE CLUSTERED INDEX P2ExchangeID
    ON dbo.P2Exchange(mdExch,issueType,exchangeDescription,ISOcountryCode,marketSegment)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.P2Exchange') AND name='P2ExchangeID')
    PRINT '<<< CREATED INDEX dbo.P2Exchange.P2ExchangeID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.P2Exchange.P2ExchangeID >>>'
go

CREATE CLUSTERED INDEX rdEntitleIdx
    ON dbo.RDEntitlement(userID,entType)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.RDEntitlement') AND name='rdEntitleIdx')
    PRINT '<<< CREATED INDEX dbo.RDEntitlement.rdEntitleIdx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.RDEntitlement.rdEntitleIdx >>>'
go

CREATE UNIQUE CLUSTERED INDEX rs_lastcommit_idx
    ON dbo.rs_lastcommit(origin)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.rs_lastcommit') AND name='rs_lastcommit_idx')
    PRINT '<<< CREATED INDEX dbo.rs_lastcommit.rs_lastcommit_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.rs_lastcommit.rs_lastcommit_idx >>>'
go

CREATE UNIQUE CLUSTERED INDEX rs_threads_idx
    ON dbo.rs_threads(id)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.rs_threads') AND name='rs_threads_idx')
    PRINT '<<< CREATED INDEX dbo.rs_threads.rs_threads_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.rs_threads.rs_threads_idx >>>'
go

CREATE UNIQUE CLUSTERED INDEX TradingNameAudit_IDX
    ON dbo.TradingNameAudit(TrdNameAuditID)
  WITH MAX_ROWS_PER_PAGE = 150
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingNameAudit') AND name='TradingNameAudit_IDX')
    PRINT '<<< CREATED INDEX dbo.TradingNameAudit.TradingNameAudit_IDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingNameAudit.TradingNameAudit_IDX >>>'
go

CREATE CLUSTERED INDEX TradingNameVerAltKey
    ON dbo.TradingNameVer(replacementVersionID,tradingNameID,versionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingNameVer') AND name='TradingNameVerAltKey')
    PRINT '<<< CREATED INDEX dbo.TradingNameVer.TradingNameVerAltKey >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingNameVer.TradingNameVerAltKey >>>'
go

CREATE INDEX acctID
    ON dbo.AccountActivity(acctID,accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountActivity') AND name='acctID')
    PRINT '<<< CREATED INDEX dbo.AccountActivity.acctID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountActivity.acctID >>>'
go

CREATE INDEX acctID
    ON dbo.AccountCorrespondentProduct(acctID,accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountCorrespondentProduct') AND name='acctID')
    PRINT '<<< CREATED INDEX dbo.AccountCorrespondentProduct.acctID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountCorrespondentProduct.acctID >>>'
go

CREATE INDEX acctID
    ON dbo.AccountCorrespondentProductVer(acctID,accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountCorrespondentProductVer') AND name='acctID')
    PRINT '<<< CREATED INDEX dbo.AccountCorrespondentProductVer.acctID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountCorrespondentProductVer.acctID >>>'
go

CREATE INDEX acctID
    ON dbo.AccountCreditData(acctID,accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountCreditData') AND name='acctID')
    PRINT '<<< CREATED INDEX dbo.AccountCreditData.acctID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountCreditData.acctID >>>'
go

CREATE INDEX accountID
    ON dbo.AccountFuturesProduct(accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountFuturesProduct') AND name='accountID')
    PRINT '<<< CREATED INDEX dbo.AccountFuturesProduct.accountID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountFuturesProduct.accountID >>>'
go

CREATE INDEX acctID
    ON dbo.AccountFXProduct(acctID,accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountFXProduct') AND name='acctID')
    PRINT '<<< CREATED INDEX dbo.AccountFXProduct.acctID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountFXProduct.acctID >>>'
go

CREATE INDEX accountNumber
    ON dbo.AccountIDTAPSAccount(accountNumber,accountSystem,accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountIDTAPSAccount') AND name='accountNumber')
    PRINT '<<< CREATED INDEX dbo.AccountIDTAPSAccount.accountNumber >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountIDTAPSAccount.accountNumber >>>'
go

CREATE INDEX AccountInitiationAcctID_IDX
    ON dbo.AccountInitiation(accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountInitiation') AND name='AccountInitiationAcctID_IDX')
    PRINT '<<< CREATED INDEX dbo.AccountInitiation.AccountInitiationAcctID_IDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountInitiation.AccountInitiationAcctID_IDX >>>'
go

CREATE INDEX accountID
    ON dbo.AccountPortfolioSweepProduct(accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountPortfolioSweepProduct') AND name='accountID')
    PRINT '<<< CREATED INDEX dbo.AccountPortfolioSweepProduct.accountID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountPortfolioSweepProduct.accountID >>>'
go

CREATE INDEX accountID
    ON dbo.AccountRegionalData(accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountRegionalData') AND name='accountID')
    PRINT '<<< CREATED INDEX dbo.AccountRegionalData.accountID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountRegionalData.accountID >>>'
go

CREATE UNIQUE INDEX AKAcctBulkKSENumber
    ON dbo.AcctBulkKSENumber(bulkKSENumber,accountID,orderPlacerPartyID,principalPartyID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AcctBulkKSENumber') AND name='AKAcctBulkKSENumber')
    PRINT '<<< CREATED INDEX dbo.AcctBulkKSENumber.AKAcctBulkKSENumber >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AcctBulkKSENumber.AKAcctBulkKSENumber >>>'
go

CREATE INDEX ABVRepVer
    ON dbo.AcctBulkKSENumberVer(replacementVersionID,acctBulkKSENumberID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AcctBulkKSENumberVer') AND name='ABVRepVer')
    PRINT '<<< CREATED INDEX dbo.AcctBulkKSENumberVer.ABVRepVer >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AcctBulkKSENumberVer.ABVRepVer >>>'
go

CREATE INDEX AcctGroupCoverageGroup_CovID
    ON dbo.AcctGroupCoverageGroup(coverageGroupIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AcctGroupCoverageGroup') AND name='AcctGroupCoverageGroup_CovID')
    PRINT '<<< CREATED INDEX dbo.AcctGroupCoverageGroup.AcctGroupCoverageGroup_CovID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AcctGroupCoverageGroup.AcctGroupCoverageGroup_CovID >>>'
go

CREATE INDEX AcctGroupTAPSAcct_acctID
    ON dbo.AcctGroupTAPSAcct(accountIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AcctGroupTAPSAcct') AND name='AcctGroupTAPSAcct_acctID')
    PRINT '<<< CREATED INDEX dbo.AcctGroupTAPSAcct.AcctGroupTAPSAcct_acctID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AcctGroupTAPSAcct.AcctGroupTAPSAcct_acctID >>>'
go

CREATE INDEX tableName
    ON dbo.BadAccountID(tableName,accountNumber,accountSystemRN,accountID,correctAccountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.BadAccountID') AND name='tableName')
    PRINT '<<< CREATED INDEX dbo.BadAccountID.tableName >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.BadAccountID.tableName >>>'
go

CREATE INDEX acctNumSys
    ON dbo.BinaryAccountRelationship(accountNumber,accountSystemRN)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.BinaryAccountRelationship') AND name='acctNumSys')
    PRINT '<<< CREATED INDEX dbo.BinaryAccountRelationship.acctNumSys >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.BinaryAccountRelationship.acctNumSys >>>'
go

CREATE UNIQUE CLUSTERED INDEX BDIDDriverSeq_IDX
    ON dbo.BusinessDefinitionDetail(businessDefinitionIDFK,businessDefinitionSeqno)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.BusinessDefinitionDetail') AND name='BDIDDriverSeq_IDX')
    PRINT '<<< CREATED INDEX dbo.BusinessDefinitionDetail.BDIDDriverSeq_IDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.BusinessDefinitionDetail.BDIDDriverSeq_IDX >>>'
go

CREATE UNIQUE CLUSTERED INDEX cBusinessDefinitionDetailIDX
    ON dbo.cbusinessdefinitiondetail(businessDefinitionIDFK,businessLineRN,businessLineRegionRN,productRN,underlyingProductRN,countryOfIssueRN,countryOfIssuerRN,businessLineOfficeRN,transactionTypeRN,exchangeRN,businessCapacityRN,settlementCcyRN,outOfCurrencyRN)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.cbusinessdefinitiondetail') AND name='cBusinessDefinitionDetailIDX')
    PRINT '<<< CREATED INDEX dbo.cbusinessdefinitiondetail.cBusinessDefinitionDetailIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.cbusinessdefinitiondetail.cBusinessDefinitionDetailIDX >>>'
go

CREATE INDEX darwinManagedIDX
    ON Accounts.DarwinAccountScopeRegion(darwinManagedRN)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('Accounts.DarwinAccountScopeRegion') AND name='darwinManagedIDX')
    PRINT '<<< CREATED INDEX Accounts.DarwinAccountScopeRegion.darwinManagedIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Accounts.DarwinAccountScopeRegion.darwinManagedIDX >>>'
go

CREATE UNIQUE CLUSTERED INDEX EMPIDX
    ON dbo.employee_types(employeeTypeID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.employee_types') AND name='EMPIDX')
    PRINT '<<< CREATED INDEX dbo.employee_types.EMPIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.employee_types.EMPIDX >>>'
go

CREATE INDEX approve_employeeTypeIDX
    ON dbo.employeeType_response_rights(approve_employeeTypeID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.employeeType_response_rights') AND name='approve_employeeTypeIDX')
    PRINT '<<< CREATED INDEX dbo.employeeType_response_rights.approve_employeeTypeIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.employeeType_response_rights.approve_employeeTypeIDX >>>'
go

CREATE INDEX x0
    ON dbo.mp1(partyID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.mp1') AND name='x0')
    PRINT '<<< CREATED INDEX dbo.mp1.x0 >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.mp1.x0 >>>'
go

CREATE INDEX employeeNumber
    ON dbo.MSPerson(employeeNumber)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.MSPerson') AND name='employeeNumber')
    PRINT '<<< CREATED INDEX dbo.MSPerson.employeeNumber >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.MSPerson.employeeNumber >>>'
go

CREATE INDEX srce
    ON dbo.ORDProcessActivity(srce,id)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.ORDProcessActivity') AND name='srce')
    PRINT '<<< CREATED INDEX dbo.ORDProcessActivity.srce >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.ORDProcessActivity.srce >>>'
go

CREATE INDEX modifiedTS
    ON dbo.ORDUserEvent(modifiedTS)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.ORDUserEvent') AND name='modifiedTS')
    PRINT '<<< CREATED INDEX dbo.ORDUserEvent.modifiedTS >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.ORDUserEvent.modifiedTS >>>'
go

CREATE UNIQUE INDEX IDPartyExchangeListing
    ON dbo.PartyExchangeListing(partyIDFK,mdExch,issueType,exchangeDescription,ISOcountryCode,marketSegment)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartyExchangeListing') AND name='IDPartyExchangeListing')
    PRINT '<<< CREATED INDEX dbo.PartyExchangeListing.IDPartyExchangeListing >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartyExchangeListing.IDPartyExchangeListing >>>'
go

CREATE INDEX XversionID
    ON dbo.PartySiteVer(versionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartySiteVer') AND name='XversionID')
    PRINT '<<< CREATED INDEX dbo.PartySiteVer.XversionID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartySiteVer.XversionID >>>'
go

CREATE INDEX XversionID
    ON dbo.PartyVer(versionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartyVer') AND name='XversionID')
    PRINT '<<< CREATED INDEX dbo.PartyVer.XversionID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartyVer.XversionID >>>'
go

CREATE INDEX ardgOidX
    ON dbo.PostalAddress_NULLGeoCode(addrArdgOid)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PostalAddress_NULLGeoCode') AND name='ardgOidX')
    PRINT '<<< CREATED INDEX dbo.PostalAddress_NULLGeoCode.ardgOidX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PostalAddress_NULLGeoCode.ardgOidX >>>'
go

CREATE INDEX TAPSISOCode
    ON dbo.RDRCountry(TAPScode,ISOcode)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.RDRCountry') AND name='TAPSISOCode')
    PRINT '<<< CREATED INDEX dbo.RDRCountry.TAPSISOCode >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.RDRCountry.TAPSISOCode >>>'
go

CREATE INDEX idx
    ON dbo.RefName_check(refID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.RefName_check') AND name='idx')
    PRINT '<<< CREATED INDEX dbo.RefName_check.idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.RefName_check.idx >>>'
go

CREATE INDEX lastUpdateTS
    ON dbo.RRParticipant(lastUpdateTS)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.RRParticipant') AND name='lastUpdateTS')
    PRINT '<<< CREATED INDEX dbo.RRParticipant.lastUpdateTS >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.RRParticipant.lastUpdateTS >>>'
go

CREATE UNIQUE INDEX TAPSAccountVerPK
    ON dbo.TAPSAccountVer(accountNumber,accountSystemRN,versionNumber)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSAccountVer') AND name='TAPSAccountVerPK')
    PRINT '<<< CREATED INDEX dbo.TAPSAccountVer.TAPSAccountVerPK >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSAccountVer.TAPSAccountVerPK >>>'
go

CREATE INDEX accountID
    ON dbo.TAPSCustomerDesiStreetAccount(accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSCustomerDesiStreetAccount') AND name='accountID')
    PRINT '<<< CREATED INDEX dbo.TAPSCustomerDesiStreetAccount.accountID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSCustomerDesiStreetAccount.accountID >>>'
go

CREATE INDEX TAPSGeneralAddressAcctID_IDX
    ON dbo.TAPSGeneralAddress(accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSGeneralAddress') AND name='TAPSGeneralAddressAcctID_IDX')
    PRINT '<<< CREATED INDEX dbo.TAPSGeneralAddress.TAPSGeneralAddressAcctID_IDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSGeneralAddress.TAPSGeneralAddressAcctID_IDX >>>'
go

CREATE INDEX TAPSGAInactiveAcctID_IDX
    ON dbo.TAPSGeneralAddressInactive(accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSGeneralAddressInactive') AND name='TAPSGAInactiveAcctID_IDX')
    PRINT '<<< CREATED INDEX dbo.TAPSGeneralAddressInactive.TAPSGAInactiveAcctID_IDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSGeneralAddressInactive.TAPSGAInactiveAcctID_IDX >>>'
go

CREATE INDEX TAPSGAT_AcctIDType
    ON dbo.TAPSGeneralAddressType(accountID,nameAddressTypeFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSGeneralAddressType') AND name='TAPSGAT_AcctIDType')
    PRINT '<<< CREATED INDEX dbo.TAPSGeneralAddressType.TAPSGAT_AcctIDType >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSGeneralAddressType.TAPSGAT_AcctIDType >>>'
go

CREATE INDEX TAPSGATI_AccNumSysType
    ON dbo.TAPSGeneralAddressTypeInactive(accountNumberFK,accountSystemRN,nameAddressTypeFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSGeneralAddressTypeInactive') AND name='TAPSGATI_AccNumSysType')
    PRINT '<<< CREATED INDEX dbo.TAPSGeneralAddressTypeInactive.TAPSGATI_AccNumSysType >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSGeneralAddressTypeInactive.TAPSGATI_AccNumSysType >>>'
go

CREATE INDEX usertype_idx
    ON Accounts.TIDFavorite(msdwUserId,type,subtype)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('Accounts.TIDFavorite') AND name='usertype_idx')
    PRINT '<<< CREATED INDEX Accounts.TIDFavorite.usertype_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Accounts.TIDFavorite.usertype_idx >>>'
go

CREATE UNIQUE INDEX formIDX
    ON dbo.TIDForm(formId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TIDForm') AND name='formIDX')
    PRINT '<<< CREATED INDEX dbo.TIDForm.formIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TIDForm.formIDX >>>'
go

CREATE INDEX cookiePackage_idx
    ON dbo.TIDPackage(cookie,packageType)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TIDPackage') AND name='cookiePackage_idx')
    PRINT '<<< CREATED INDEX dbo.TIDPackage.cookiePackage_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TIDPackage.cookiePackage_idx >>>'
go

CREATE INDEX TNDIDTNIN
    ON dbo.TNDIdentifier(TNDIdentifierID,tradingNameIdentifierName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TNDIdentifier') AND name='TNDIDTNIN')
    PRINT '<<< CREATED INDEX dbo.TNDIdentifier.TNDIDTNIN >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TNDIdentifier.TNDIDTNIN >>>'
go

CREATE INDEX TNIDTNDIDTITM
    ON dbo.TNDIdentifierDivision(tradingNameIDFK,TNDIdentifierIDFK,TNDInterestTypeRN,mandatoryIndicator)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TNDIdentifierDivision') AND name='TNIDTNDIDTITM')
    PRINT '<<< CREATED INDEX dbo.TNDIdentifierDivision.TNIDTNDIDTITM >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TNDIdentifierDivision.TNIDTNDIDTITM >>>'
go

CREATE INDEX TNDID
    ON dbo.TNDInterest(tradingNameDefinitionIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TNDInterest') AND name='TNDID')
    PRINT '<<< CREATED INDEX dbo.TNDInterest.TNDID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TNDInterest.TNDID >>>'
go

CREATE UNIQUE INDEX X
    ON Accounts.TNLAccount(tradingNameLocationIDFK,accountNumber,accountSystemRN)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('Accounts.TNLAccount') AND name='X')
    PRINT '<<< CREATED INDEX Accounts.TNLAccount.X >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Accounts.TNLAccount.X >>>'
go

CREATE CLUSTERED INDEX tableNameIDX
    ON dbo.TPDCounter(tableName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TPDCounter') AND name='tableNameIDX')
    PRINT '<<< CREATED INDEX dbo.TPDCounter.tableNameIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TPDCounter.tableNameIDX >>>'
go

CREATE INDEX TradingNameGroupDesi_TNID
    ON dbo.TradingNameGroupDesi(tradingNameIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingNameGroupDesi') AND name='TradingNameGroupDesi_TNID')
    PRINT '<<< CREATED INDEX dbo.TradingNameGroupDesi.TradingNameGroupDesi_TNID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingNameGroupDesi.TradingNameGroupDesi_TNID >>>'
go

CREATE INDEX AcctIDTNLAccount
    ON dbo.TradingNameLocationAccount(accountIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingNameLocationAccount') AND name='AcctIDTNLAccount')
    PRINT '<<< CREATED INDEX dbo.TradingNameLocationAccount.AcctIDTNLAccount >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingNameLocationAccount.AcctIDTNLAccount >>>'
go

CREATE UNIQUE INDEX PartyIDTradingNameParty
    ON dbo.TradingNameParty(partyIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingNameParty') AND name='PartyIDTradingNameParty')
    PRINT '<<< CREATED INDEX dbo.TradingNameParty.PartyIDTradingNameParty >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingNameParty.PartyIDTradingNameParty >>>'
go

CREATE UNIQUE CLUSTERED INDEX WFIDX
    ON dbo.workflow(workflowTypeID,workflow_order,employeeTypeID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.workflow') AND name='WFIDX')
    PRINT '<<< CREATED INDEX dbo.workflow.WFIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.workflow.WFIDX >>>'
go

CREATE INDEX PWSIDX
    ON dbo.WorkflowSpecs(workflowTypeID,brloc,inGlCoSub,generalProduct,specificProduct,newRelationshipIndicator,mlPassed,usCitizenResident,DFI,bookingCompany,nonJPNResident)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.WorkflowSpecs') AND name='PWSIDX')
    PRINT '<<< CREATED INDEX dbo.WorkflowSpecs.PWSIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.WorkflowSpecs.PWSIDX >>>'
go

CREATE UNIQUE CLUSTERED INDEX WFTTSID
    ON dbo.WorkflowTypes(workflowTypeID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.WorkflowTypes') AND name='WFTTSID')
    PRINT '<<< CREATED INDEX dbo.WorkflowTypes.WFTTSID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.WorkflowTypes.WFTTSID >>>'
go

CREATE INDEX accountID
    ON dbo.AccountCorrespondentProduct(accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountCorrespondentProduct') AND name='accountID')
    PRINT '<<< CREATED INDEX dbo.AccountCorrespondentProduct.accountID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountCorrespondentProduct.accountID >>>'
go

CREATE UNIQUE INDEX accountID
    ON dbo.AccountIDTAPSAccount(accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountIDTAPSAccount') AND name='accountID')
    PRINT '<<< CREATED INDEX dbo.AccountIDTAPSAccount.accountID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountIDTAPSAccount.accountID >>>'
go

CREATE INDEX AccountParticipant_SiteRole
    ON dbo.AccountParticipant(siteIDFK,partyRoleRN,accountIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountParticipant') AND name='AccountParticipant_SiteRole')
    PRINT '<<< CREATED INDEX dbo.AccountParticipant.AccountParticipant_SiteRole >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountParticipant.AccountParticipant_SiteRole >>>'
go

CREATE INDEX versionEffectiveTS
    ON dbo.AccountParticipantVer(versionEffectiveTS)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountParticipantVer') AND name='versionEffectiveTS')
    PRINT '<<< CREATED INDEX dbo.AccountParticipantVer.versionEffectiveTS >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountParticipantVer.versionEffectiveTS >>>'
go

CREATE INDEX AccountProduct_genPrdIDX
    ON dbo.AccountProduct(generalProductRN)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountProduct') AND name='AccountProduct_genPrdIDX')
    PRINT '<<< CREATED INDEX dbo.AccountProduct.AccountProduct_genPrdIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountProduct.AccountProduct_genPrdIDX >>>'
go

CREATE INDEX ABVVer
    ON dbo.AcctBulkKSENumberVer(versionID,acctBulkKSENumberID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AcctBulkKSENumberVer') AND name='ABVVer')
    PRINT '<<< CREATED INDEX dbo.AcctBulkKSENumberVer.ABVVer >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AcctBulkKSENumberVer.ABVVer >>>'
go

CREATE INDEX PKAttributeValidation
    ON dbo.AttributeValidation(primaryKey)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AttributeValidation') AND name='PKAttributeValidation')
    PRINT '<<< CREATED INDEX dbo.AttributeValidation.PKAttributeValidation >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AttributeValidation.PKAttributeValidation >>>'
go

CREATE INDEX versionID
    ON dbo.AttributeValidationVer(versionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AttributeValidationVer') AND name='versionID')
    PRINT '<<< CREATED INDEX dbo.AttributeValidationVer.versionID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AttributeValidationVer.versionID >>>'
go

CREATE INDEX asscAcctNumSys
    ON dbo.BinaryAccountRelationship(associatedAccountNumberRN,accountSystemRN)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.BinaryAccountRelationship') AND name='asscAcctNumSys')
    PRINT '<<< CREATED INDEX dbo.BinaryAccountRelationship.asscAcctNumSys >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.BinaryAccountRelationship.asscAcctNumSys >>>'
go

CREATE UNIQUE INDEX BookingSelectionAKIND
    ON dbo.BookingSelection(glCoSub,bookingSelectionDesc)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.BookingSelection') AND name='BookingSelectionAKIND')
    PRINT '<<< CREATED INDEX dbo.BookingSelection.BookingSelectionAKIND >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.BookingSelection.BookingSelectionAKIND >>>'
go

CREATE INDEX BusDefAcct_accountidIDX
    ON dbo.BusinessDefAccount(accountIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.BusinessDefAccount') AND name='BusDefAcct_accountidIDX')
    PRINT '<<< CREATED INDEX dbo.BusinessDefAccount.BusDefAcct_accountidIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.BusinessDefAccount.BusDefAcct_accountidIDX >>>'
go

CREATE UNIQUE INDEX BusDef_descriptionIDX
    ON dbo.BusinessDefinition(description)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.BusinessDefinition') AND name='BusDef_descriptionIDX')
    PRINT '<<< CREATED INDEX dbo.BusinessDefinition.BusDef_descriptionIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.BusinessDefinition.BusDef_descriptionIDX >>>'
go

CREATE INDEX XIF1BusinessDefinitionType
    ON dbo.BusinessDefinitionType(parentBusDefTypeRN)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.BusinessDefinitionType') AND name='XIF1BusinessDefinitionType')
    PRINT '<<< CREATED INDEX dbo.BusinessDefinitionType.XIF1BusinessDefinitionType >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.BusinessDefinitionType.XIF1BusinessDefinitionType >>>'
go

CREATE INDEX XIF1BusinessDefinitionTypeAttr
    ON dbo.BusinessDefinitionTypeAttr(busDefTypeRN)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.BusinessDefinitionTypeAttr') AND name='XIF1BusinessDefinitionTypeAttr')
    PRINT '<<< CREATED INDEX dbo.BusinessDefinitionTypeAttr.XIF1BusinessDefinitionTypeAttr >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.BusinessDefinitionTypeAttr.XIF1BusinessDefinitionTypeAttr >>>'
go

CREATE UNIQUE INDEX AKClearingBrokerReference
    ON dbo.ClearingBrokerReference(accountID,giveUpReference,clearingBrokerRefID,exchangeRN)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.ClearingBrokerReference') AND name='AKClearingBrokerReference')
    PRINT '<<< CREATED INDEX dbo.ClearingBrokerReference.AKClearingBrokerReference >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.ClearingBrokerReference.AKClearingBrokerReference >>>'
go

CREATE UNIQUE INDEX XAK1ClientProfile
    ON dbo.ClientProfile(clientProfileName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.ClientProfile') AND name='XAK1ClientProfile')
    PRINT '<<< CREATED INDEX dbo.ClientProfile.XAK1ClientProfile >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.ClientProfile.XAK1ClientProfile >>>'
go

CREATE UNIQUE INDEX XAK1ClientProfileStoredProc
    ON dbo.ClientProfileStoredProc(clientProfileID,storedProcType)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.ClientProfileStoredProc') AND name='XAK1ClientProfileStoredProc')
    PRINT '<<< CREATED INDEX dbo.ClientProfileStoredProc.XAK1ClientProfileStoredProc >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.ClientProfileStoredProc.XAK1ClientProfileStoredProc >>>'
go

CREATE UNIQUE INDEX DarwinAcct_numSysIDX
    ON dbo.DarwinAccount(accountNumber,accountSystemRN)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.DarwinAccount') AND name='DarwinAcct_numSysIDX')
    PRINT '<<< CREATED INDEX dbo.DarwinAccount.DarwinAcct_numSysIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.DarwinAccount.DarwinAcct_numSysIDX >>>'
go

CREATE INDEX darwinRegionIDX
    ON Accounts.DarwinAccountScopeRegion(darwinRegionRN)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('Accounts.DarwinAccountScopeRegion') AND name='darwinRegionIDX')
    PRINT '<<< CREATED INDEX Accounts.DarwinAccountScopeRegion.darwinRegionIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Accounts.DarwinAccountScopeRegion.darwinRegionIDX >>>'
go

CREATE INDEX can_approveIDX
    ON dbo.employeeType_response_rights(can_approve)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.employeeType_response_rights') AND name='can_approveIDX')
    PRINT '<<< CREATED INDEX dbo.employeeType_response_rights.can_approveIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.employeeType_response_rights.can_approveIDX >>>'
go

CREATE INDEX ExceptionPartySite_partyID
    ON dbo.ExceptionPartySite(partyID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.ExceptionPartySite') AND name='ExceptionPartySite_partyID')
    PRINT '<<< CREATED INDEX dbo.ExceptionPartySite.ExceptionPartySite_partyID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.ExceptionPartySite.ExceptionPartySite_partyID >>>'
go

CREATE INDEX accountID_01
    ON dbo.FundAccount(accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.FundAccount') AND name='accountID_01')
    PRINT '<<< CREATED INDEX dbo.FundAccount.accountID_01 >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.FundAccount.accountID_01 >>>'
go

CREATE INDEX GeoLoc_parentIDX
    ON dbo.GeoLocation(geoParentIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.GeoLocation') AND name='GeoLoc_parentIDX')
    PRINT '<<< CREATED INDEX dbo.GeoLocation.GeoLoc_parentIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.GeoLocation.GeoLoc_parentIDX >>>'
go

CREATE INDEX XIF1GroupDesiCoverage
    ON dbo.GroupDesiCoverage(coverageGroupID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.GroupDesiCoverage') AND name='XIF1GroupDesiCoverage')
    PRINT '<<< CREATED INDEX dbo.GroupDesiCoverage.XIF1GroupDesiCoverage >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.GroupDesiCoverage.XIF1GroupDesiCoverage >>>'
go

CREATE INDEX XIF1GroupDesiCoverageVer
    ON dbo.GroupDesiCoverageVer(groupDesi,coverageGroupID,accountSystemCode)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.GroupDesiCoverageVer') AND name='XIF1GroupDesiCoverageVer')
    PRINT '<<< CREATED INDEX dbo.GroupDesiCoverageVer.XIF1GroupDesiCoverageVer >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.GroupDesiCoverageVer.XIF1GroupDesiCoverageVer >>>'
go

CREATE UNIQUE INDEX IdentificationDocument_ind1
    ON dbo.IdentificationDocument(partyIDFK,jpnDocumentTypeRN,jpnDocumentType)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.IdentificationDocument') AND name='IdentificationDocument_ind1')
    PRINT '<<< CREATED INDEX dbo.IdentificationDocument.IdentificationDocument_ind1 >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.IdentificationDocument.IdentificationDocument_ind1 >>>'
go

CREATE UNIQUE INDEX InvestmentExperience_ind1
    ON dbo.InvestmentExperience(partyIDFK,jpnInvestExperienceTypeRN,jpnInvestExperienceType)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.InvestmentExperience') AND name='InvestmentExperience_ind1')
    PRINT '<<< CREATED INDEX dbo.InvestmentExperience.InvestmentExperience_ind1 >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.InvestmentExperience.InvestmentExperience_ind1 >>>'
go

CREATE UNIQUE INDEX XAK1JapanTradedProduct
    ON dbo.JapanTradedProduct(accountIDFK,jpnTradedProductRN,jpnTradedProductOther)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.JapanTradedProduct') AND name='XAK1JapanTradedProduct')
    PRINT '<<< CREATED INDEX dbo.JapanTradedProduct.XAK1JapanTradedProduct >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.JapanTradedProduct.XAK1JapanTradedProduct >>>'
go

CREATE INDEX XIF348KoreanPartyAccount
    ON dbo.KoreanPartyAccount(accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.KoreanPartyAccount') AND name='XIF348KoreanPartyAccount')
    PRINT '<<< CREATED INDEX dbo.KoreanPartyAccount.XIF348KoreanPartyAccount >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.KoreanPartyAccount.XIF348KoreanPartyAccount >>>'
go

CREATE INDEX accIDKSEAccount
    ON dbo.KoreanStockExchangeAccount(accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.KoreanStockExchangeAccount') AND name='accIDKSEAccount')
    PRINT '<<< CREATED INDEX dbo.KoreanStockExchangeAccount.accIDKSEAccount >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.KoreanStockExchangeAccount.accIDKSEAccount >>>'
go

CREATE INDEX Membership_exchMembIDX
    ON dbo.Membership(exchangeMembershipTypeRN)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Membership') AND name='Membership_exchMembIDX')
    PRINT '<<< CREATED INDEX dbo.Membership.Membership_exchMembIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Membership.Membership_exchMembIDX >>>'
go

CREATE UNIQUE INDEX ObjectRestriction_AltKey
    ON dbo.ObjectRestriction(complianceEventID,objectID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.ObjectRestriction') AND name='ObjectRestriction_AltKey')
    PRINT '<<< CREATED INDEX dbo.ObjectRestriction.ObjectRestriction_AltKey >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.ObjectRestriction.ObjectRestriction_AltKey >>>'
go

CREATE UNIQUE INDEX ObjectRestrictionTableAltKey
    ON dbo.ObjectRestrictionTable(tableID,objectRestrictionID,tableName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.ObjectRestrictionTable') AND name='ObjectRestrictionTableAltKey')
    PRINT '<<< CREATED INDEX dbo.ObjectRestrictionTable.ObjectRestrictionTableAltKey >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.ObjectRestrictionTable.ObjectRestrictionTableAltKey >>>'
go

CREATE INDEX modifiedTSSrceIdx
    ON dbo.ORDProcessActivity(modifiedTS,srce)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.ORDProcessActivity') AND name='modifiedTSSrceIdx')
    PRINT '<<< CREATED INDEX dbo.ORDProcessActivity.modifiedTSSrceIdx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.ORDProcessActivity.modifiedTSSrceIdx >>>'
go

CREATE INDEX XnameIDParty
    ON dbo.Party(partyName,partyID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Party') AND name='XnameIDParty')
    PRINT '<<< CREATED INDEX dbo.Party.XnameIDParty >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Party.XnameIDParty >>>'
go

CREATE INDEX AtIDPID
    ON dbo.PartyAttribute(attrName,attrValue,partyIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartyAttribute') AND name='AtIDPID')
    PRINT '<<< CREATED INDEX dbo.PartyAttribute.AtIDPID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartyAttribute.AtIDPID >>>'
go

CREATE INDEX PAVRepVer
    ON dbo.PartyAttributeVer(replacementVersionID,partyAttributeID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartyAttributeVer') AND name='PAVRepVer')
    PRINT '<<< CREATED INDEX dbo.PartyAttributeVer.PAVRepVer >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartyAttributeVer.PAVRepVer >>>'
go

CREATE UNIQUE CLUSTERED INDEX ReplacementVidAltKey
    ON dbo.PartyConfirmSettlementVer(replacementVersionID,partyIDFK,versionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartyConfirmSettlementVer') AND name='ReplacementVidAltKey')
    PRINT '<<< CREATED INDEX dbo.PartyConfirmSettlementVer.ReplacementVidAltKey >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartyConfirmSettlementVer.ReplacementVidAltKey >>>'
go

CREATE INDEX PartyExchange_partyIDX
    ON dbo.PartyExchange(partyIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartyExchange') AND name='PartyExchange_partyIDX')
    PRINT '<<< CREATED INDEX dbo.PartyExchange.PartyExchange_partyIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartyExchange.PartyExchange_partyIDX >>>'
go

CREATE INDEX PartyHierarchy_childIDX
    ON dbo.PartyHierarchy(childPartyIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartyHierarchy') AND name='PartyHierarchy_childIDX')
    PRINT '<<< CREATED INDEX dbo.PartyHierarchy.PartyHierarchy_childIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartyHierarchy.PartyHierarchy_childIDX >>>'
go

CREATE UNIQUE INDEX PartySite_partyIDX
    ON dbo.PartySite(partyIDFK,postalAddressIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartySite') AND name='PartySite_partyIDX')
    PRINT '<<< CREATED INDEX dbo.PartySite.PartySite_partyIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartySite.PartySite_partyIDX >>>'
go

CREATE INDEX replacementVersionID
    ON dbo.PartySiteVer(replacementVersionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartySiteVer') AND name='replacementVersionID')
    PRINT '<<< CREATED INDEX dbo.PartySiteVer.replacementVersionID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartySiteVer.replacementVersionID >>>'
go

CREATE INDEX versionID
    ON dbo.PartyVer(versionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartyVer') AND name='versionID')
    PRINT '<<< CREATED INDEX dbo.PartyVer.versionID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartyVer.versionID >>>'
go

CREATE INDEX XgeoLocIDPostalAddr
    ON dbo.PostalAddress(geoLocationIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PostalAddress') AND name='XgeoLocIDPostalAddr')
    PRINT '<<< CREATED INDEX dbo.PostalAddress.XgeoLocIDPostalAddr >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PostalAddress.XgeoLocIDPostalAddr >>>'
go

CREATE INDEX versionID
    ON dbo.PostalAddressVer(versionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PostalAddressVer') AND name='versionID')
    PRINT '<<< CREATED INDEX dbo.PostalAddressVer.versionID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PostalAddressVer.versionID >>>'
go

CREATE INDEX rrIDAccountType
    ON dbo.RRParticipant(rrIDFK,accountNumber,accountSystemRN,tapsPersonnelType)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.RRParticipant') AND name='rrIDAccountType')
    PRINT '<<< CREATED INDEX dbo.RRParticipant.rrIDAccountType >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.RRParticipant.rrIDAccountType >>>'
go

CREATE INDEX AcctIDStatusIDX
    ON dbo.TAPSAccount(accountID,accountStatus)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSAccount') AND name='AcctIDStatusIDX')
    PRINT '<<< CREATED INDEX dbo.TAPSAccount.AcctIDStatusIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSAccount.AcctIDStatusIDX >>>'
go

CREATE INDEX i1
    ON dbo.TAPSAccountVer(generalAccountUsageCode)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSAccountVer') AND name='i1')
    PRINT '<<< CREATED INDEX dbo.TAPSAccountVer.i1 >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSAccountVer.i1 >>>'
go

CREATE INDEX groupDesiIdx
    ON dbo.TAPSCustomerDesiStreetAccount(groupDesi)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSCustomerDesiStreetAccount') AND name='groupDesiIdx')
    PRINT '<<< CREATED INDEX dbo.TAPSCustomerDesiStreetAccount.groupDesiIdx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSCustomerDesiStreetAccount.groupDesiIdx >>>'
go

CREATE INDEX acctIDfullName1
    ON dbo.TAPSGeneralAddress(accountID,fullName1,fullName2,mainAddressInd)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSGeneralAddress') AND name='acctIDfullName1')
    PRINT '<<< CREATED INDEX dbo.TAPSGeneralAddress.acctIDfullName1 >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSGeneralAddress.acctIDfullName1 >>>'
go

CREATE INDEX TAPSGeneralAddressFN1_IDX
    ON dbo.TAPSGeneralAddressInactive(fullName1)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSGeneralAddressInactive') AND name='TAPSGeneralAddressFN1_IDX')
    PRINT '<<< CREATED INDEX dbo.TAPSGeneralAddressInactive.TAPSGeneralAddressFN1_IDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSGeneralAddressInactive.TAPSGeneralAddressFN1_IDX >>>'
go

CREATE INDEX lastUpdateTS
    ON dbo.TAPSGeneralAddressType(lastUpdateTS)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSGeneralAddressType') AND name='lastUpdateTS')
    PRINT '<<< CREATED INDEX dbo.TAPSGeneralAddressType.lastUpdateTS >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSGeneralAddressType.lastUpdateTS >>>'
go

CREATE INDEX TAPSGATInactiveAcctID_IDX
    ON dbo.TAPSGeneralAddressTypeInactive(accountID,nameAddressTypeFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSGeneralAddressTypeInactive') AND name='TAPSGATInactiveAcctID_IDX')
    PRINT '<<< CREATED INDEX dbo.TAPSGeneralAddressTypeInactive.TAPSGATInactiveAcctID_IDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSGeneralAddressTypeInactive.TAPSGATInactiveAcctID_IDX >>>'
go

CREATE INDEX msdwUserId_idx
    ON Accounts.TIDFavoriteBusDefID(msdwUserId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('Accounts.TIDFavoriteBusDefID') AND name='msdwUserId_idx')
    PRINT '<<< CREATED INDEX Accounts.TIDFavoriteBusDefID.msdwUserId_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Accounts.TIDFavoriteBusDefID.msdwUserId_idx >>>'
go

CREATE INDEX formName_idx
    ON dbo.TIDForm(formName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TIDForm') AND name='formName_idx')
    PRINT '<<< CREATED INDEX dbo.TIDForm.formName_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TIDForm.formName_idx >>>'
go

CREATE UNIQUE INDEX packageIDX
    ON dbo.TIDPackage(packageId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TIDPackage') AND name='packageIDX')
    PRINT '<<< CREATED INDEX dbo.TIDPackage.packageIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TIDPackage.packageIDX >>>'
go

CREATE INDEX userrole_idx
    ON dbo.TIDPartySiteFavorite(msdwUserId,roleId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TIDPartySiteFavorite') AND name='userrole_idx')
    PRINT '<<< CREATED INDEX dbo.TIDPartySiteFavorite.userrole_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TIDPartySiteFavorite.userrole_idx >>>'
go

CREATE INDEX userrole_idx
    ON dbo.TIDRRFavorite(msdwUserId,roleId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TIDRRFavorite') AND name='userrole_idx')
    PRINT '<<< CREATED INDEX dbo.TIDRRFavorite.userrole_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TIDRRFavorite.userrole_idx >>>'
go

CREATE INDEX userlogin_idx
    ON dbo.TIDUser(userLoginName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TIDUser') AND name='userlogin_idx')
    PRINT '<<< CREATED INDEX dbo.TIDUser.userlogin_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TIDUser.userlogin_idx >>>'
go

CREATE INDEX userlogin_idx
    ON dbo.TIDUserTest(userLoginName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TIDUserTest') AND name='userlogin_idx')
    PRINT '<<< CREATED INDEX dbo.TIDUserTest.userlogin_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TIDUserTest.userlogin_idx >>>'
go

CREATE INDEX primAcctSecGrCode_idx
    ON dbo.TIDWorkgroup(primaryAcctSecGrCode)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TIDWorkgroup') AND name='primAcctSecGrCode_idx')
    PRINT '<<< CREATED INDEX dbo.TIDWorkgroup.primAcctSecGrCode_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TIDWorkgroup.primAcctSecGrCode_idx >>>'
go

CREATE INDEX TNDIDTNAR
    ON dbo.TNDAccount(tradingNameDefinitionIDFK,TNDAccountRoleRN)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TNDAccount') AND name='TNDIDTNAR')
    PRINT '<<< CREATED INDEX dbo.TNDAccount.TNDIDTNAR >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TNDAccount.TNDIDTNAR >>>'
go

CREATE INDEX TNDvid
    ON dbo.TNDAccountVer(versionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TNDAccountVer') AND name='TNDvid')
    PRINT '<<< CREATED INDEX dbo.TNDAccountVer.TNDvid >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TNDAccountVer.TNDvid >>>'
go

CREATE UNIQUE INDEX TNLBDBookingSelIDX
    ON dbo.TNLBDBookingSelection(businessDefinitionID,tradingNameLocationID,bookingSelectionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TNLBDBookingSelection') AND name='TNLBDBookingSelIDX')
    PRINT '<<< CREATED INDEX dbo.TNLBDBookingSelection.TNLBDBookingSelIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TNLBDBookingSelection.TNLBDBookingSelIDX >>>'
go

CREATE INDEX BDID_nonuniqIdx
    ON dbo.TNLBDOrderCapacity(businessDefinitionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TNLBDOrderCapacity') AND name='BDID_nonuniqIdx')
    PRINT '<<< CREATED INDEX dbo.TNLBDOrderCapacity.BDID_nonuniqIdx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TNLBDOrderCapacity.BDID_nonuniqIdx >>>'
go

CREATE INDEX XversionID
    ON dbo.TNLBDOrderCapacityVer(versionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TNLBDOrderCapacityVer') AND name='XversionID')
    PRINT '<<< CREATED INDEX dbo.TNLBDOrderCapacityVer.XversionID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TNLBDOrderCapacityVer.XversionID >>>'
go

CREATE UNIQUE INDEX XAK1TNLClientIdentifier
    ON dbo.TNLClientIdentifier(tradingNameLocationIDFK,clientIdentifierName,clientIdentifierValue)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TNLClientIdentifier') AND name='XAK1TNLClientIdentifier')
    PRINT '<<< CREATED INDEX dbo.TNLClientIdentifier.XAK1TNLClientIdentifier >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TNLClientIdentifier.XAK1TNLClientIdentifier >>>'
go

CREATE UNIQUE INDEX TNLClientIdentifierCodeAK
    ON dbo.TNLClientIdentifierCode(tradingNameLocationID,clientIdentifierTypeCode,clientIdentifierCode,businessProcessCode,bookingSelectionID,businessDefinitionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TNLClientIdentifierCode') AND name='TNLClientIdentifierCodeAK')
    PRINT '<<< CREATED INDEX dbo.TNLClientIdentifierCode.TNLClientIdentifierCodeAK >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TNLClientIdentifierCode.TNLClientIdentifierCodeAK >>>'
go

CREATE INDEX TN_prntIDX
    ON dbo.TradingName(parentTradingNameFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingName') AND name='TN_prntIDX')
    PRINT '<<< CREATED INDEX dbo.TradingName.TN_prntIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingName.TN_prntIDX >>>'
go

CREATE INDEX operationTS
    ON dbo.TradingNameAudit(operationTS)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingNameAudit') AND name='operationTS')
    PRINT '<<< CREATED INDEX dbo.TradingNameAudit.operationTS >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingNameAudit.operationTS >>>'
go

CREATE INDEX TNDIDTNDI
    ON dbo.TradingNameDefinitionDetail(tradingNameDefinitionIDFK,TNDIdentifierIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingNameDefinitionDetail') AND name='TNDIDTNDI')
    PRINT '<<< CREATED INDEX dbo.TradingNameDefinitionDetail.TNDIDTNDI >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingNameDefinitionDetail.TNDIDTNDI >>>'
go

CREATE UNIQUE INDEX TNLoc_tnlocIDX
    ON dbo.TradingNameLocAlias(tradingNameLocationIDFK,foreignSystemRN,foreignSystemLocationRN,tradingNameLocAlias)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingNameLocAlias') AND name='TNLoc_tnlocIDX')
    PRINT '<<< CREATED INDEX dbo.TradingNameLocAlias.TNLoc_tnlocIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingNameLocAlias.TNLoc_tnlocIDX >>>'
go

CREATE INDEX TNLoc_tnIDX
    ON dbo.TradingNameLocation(tradingNameIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingNameLocation') AND name='TNLoc_tnIDX')
    PRINT '<<< CREATED INDEX dbo.TradingNameLocation.TNLoc_tnIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingNameLocation.TNLoc_tnIDX >>>'
go

CREATE INDEX versionId
    ON dbo.TradingNameLocationAccountVer(versionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingNameLocationAccountVer') AND name='versionId')
    PRINT '<<< CREATED INDEX dbo.TradingNameLocationAccountVer.versionId >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingNameLocationAccountVer.versionId >>>'
go

CREATE INDEX XIF1TradingNameLocBusDef
    ON dbo.TradingNameLocBusDef(businessDefinitionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingNameLocBusDef') AND name='XIF1TradingNameLocBusDef')
    PRINT '<<< CREATED INDEX dbo.TradingNameLocBusDef.XIF1TradingNameLocBusDef >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingNameLocBusDef.XIF1TradingNameLocBusDef >>>'
go

CREATE INDEX TNLBDCVRepVer
    ON dbo.TradingNameLocBusDefCoverageV(replacementVersionID,coverageGroupIDFK,tradingNameLocationIDFK,businessDefinitionIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingNameLocBusDefCoverageV') AND name='TNLBDCVRepVer')
    PRINT '<<< CREATED INDEX dbo.TradingNameLocBusDefCoverageV.TNLBDCVRepVer >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingNameLocBusDefCoverageV.TNLBDCVRepVer >>>'
go

CREATE UNIQUE INDEX TNLocExch_tnlExcCcrt
    ON dbo.TradingNameLocExchange(tradingNameLocationIDFK,exchangeRN,clientClearingRelTypeRN)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingNameLocExchange') AND name='TNLocExch_tnlExcCcrt')
    PRINT '<<< CREATED INDEX dbo.TradingNameLocExchange.TNLocExch_tnlExcCcrt >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingNameLocExchange.TNLocExch_tnlExcCcrt >>>'
go

CREATE INDEX kerberosID
    ON dbo.UserUpdateAccount(kerberosID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.UserUpdateAccount') AND name='kerberosID')
    PRINT '<<< CREATED INDEX dbo.UserUpdateAccount.kerberosID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.UserUpdateAccount.kerberosID >>>'
go

CREATE INDEX ETIDX
    ON dbo.workflow(employeeTypeID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.workflow') AND name='ETIDX')
    PRINT '<<< CREATED INDEX dbo.workflow.ETIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.workflow.ETIDX >>>'
go

CREATE UNIQUE INDEX accountNumberDupKey
    ON dbo.AccountIDTAPSAccount(accountNumber,accountSystem)
  WITH IGNORE_DUP_KEY
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountIDTAPSAccount') AND name='accountNumberDupKey')
    PRINT '<<< CREATED INDEX dbo.AccountIDTAPSAccount.accountNumberDupKey >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountIDTAPSAccount.accountNumberDupKey >>>'
go

CREATE INDEX AccountParticipant_acctIDX
    ON dbo.AccountParticipant(accountIDFK,partyRoleRN)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountParticipant') AND name='AccountParticipant_acctIDX')
    PRINT '<<< CREATED INDEX dbo.AccountParticipant.AccountParticipant_acctIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountParticipant.AccountParticipant_acctIDX >>>'
go

CREATE UNIQUE CLUSTERED INDEX ReplacementVidAltKey
    ON dbo.AttributeValidationVer(replacementVersionID,tableName,attributeName,primaryKey,versionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AttributeValidationVer') AND name='ReplacementVidAltKey')
    PRINT '<<< CREATED INDEX dbo.AttributeValidationVer.ReplacementVidAltKey >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AttributeValidationVer.ReplacementVidAltKey >>>'
go

CREATE INDEX BusinessDefAccount_acctIDX
    ON dbo.BusinessDefAccount(accountIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.BusinessDefAccount') AND name='BusinessDefAccount_acctIDX')
    PRINT '<<< CREATED INDEX dbo.BusinessDefAccount.BusinessDefAccount_acctIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.BusinessDefAccount.BusinessDefAccount_acctIDX >>>'
go

CREATE INDEX acctID
    ON dbo.ClearingBrokerReference(acctID,accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.ClearingBrokerReference') AND name='acctID')
    PRINT '<<< CREATED INDEX dbo.ClearingBrokerReference.acctID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.ClearingBrokerReference.acctID >>>'
go

CREATE INDEX updatedFlagIDX
    ON Accounts.DarwinAccountScopeRegion(updatedFlag)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('Accounts.DarwinAccountScopeRegion') AND name='updatedFlagIDX')
    PRINT '<<< CREATED INDEX Accounts.DarwinAccountScopeRegion.updatedFlagIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX Accounts.DarwinAccountScopeRegion.updatedFlagIDX >>>'
go

CREATE INDEX EMPTYPEID
    ON dbo.employeeType_response_rights(employeeTypeID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.employeeType_response_rights') AND name='EMPTYPEID')
    PRINT '<<< CREATED INDEX dbo.employeeType_response_rights.EMPTYPEID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.employeeType_response_rights.EMPTYPEID >>>'
go

CREATE UNIQUE INDEX ExceptionPartySite_siteID
    ON dbo.ExceptionPartySite(siteID,partyID,exceptionID,causeCode)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.ExceptionPartySite') AND name='ExceptionPartySite_siteID')
    PRINT '<<< CREATED INDEX dbo.ExceptionPartySite.ExceptionPartySite_siteID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.ExceptionPartySite.ExceptionPartySite_siteID >>>'
go

CREATE INDEX Membership_partyExchIDX
    ON dbo.Membership(partyIDFK,exchangeRNFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Membership') AND name='Membership_partyExchIDX')
    PRINT '<<< CREATED INDEX dbo.Membership.Membership_partyExchIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Membership.Membership_partyExchIDX >>>'
go

CREATE INDEX XtnIDParty
    ON dbo.Party(tradingNameIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Party') AND name='XtnIDParty')
    PRINT '<<< CREATED INDEX dbo.Party.XtnIDParty >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Party.XtnIDParty >>>'
go

CREATE INDEX AtIDPIDRN
    ON dbo.PartyAttribute(attrNameRN,attrValueRN,partyIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartyAttribute') AND name='AtIDPIDRN')
    PRINT '<<< CREATED INDEX dbo.PartyAttribute.AtIDPIDRN >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartyAttribute.AtIDPIDRN >>>'
go

CREATE INDEX PAVVer
    ON dbo.PartyAttributeVer(versionID,partyAttributeID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartyAttributeVer') AND name='PAVVer')
    PRINT '<<< CREATED INDEX dbo.PartyAttributeVer.PAVVer >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartyAttributeVer.PAVVer >>>'
go

CREATE INDEX PartyHierarchy_parentIDX
    ON dbo.PartyHierarchy(parentPartyIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartyHierarchy') AND name='PartyHierarchy_parentIDX')
    PRINT '<<< CREATED INDEX dbo.PartyHierarchy.PartyHierarchy_parentIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartyHierarchy.PartyHierarchy_parentIDX >>>'
go

CREATE INDEX PartySite_tnlocX
    ON dbo.PartySite(tradingNameLocationIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartySite') AND name='PartySite_tnlocX')
    PRINT '<<< CREATED INDEX dbo.PartySite.PartySite_tnlocX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartySite.PartySite_tnlocX >>>'
go

CREATE INDEX partyIDFK
    ON dbo.PartySiteVer(partyIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartySiteVer') AND name='partyIDFK')
    PRINT '<<< CREATED INDEX dbo.PartySiteVer.partyIDFK >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartySiteVer.partyIDFK >>>'
go

CREATE INDEX replacementVersionID
    ON dbo.PartyVer(replacementVersionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartyVer') AND name='replacementVersionID')
    PRINT '<<< CREATED INDEX dbo.PartyVer.replacementVersionID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartyVer.replacementVersionID >>>'
go

CREATE INDEX versionID
    ON dbo.PostalAddress(versionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PostalAddress') AND name='versionID')
    PRINT '<<< CREATED INDEX dbo.PostalAddress.versionID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PostalAddress.versionID >>>'
go

CREATE INDEX replacementVersionID
    ON dbo.PostalAddressVer(replacementVersionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PostalAddressVer') AND name='replacementVersionID')
    PRINT '<<< CREATED INDEX dbo.PostalAddressVer.replacementVersionID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PostalAddressVer.replacementVersionID >>>'
go

CREATE INDEX accountSysNumRRlastUpdateTS
    ON dbo.RRParticipant(lastUpdateTS,accountNumber,accountSystemRN,rrIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.RRParticipant') AND name='accountSysNumRRlastUpdateTS')
    PRINT '<<< CREATED INDEX dbo.RRParticipant.accountSysNumRRlastUpdateTS >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.RRParticipant.accountSysNumRRlastUpdateTS >>>'
go

CREATE INDEX OpenDateAcctStatusIDX
    ON dbo.TAPSAccount(accountOpenDate,accountStatus)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSAccount') AND name='OpenDateAcctStatusIDX')
    PRINT '<<< CREATED INDEX dbo.TAPSAccount.OpenDateAcctStatusIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSAccount.OpenDateAcctStatusIDX >>>'
go

CREATE INDEX lastUpdateTS
    ON dbo.TAPSAccountVer(lastUpdateTS)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSAccountVer') AND name='lastUpdateTS')
    PRINT '<<< CREATED INDEX dbo.TAPSAccountVer.lastUpdateTS >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSAccountVer.lastUpdateTS >>>'
go

CREATE INDEX fullName
    ON dbo.TAPSGeneralAddress(mainAddressInd,accountNumber,accountSystemRN,fullName1,fullName2,fullName3,fullName4)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSGeneralAddress') AND name='fullName')
    PRINT '<<< CREATED INDEX dbo.TAPSGeneralAddress.fullName >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSGeneralAddress.fullName >>>'
go

CREATE INDEX packageId_idx
    ON dbo.TIDForm(packageId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TIDForm') AND name='packageId_idx')
    PRINT '<<< CREATED INDEX dbo.TIDForm.packageId_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TIDForm.packageId_idx >>>'
go

CREATE INDEX packageState_idx
    ON dbo.TIDPackage(packageState)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TIDPackage') AND name='packageState_idx')
    PRINT '<<< CREATED INDEX dbo.TIDPackage.packageState_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TIDPackage.packageState_idx >>>'
go

CREATE INDEX workgroupName_idx
    ON dbo.TIDUser(workgroupName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TIDUser') AND name='workgroupName_idx')
    PRINT '<<< CREATED INDEX dbo.TIDUser.workgroupName_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TIDUser.workgroupName_idx >>>'
go

CREATE INDEX workgroupName_idx
    ON dbo.TIDUserTest(workgroupName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TIDUserTest') AND name='workgroupName_idx')
    PRINT '<<< CREATED INDEX dbo.TIDUserTest.workgroupName_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TIDUserTest.workgroupName_idx >>>'
go

CREATE INDEX workgroupName_idx
    ON dbo.TIDWorkgroup(workgroupName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TIDWorkgroup') AND name='workgroupName_idx')
    PRINT '<<< CREATED INDEX dbo.TIDWorkgroup.workgroupName_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TIDWorkgroup.workgroupName_idx >>>'
go

CREATE INDEX TNDreplvid
    ON dbo.TNDAccountVer(replacementVersionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TNDAccountVer') AND name='TNDreplvid')
    PRINT '<<< CREATED INDEX dbo.TNDAccountVer.TNDreplvid >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TNDAccountVer.TNDreplvid >>>'
go

CREATE INDEX XIF3TNLBDOrderCapacity
    ON dbo.TNLBDOrderCapacity(orderCapacityCode,orderSubCapacityCode)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TNLBDOrderCapacity') AND name='XIF3TNLBDOrderCapacity')
    PRINT '<<< CREATED INDEX dbo.TNLBDOrderCapacity.XIF3TNLBDOrderCapacity >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TNLBDOrderCapacity.XIF3TNLBDOrderCapacity >>>'
go

CREATE INDEX TN_ultprntIDX
    ON dbo.TradingName(ultimatePrntTradingNameFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingName') AND name='TN_ultprntIDX')
    PRINT '<<< CREATED INDEX dbo.TradingName.TN_ultprntIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingName.TN_ultprntIDX >>>'
go

CREATE INDEX TNDIDTNIV
    ON dbo.TradingNameDefinitionDetail(TNDIdentifierIDFK,tradingNameIdentifierValue)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingNameDefinitionDetail') AND name='TNDIDTNIV')
    PRINT '<<< CREATED INDEX dbo.TradingNameDefinitionDetail.TNDIDTNIV >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingNameDefinitionDetail.TNDIDTNIV >>>'
go

CREATE INDEX TNLGeoLocation
    ON dbo.TradingNameLocation(geoLocationRNFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingNameLocation') AND name='TNLGeoLocation')
    PRINT '<<< CREATED INDEX dbo.TradingNameLocation.TNLGeoLocation >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingNameLocation.TNLGeoLocation >>>'
go

CREATE INDEX XIF2TradingNameLocBusDef
    ON dbo.TradingNameLocBusDef(tradingNameLocationID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingNameLocBusDef') AND name='XIF2TradingNameLocBusDef')
    PRINT '<<< CREATED INDEX dbo.TradingNameLocBusDef.XIF2TradingNameLocBusDef >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingNameLocBusDef.XIF2TradingNameLocBusDef >>>'
go

CREATE INDEX TNLBDCVVer
    ON dbo.TradingNameLocBusDefCoverageV(versionID,coverageGroupIDFK,tradingNameLocationIDFK,businessDefinitionIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingNameLocBusDefCoverageV') AND name='TNLBDCVVer')
    PRINT '<<< CREATED INDEX dbo.TradingNameLocBusDefCoverageV.TNLBDCVVer >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingNameLocBusDefCoverageV.TNLBDCVVer >>>'
go

CREATE INDEX lastUpdateTS
    ON dbo.UserUpdateAccount(lastUpdateTS)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.UserUpdateAccount') AND name='lastUpdateTS')
    PRINT '<<< CREATED INDEX dbo.UserUpdateAccount.lastUpdateTS >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.UserUpdateAccount.lastUpdateTS >>>'
go

CREATE INDEX mIDX
    ON dbo.workflow(employee_no_must_match)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.workflow') AND name='mIDX')
    PRINT '<<< CREATED INDEX dbo.workflow.mIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.workflow.mIDX >>>'
go

CREATE INDEX modifiedTS
    ON dbo.AccountIDTAPSAccount(modifiedTS)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountIDTAPSAccount') AND name='modifiedTS')
    PRINT '<<< CREATED INDEX dbo.AccountIDTAPSAccount.modifiedTS >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountIDTAPSAccount.modifiedTS >>>'
go

CREATE INDEX AccountParticipant_partyIDX
    ON dbo.AccountParticipant(partyIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountParticipant') AND name='AccountParticipant_partyIDX')
    PRINT '<<< CREATED INDEX dbo.AccountParticipant.AccountParticipant_partyIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountParticipant.AccountParticipant_partyIDX >>>'
go

CREATE UNIQUE INDEX IDX
    ON dbo.employeeType_response_rights(employeeTypeID,approve_employeeTypeID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.employeeType_response_rights') AND name='IDX')
    PRINT '<<< CREATED INDEX dbo.employeeType_response_rights.IDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.employeeType_response_rights.IDX >>>'
go

CREATE INDEX versionID
    ON dbo.Party(versionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Party') AND name='versionID')
    PRINT '<<< CREATED INDEX dbo.Party.versionID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Party.versionID >>>'
go

CREATE INDEX PAVer
    ON dbo.PartyAttribute(versionID,partyAttributeID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartyAttribute') AND name='PAVer')
    PRINT '<<< CREATED INDEX dbo.PartyAttribute.PAVer >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartyAttribute.PAVer >>>'
go

CREATE INDEX lastUpdateTS
    ON dbo.PartyAttributeVer(lastUpdateTS)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartyAttributeVer') AND name='lastUpdateTS')
    PRINT '<<< CREATED INDEX dbo.PartyAttributeVer.lastUpdateTS >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartyAttributeVer.lastUpdateTS >>>'
go

CREATE INDEX XptySitePartySite
    ON dbo.PartySite(partyIDFK,siteID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartySite') AND name='XptySitePartySite')
    PRINT '<<< CREATED INDEX dbo.PartySite.XptySitePartySite >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartySite.XptySitePartySite >>>'
go

CREATE INDEX RegionScopeStatusIDX
    ON dbo.TAPSAccount(darwinRegionRN,darwinManagedRN,accountStatus)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSAccount') AND name='RegionScopeStatusIDX')
    PRINT '<<< CREATED INDEX dbo.TAPSAccount.RegionScopeStatusIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSAccount.RegionScopeStatusIDX >>>'
go

CREATE INDEX acctID
    ON dbo.TAPSAccountVer(acctID,accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSAccountVer') AND name='acctID')
    PRINT '<<< CREATED INDEX dbo.TAPSAccountVer.acctID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSAccountVer.acctID >>>'
go

CREATE INDEX TAPSGeneralAddressFN1_IDX
    ON dbo.TAPSGeneralAddress(fullName1)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSGeneralAddress') AND name='TAPSGeneralAddressFN1_IDX')
    PRINT '<<< CREATED INDEX dbo.TAPSGeneralAddress.TAPSGeneralAddressFN1_IDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSGeneralAddress.TAPSGeneralAddressFN1_IDX >>>'
go

CREATE INDEX savedPackage_idx
    ON dbo.TIDPackage(savedPackageName,workgroupName,packageType)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TIDPackage') AND name='savedPackage_idx')
    PRINT '<<< CREATED INDEX dbo.TIDPackage.savedPackage_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TIDPackage.savedPackage_idx >>>'
go

CREATE UNIQUE INDEX XAK1TradingName
    ON dbo.TradingName(tradingName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingName') AND name='XAK1TradingName')
    PRINT '<<< CREATED INDEX dbo.TradingName.XAK1TradingName >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingName.XAK1TradingName >>>'
go

CREATE INDEX XIF3TradingNameLocBusDef
    ON dbo.TradingNameLocBusDef(orderExecCapacityInstructCode)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TradingNameLocBusDef') AND name='XIF3TradingNameLocBusDef')
    PRINT '<<< CREATED INDEX dbo.TradingNameLocBusDef.XIF3TradingNameLocBusDef >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TradingNameLocBusDef.XIF3TradingNameLocBusDef >>>'
go

CREATE INDEX acctID
    ON dbo.AccountIDTAPSAccount(acctID,accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountIDTAPSAccount') AND name='acctID')
    PRINT '<<< CREATED INDEX dbo.AccountIDTAPSAccount.acctID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountIDTAPSAccount.acctID >>>'
go

CREATE UNIQUE INDEX XacctIDSiteRole
    ON dbo.AccountParticipant(accountIDFK,siteIDFK,partyRoleRN)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountParticipant') AND name='XacctIDSiteRole')
    PRINT '<<< CREATED INDEX dbo.AccountParticipant.XacctIDSiteRole >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountParticipant.XacctIDSiteRole >>>'
go

CREATE INDEX PIDAtID
    ON dbo.PartyAttribute(partyIDFK,attrName,attrValue)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartyAttribute') AND name='PIDAtID')
    PRINT '<<< CREATED INDEX dbo.PartyAttribute.PIDAtID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartyAttribute.PIDAtID >>>'
go

CREATE INDEX XsiteDunsPartySite
    ON dbo.PartySite(dunsXref,siteID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartySite') AND name='XsiteDunsPartySite')
    PRINT '<<< CREATED INDEX dbo.PartySite.XsiteDunsPartySite >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartySite.XsiteDunsPartySite >>>'
go

CREATE INDEX ScopeStatusIDX
    ON dbo.TAPSAccount(darwinManagedRN,accountStatus)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSAccount') AND name='ScopeStatusIDX')
    PRINT '<<< CREATED INDEX dbo.TAPSAccount.ScopeStatusIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSAccount.ScopeStatusIDX >>>'
go

CREATE INDEX i1
    ON dbo.TAPSGeneralAddress(BOAddressInd,accountNumber,accountSystemRN,nameAddressSeqNum)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSGeneralAddress') AND name='i1')
    PRINT '<<< CREATED INDEX dbo.TAPSGeneralAddress.i1 >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSGeneralAddress.i1 >>>'
go

CREATE INDEX TIDPackage_TypeIDX
    ON dbo.TIDPackage(packageType)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TIDPackage') AND name='TIDPackage_TypeIDX')
    PRINT '<<< CREATED INDEX dbo.TIDPackage.TIDPackage_TypeIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TIDPackage.TIDPackage_TypeIDX >>>'
go

CREATE INDEX orderPlacerAliasForAccount
    ON dbo.AccountParticipant(orderPlacerAliasForAcct)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountParticipant') AND name='orderPlacerAliasForAccount')
    PRINT '<<< CREATED INDEX dbo.AccountParticipant.orderPlacerAliasForAccount >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountParticipant.orderPlacerAliasForAccount >>>'
go

CREATE INDEX PIDAtIDRN
    ON dbo.PartyAttribute(partyIDFK,attrNameRN,attrValueRN)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartyAttribute') AND name='PIDAtIDRN')
    PRINT '<<< CREATED INDEX dbo.PartyAttribute.PIDAtIDRN >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartyAttribute.PIDAtIDRN >>>'
go

CREATE INDEX XsiteTDBPartySite
    ON dbo.PartySite(tdbXref,siteID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartySite') AND name='XsiteTDBPartySite')
    PRINT '<<< CREATED INDEX dbo.PartySite.XsiteTDBPartySite >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartySite.XsiteTDBPartySite >>>'
go

CREATE INDEX acctDunsNumIDX
    ON dbo.TAPSAccount(accountDunsNumber,accountNumber,accountSystemRN)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSAccount') AND name='acctDunsNumIDX')
    PRINT '<<< CREATED INDEX dbo.TAPSAccount.acctDunsNumIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSAccount.acctDunsNumIDX >>>'
go

CREATE INDEX lastUpdateTS
    ON dbo.TAPSGeneralAddress(lastUpdateTS)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSGeneralAddress') AND name='lastUpdateTS')
    PRINT '<<< CREATED INDEX dbo.TAPSGeneralAddress.lastUpdateTS >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSGeneralAddress.lastUpdateTS >>>'
go

CREATE INDEX workgrouppackage_idx
    ON dbo.TIDPackage(workgroupName,packageType)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TIDPackage') AND name='workgrouppackage_idx')
    PRINT '<<< CREATED INDEX dbo.TIDPackage.workgrouppackage_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TIDPackage.workgrouppackage_idx >>>'
go

CREATE INDEX versionID
    ON dbo.AccountParticipant(versionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountParticipant') AND name='versionID')
    PRINT '<<< CREATED INDEX dbo.AccountParticipant.versionID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountParticipant.versionID >>>'
go

CREATE INDEX lastUpdateTS
    ON dbo.PartyAttribute(lastUpdateTS)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartyAttribute') AND name='lastUpdateTS')
    PRINT '<<< CREATED INDEX dbo.PartyAttribute.lastUpdateTS >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartyAttribute.lastUpdateTS >>>'
go

CREATE INDEX creationTS
    ON dbo.PartySite(creationTS)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartySite') AND name='creationTS')
    PRINT '<<< CREATED INDEX dbo.PartySite.creationTS >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartySite.creationTS >>>'
go

CREATE INDEX acctLastUpdateTSIDX
    ON dbo.TAPSAccount(lastUpdateTS)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSAccount') AND name='acctLastUpdateTSIDX')
    PRINT '<<< CREATED INDEX dbo.TAPSAccount.acctLastUpdateTSIDX >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSAccount.acctLastUpdateTSIDX >>>'
go

CREATE INDEX TKTrustFundNumber
    ON dbo.AccountParticipant(TKTrustFundNumber,accountIDFK,partyIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountParticipant') AND name='TKTrustFundNumber')
    PRINT '<<< CREATED INDEX dbo.AccountParticipant.TKTrustFundNumber >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountParticipant.TKTrustFundNumber >>>'
go

CREATE INDEX versionID
    ON dbo.PartySite(versionID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartySite') AND name='versionID')
    PRINT '<<< CREATED INDEX dbo.PartySite.versionID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartySite.versionID >>>'
go

CREATE INDEX glCoSubStatusScopeRegion
    ON dbo.TAPSAccount(glCoSub,accountStatus,darwinManagedRN,darwinRegionRN)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSAccount') AND name='glCoSubStatusScopeRegion')
    PRINT '<<< CREATED INDEX dbo.TAPSAccount.glCoSubStatusScopeRegion >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSAccount.glCoSubStatusScopeRegion >>>'
go

CREATE INDEX postalAddressIDFK
    ON dbo.PartySite(postalAddressIDFK)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PartySite') AND name='postalAddressIDFK')
    PRINT '<<< CREATED INDEX dbo.PartySite.postalAddressIDFK >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PartySite.postalAddressIDFK >>>'
go

CREATE INDEX acctID
    ON dbo.TAPSAccount(acctID,accountID)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSAccount') AND name='acctID')
    PRINT '<<< CREATED INDEX dbo.TAPSAccount.acctID >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSAccount.acctID >>>'
go

CREATE INDEX ii2
    ON dbo.TAPSAccount(specificAccountUsageRN,specificAccountUsageCode)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSAccount') AND name='ii2')
    PRINT '<<< CREATED INDEX dbo.TAPSAccount.ii2 >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSAccount.ii2 >>>'
go

CREATE INDEX ii1
    ON dbo.TAPSAccount(generalAccountUsageRN,generalAccountUsageCode)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSAccount') AND name='ii1')
    PRINT '<<< CREATED INDEX dbo.TAPSAccount.ii1 >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSAccount.ii1 >>>'
go

CREATE INDEX accountshortNameIndex
    ON dbo.TAPSAccount(shortName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TAPSAccount') AND name='accountshortNameIndex')
    PRINT '<<< CREATED INDEX dbo.TAPSAccount.accountshortNameIndex >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TAPSAccount.accountshortNameIndex >>>'
go
