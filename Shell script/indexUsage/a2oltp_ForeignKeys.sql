ALTER TABLE Accounts.TIDFavorite
    ADD CONSTRAINT TIDFavorit_798219163
    FOREIGN KEY (msdwUserId)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.AccountGroup
    ADD CONSTRAINT AccountGro_847599327
    FOREIGN KEY (externalIndRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AccountGroup
    ADD CONSTRAINT AccountGro_863599384
    FOREIGN KEY (divisionRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AccountGroup
    ADD CONSTRAINT AccountGro_879599441
    FOREIGN KEY (parentAccountGroupIDFK)
    REFERENCES dbo.AccountGroup (accountGroupID)
go

ALTER TABLE dbo.AccountGroupAttribute
    ADD CONSTRAINT AccountGro_1071600125
    FOREIGN KEY (attributeNameFK,attributeValueFK)
    REFERENCES dbo.AccountGroupAttributeLU (attributeName,attributeValue)
go

ALTER TABLE dbo.AccountGroupAttribute
    ADD CONSTRAINT AccountGro_1087600182
    FOREIGN KEY (accountGroupIDFK)
    REFERENCES dbo.AccountGroup (accountGroupID)
go

ALTER TABLE dbo.AccountGroupType
    ADD CONSTRAINT AccountGro_975599783
    FOREIGN KEY (accountGroupTypeFK)
    REFERENCES dbo.AccountGroupTypeLU (accountGroupType)
go

ALTER TABLE dbo.AccountGroupType
    ADD CONSTRAINT AccountGro_991599840
    FOREIGN KEY (accountGroupIDFK)
    REFERENCES dbo.AccountGroup (accountGroupID)
go

ALTER TABLE dbo.AccountingUsageLU
    ADD CONSTRAINT AccountingUsageLU_genAcctUsg
    FOREIGN KEY (generalAccountUsageRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AccountingUsageLU
    ADD CONSTRAINT AccountingUsageLU_spAcctUsg
    FOREIGN KEY (specificAccountUsageRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AccountingUsageLU_tmp
    ADD CONSTRAINT AccountingUsageLU_tmp_genAU
    FOREIGN KEY (generalAccountUsageRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AccountingUsageLU_tmp
    ADD CONSTRAINT AccountingUsageLU_tmp_spAU
    FOREIGN KEY (specificAccountUsageRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AccountParticipant
    ADD CONSTRAINT AccountPar_1150884386
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.AccountParticipant
    ADD CONSTRAINT AccountPar_1166884443
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.AccountParticipant
    ADD CONSTRAINT AccountPar_1198884557
    FOREIGN KEY (partyRoleRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AccountParticipant
    ADD CONSTRAINT AccountPar_1214884614
    FOREIGN KEY (accountIDFK)
    REFERENCES dbo.DarwinAccount (accountID)
go

ALTER TABLE dbo.AccountParticipant
    ADD CONSTRAINT AccountPar_610462568
    FOREIGN KEY (partyIDFK)
    REFERENCES dbo.Party (partyID)
go

ALTER TABLE dbo.AccountParticipant
    ADD CONSTRAINT AccountPar_626462625
    FOREIGN KEY (siteIDFK)
    REFERENCES dbo.PartySite (siteID)
go

ALTER TABLE dbo.AccountProduct
    ADD CONSTRAINT AccountPro_626358515
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.AccountProduct
    ADD CONSTRAINT AccountPro_642358572
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.AccountProduct
    ADD CONSTRAINT AccountPro_658358629
    FOREIGN KEY (accountAgreementRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AccountProduct
    ADD CONSTRAINT AccountPro_674358686
    FOREIGN KEY (specificProductRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AccountProduct
    ADD CONSTRAINT AccountPro_690358743
    FOREIGN KEY (generalProductRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AccountProduct
    ADD CONSTRAINT AccountPro_706358800
    FOREIGN KEY (accountIDFK)
    REFERENCES dbo.DarwinAccount (accountID)
go

ALTER TABLE dbo.AccountQIBApprovalSource
    ADD CONSTRAINT AcctQIBApprSr_acctID
    FOREIGN KEY (accountIDFK)
    REFERENCES dbo.AccountQIBQP (accountIDFK)
go

ALTER TABLE dbo.AccountQIBApprovalSource
    ADD CONSTRAINT AcctQIBApprSr_qibApprSrRN
    FOREIGN KEY (qibApprovalSourceRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AccountQIBQP
    ADD CONSTRAINT AccountQIB_1424981372
    FOREIGN KEY (qibIndRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AccountQIBQP
    ADD CONSTRAINT AccountQIB_1440981429
    FOREIGN KEY (qpIndRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AccountQIBQP
    ADD CONSTRAINT AccountQIB_1456981486
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.AccountQIBQP
    ADD CONSTRAINT AccountQIB_1472981543
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.AccountQIBQP
    ADD CONSTRAINT AccountQIB_1488981600
    FOREIGN KEY (accountIDFK)
    REFERENCES dbo.DarwinAccount (accountID)
go

ALTER TABLE dbo.AccountQPApprovalSource
    ADD CONSTRAINT AcctQPApprSr_acctID
    FOREIGN KEY (accountIDFK)
    REFERENCES dbo.AccountQIBQP (accountIDFK)
go

ALTER TABLE dbo.AccountQPApprovalSource
    ADD CONSTRAINT AcctQPApprSr_qpApprSrRN
    FOREIGN KEY (qpApprovalSourceRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AccountTaxEligibility
    ADD CONSTRAINT AccountTax_1874362961
    FOREIGN KEY (taxEligibilityRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AccountTaxEligibility
    ADD CONSTRAINT AccountTax_1890363018
    FOREIGN KEY (taxEligibilityTypeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AccountTaxEligibility
    ADD CONSTRAINT AccountTax_1906363075
    FOREIGN KEY (countryRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AccountTaxEligibility
    ADD CONSTRAINT AccountTax_1922363132
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.AccountTaxEligibility
    ADD CONSTRAINT AccountTax_1938363189
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.AcctBulkKSENumber
    ADD CONSTRAINT AcctBulkKS_1912755236
    FOREIGN KEY (principalPartyID,orderPlacerPartyID,accountID)
    REFERENCES dbo.KoreanStockExchangeAccount (principalPartyID,orderPlacerPartyID,accountID)
go

ALTER TABLE dbo.AcctGroupCoverageGroup
    ADD CONSTRAINT AcctGroupC_124120752
    FOREIGN KEY (validIndRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AcctGroupCoverageGroup
    ADD CONSTRAINT AcctGroupC_396121721
    FOREIGN KEY (accountGroupIDFK)
    REFERENCES dbo.AccountGroup (accountGroupID)
go

ALTER TABLE dbo.AcctGroupTAPSAcct
    ADD CONSTRAINT AcctGroupT_927599612
    FOREIGN KEY (accountGroupIDFK)
    REFERENCES dbo.AccountGroup (accountGroupID)
go

ALTER TABLE dbo.AttributeValidation
    ADD CONSTRAINT AttributeV_1743602519
    FOREIGN KEY (validationStatusRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AttributeValidation
    ADD CONSTRAINT AttributeV_1759602576
    FOREIGN KEY (validationSourceRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.AttributeValidation
    ADD CONSTRAINT AttributeV_1775602633
    FOREIGN KEY (creatorUserLoginFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.AttributeValidation
    ADD CONSTRAINT AttributeV_1791602690
    FOREIGN KEY (validatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.AttributeValidation
    ADD CONSTRAINT AttributeV_1807602747
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.BDBrokerCode
    ADD CONSTRAINT BDBrokerCo_1852126908
    FOREIGN KEY (brokerCodeIssuer,brokerID)
    REFERENCES dbo.BrokerCode (brokerCodeIssuer,brokerID)
go

ALTER TABLE dbo.BDBrokerCode
    ADD CONSTRAINT BDBrokerCo_1868126965
    FOREIGN KEY (brokerRelationshipType)
    REFERENCES dbo.BrokerRelationshipType (brokerRelationshipType)
go

ALTER TABLE dbo.BDBrokerCode
    ADD CONSTRAINT BDBrokerCo_1884127022
    FOREIGN KEY (businessDefinitionID)
    REFERENCES dbo.BusinessDefinition (businessDefinitionID)
go

ALTER TABLE dbo.BDBrokerCodeAcct
    ADD CONSTRAINT BDBrokerCo_2035183665
    FOREIGN KEY (accountNumber,accountSystemRN)
    REFERENCES dbo.TAPSAccount (accountNumber,accountSystemRN)
go

ALTER TABLE dbo.BDBrokerCodeAcct
    ADD CONSTRAINT BDBrokerCo_700226914
    FOREIGN KEY (businessDefinitionID,brokerID,brokerCodeIssuer,brokerRelationshipType)
    REFERENCES dbo.BDBrokerCode (businessDefinitionID,brokerID,brokerCodeIssuer,brokerRelationshipType)
go

ALTER TABLE dbo.BrokerAccount
    ADD CONSTRAINT BrokerAcco_1875183095
    FOREIGN KEY (accountNumber,accountSystemRN)
    REFERENCES dbo.TAPSAccount (accountNumber,accountSystemRN)
go

ALTER TABLE dbo.BrokerAccount
    ADD CONSTRAINT BrokerAcco_1891183152
    FOREIGN KEY (brokerID)
    REFERENCES dbo.Broker (brokerID)
go

ALTER TABLE dbo.BrokerCode
    ADD CONSTRAINT BrokerCode_1692126338
    FOREIGN KEY (brokerCodeIssuer)
    REFERENCES dbo.BrokerCodeIssuer (brokerCodeIssuer)
go

ALTER TABLE dbo.BrokerCode
    ADD CONSTRAINT BrokerCode_1708126395
    FOREIGN KEY (brokerID)
    REFERENCES dbo.Broker (brokerID)
go

ALTER TABLE dbo.BusinessDefAccount
    ADD CONSTRAINT BusinessDe_1090360168
    FOREIGN KEY (businessDefinitionIDFK)
    REFERENCES dbo.BusinessDefinition (businessDefinitionID)
go

ALTER TABLE dbo.BusinessDefinition
    ADD CONSTRAINT BusinessDe_489310022
    FOREIGN KEY (creatorUserLoginFK)
    REFERENCES dbo.TNUser (tnUserLogin)
go

ALTER TABLE dbo.BusinessDefinition
    ADD CONSTRAINT BusinessDe_505310079
    FOREIGN KEY (lastUpdaterUserLoginFK)
    REFERENCES dbo.TNUser (tnUserLogin)
go

ALTER TABLE dbo.BusinessDefinition
    ADD CONSTRAINT BusinessDe_521310136
    FOREIGN KEY (divisionRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT BusinessDe_1001311846
    FOREIGN KEY (businessDefinitionIDFK)
    REFERENCES dbo.BusinessDefinition (businessDefinitionID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT BusinessDe_1017311903
    FOREIGN KEY (transactionTypeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT BusinessDe_1033311960
    FOREIGN KEY (exchangeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT BusinessDe_1049312017
    FOREIGN KEY (businessCapacityRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT BusinessDe_400977724
    FOREIGN KEY (regulatoryAllowanceRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT BusinessDe_416977781
    FOREIGN KEY (subUnderlyingPrTypeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT BusinessDe_432977838
    FOREIGN KEY (tradeBusLineFirstTierRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT BusinessDe_448977895
    FOREIGN KEY (tradeBusLineSecondTierRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT BusinessDe_464977952
    FOREIGN KEY (tradeBusLineThirdTierRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT BusinessDe_480978009
    FOREIGN KEY (traderBusLineOfficeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT BusinessDe_496978066
    FOREIGN KEY (traderBusLineRegionRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT businessde_512978123
    FOREIGN KEY (outOfCurrencyRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT businessde_528978180
    FOREIGN KEY (settlementCcyRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT businessde_544978237
    FOREIGN KEY (shortSellStrategyRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT BusinessDe_889311447
    FOREIGN KEY (businessLineOfficeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT BusinessDe_905311504
    FOREIGN KEY (countryOfIssuerRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT BusinessDe_921311561
    FOREIGN KEY (countryOfIssueRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT BusinessDe_937311618
    FOREIGN KEY (underlyingProductRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT BusinessDe_953311675
    FOREIGN KEY (productRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT BusinessDe_969311732
    FOREIGN KEY (businessLineRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionDetail
    ADD CONSTRAINT BusinessDe_985311789
    FOREIGN KEY (businessLineRegionRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionFilter
    ADD CONSTRAINT BusinessDe_1097312188
    FOREIGN KEY (lastUpdaterUserLoginFK)
    REFERENCES dbo.TNUser (tnUserLogin)
go

ALTER TABLE dbo.BusinessDefinitionFilter
    ADD CONSTRAINT BusinessDe_1113312245
    FOREIGN KEY (creatorUserLoginFK)
    REFERENCES dbo.TNUser (tnUserLogin)
go

ALTER TABLE dbo.BusinessDefinitionFilter
    ADD CONSTRAINT BusinessDe_1129312302
    FOREIGN KEY (filterRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.BusinessDefinitionFilter
    ADD CONSTRAINT BusinessDe_1145312359
    FOREIGN KEY (businessDefinitionIDFK)
    REFERENCES dbo.BusinessDefinition (businessDefinitionID)
go

ALTER TABLE dbo.BusinessDefinitionType
    ADD CONSTRAINT BusinessDe_55879466
    FOREIGN KEY (parentBusDefTypeRN)
    REFERENCES dbo.BusinessDefinitionType (busDefTypeRN)
go

ALTER TABLE dbo.BusinessDefinitionTypeAttr
    ADD CONSTRAINT BusinessDe_103879637
    FOREIGN KEY (busDefTypeRN)
    REFERENCES dbo.BusinessDefinitionType (busDefTypeRN)
go

ALTER TABLE dbo.CIPGrandFatheredBookCompLU
    ADD CONSTRAINT CIPGrandFatheredBookCompLU_GrN
    FOREIGN KEY (CIPgroupNumFK)
    REFERENCES dbo.CIPGrandFatheredGroupLU (CIPgroupNum)
go

ALTER TABLE dbo.ClearingBrokerReference
    ADD CONSTRAINT ClearingBr_531074197
    FOREIGN KEY (exchangeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.ClearingBrokerReference
    ADD CONSTRAINT ClearingBr_547074254
    FOREIGN KEY (genericBrokerCode)
    REFERENCES dbo.GenericBrokerLU (genericBrokerCode)
go

ALTER TABLE dbo.ClearingBrokerReference
    ADD CONSTRAINT ClearingBr_563074311
    FOREIGN KEY (accountID)
    REFERENCES dbo.DarwinAccount (accountID)
go

ALTER TABLE dbo.ClearingBrokerReference
    ADD CONSTRAINT ClearingBr_579074368
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.ClearingBrokerReference
    ADD CONSTRAINT ClearingBr_595074425
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.ClientProfileDBColumn
    ADD CONSTRAINT ClientProf_1269172836
    FOREIGN KEY (clientProfileID)
    REFERENCES dbo.ClientProfile (clientProfileID)
go

ALTER TABLE dbo.ClientProfileGUIAttribute
    ADD CONSTRAINT ClientProf_1349173121
    FOREIGN KEY (clientProfileID)
    REFERENCES dbo.ClientProfile (clientProfileID)
go

ALTER TABLE dbo.ClientProfileStoredProc
    ADD CONSTRAINT ClientProf_1285172893
    FOREIGN KEY (clientProfileID)
    REFERENCES dbo.ClientProfile (clientProfileID)
go

ALTER TABLE dbo.CommissionCategory
    ADD CONSTRAINT Commission_1388125255
    FOREIGN KEY (businessDefinitionIDFK)
    REFERENCES dbo.BusinessDefinition (businessDefinitionID)
go

ALTER TABLE dbo.CommissionCategory
    ADD CONSTRAINT Commission_1404125312
    FOREIGN KEY (commissionCategoryRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.CommissionCategory
    ADD CONSTRAINT Commission_1420125369
    FOREIGN KEY (tradingNameLocationIDFK)
    REFERENCES dbo.TradingNameLocation (tradingNameLocationID)
go

ALTER TABLE dbo.ComplianceCoverageGroupEmpl
    ADD CONSTRAINT ComplianceCoverageGroupEmpl_ID
    FOREIGN KEY (complianceEventID)
    REFERENCES dbo.ComplianceEvent (complianceEventID)
go

ALTER TABLE dbo.DarwinAccount
    ADD CONSTRAINT DarwinAcco_1765838572
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.DarwinAccount
    ADD CONSTRAINT DarwinAcco_1781838629
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.DarwinAccount
    ADD CONSTRAINT DarwinAcco_1797838686
    FOREIGN KEY (accountSystemRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.DarwinTkAccount
    ADD CONSTRAINT DarwinTkAc_1111932252
    FOREIGN KEY (discretionaryAcctRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.DarwinTkAccount
    ADD CONSTRAINT DarwinTkAc_1127932309
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.DarwinTkAccount
    ADD CONSTRAINT DarwinTkAc_1143932366
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.DarwinTkAccount
    ADD CONSTRAINT DarwinTkAc_1159932423
    FOREIGN KEY (limitedRecourseIndRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.DarwinTkAccount
    ADD CONSTRAINT DarwinTkAc_1175932480
    FOREIGN KEY (trustBankRelTypeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.DarwinTkAccount
    ADD CONSTRAINT DarwinTkAc_1191932537
    FOREIGN KEY (trustBankAcctTypeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.DarwinTkAccount
    ADD CONSTRAINT DarwinTkAc_1207932594
    FOREIGN KEY (trustFundTypeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.DarwinTkAccount
    ADD CONSTRAINT DarwinTkAc_1223932651
    FOREIGN KEY (accountIDFK)
    REFERENCES dbo.DarwinAccount (accountID)
go

ALTER TABLE dbo.DarwinTkAccount
    ADD CONSTRAINT DarwinTkAc_1239932708
    FOREIGN KEY (investmentObjectiveRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.DarwinTradedProduct
    ADD CONSTRAINT DarwinTrad_2021839484
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.DarwinTradedProduct
    ADD CONSTRAINT DarwinTrad_2037839541
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.DarwinTradedProduct
    ADD CONSTRAINT DarwinTrad_2053839598
    FOREIGN KEY (jpnProductTradedRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.DarwinTradedProduct
    ADD CONSTRAINT DarwinTrad_2069839655
    FOREIGN KEY (accountIDFK)
    REFERENCES dbo.DarwinAccount (accountID)
go

ALTER TABLE dbo.E3RGUGEntitlements
    ADD CONSTRAINT FK1_RGUGEntitlements
    FOREIGN KEY (actionGroupName,actionName)
    REFERENCES dbo.E3ActionsToActionGroups (actionGroupName,actionName)
go

ALTER TABLE dbo.ExceptionAction
    ADD CONSTRAINT ExceptionAction_exceptID
    FOREIGN KEY (exceptionID)
    REFERENCES dbo.ExceptionEvent (exceptionID)
go

ALTER TABLE dbo.ExceptionAction
    ADD CONSTRAINT ExceptionAction_resCode
    FOREIGN KEY (resolutionCode)
    REFERENCES dbo.ExceptionResolutionCodeLU (resolutionCode)
go

ALTER TABLE dbo.ExceptionPartySite
    ADD CONSTRAINT ExceptionPartySite_exceptID
    FOREIGN KEY (exceptionID)
    REFERENCES dbo.ExceptionEvent (exceptionID)
go

ALTER TABLE dbo.Exchange
    ADD CONSTRAINT Exchange_18356349
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.Exchange
    ADD CONSTRAINT Exchange_34356406
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.Exchange
    ADD CONSTRAINT Exchange_50356463
    FOREIGN KEY (countryRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Exchange
    ADD CONSTRAINT Exchange_66356520
    FOREIGN KEY (exchangeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.GeoLocation
    ADD CONSTRAINT GeoLocatio_1653838173
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.GeoLocation
    ADD CONSTRAINT GeoLocatio_1669838230
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.GeoLocation
    ADD CONSTRAINT GeoLocatio_1685838287
    FOREIGN KEY (geoParentIDFK)
    REFERENCES dbo.GeoLocation (geoLocationRN)
go

ALTER TABLE dbo.GeoLocation
    ADD CONSTRAINT GeoLocatio_1701838344
    FOREIGN KEY (geoLevelRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.GeoLocation
    ADD CONSTRAINT GeoLocatio_1717838401
    FOREIGN KEY (geoLocationRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.IdentificationDocument
    ADD CONSTRAINT Identifica_2082363702
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.IdentificationDocument
    ADD CONSTRAINT Identifica_2098363759
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.IdentificationDocument
    ADD CONSTRAINT Identifica_2114363816
    FOREIGN KEY (jpnDocumentTypeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.IdentificationDocument
    ADD CONSTRAINT Identifica_562462397
    FOREIGN KEY (partyIDFK)
    REFERENCES dbo.Party (partyID)
go

ALTER TABLE dbo.InvestmentExperience
    ADD CONSTRAINT Investment_1986363360
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.InvestmentExperience
    ADD CONSTRAINT Investment_2002363417
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.InvestmentExperience
    ADD CONSTRAINT Investment_2018363474
    FOREIGN KEY (jpnInvestExperienceTypeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.InvestmentExperience
    ADD CONSTRAINT Investment_482462112
    FOREIGN KEY (partyIDFK)
    REFERENCES dbo.Party (partyID)
go

ALTER TABLE dbo.JapanTradedProduct
    ADD CONSTRAINT JapanTrade_1287932879
    FOREIGN KEY (accountIDFK)
    REFERENCES dbo.DarwinTkAccount (accountIDFK)
go

ALTER TABLE dbo.JapanTradedProduct
    ADD CONSTRAINT JapanTrade_1303932936
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.JapanTradedProduct
    ADD CONSTRAINT JapanTrade_1319932993
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.JapanTradedProduct
    ADD CONSTRAINT JapanTrade_1335933050
    FOREIGN KEY (jpnTradedProductRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.KoreanPartyAccount
    ADD CONSTRAINT KoreanPart_1196124571
    FOREIGN KEY (accountSystemRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.KoreanPartyAccount
    ADD CONSTRAINT KoreanPart_1212124628
    FOREIGN KEY (accountID)
    REFERENCES dbo.DarwinAccount (accountID)
go

ALTER TABLE dbo.KoreanPartyAccount
    ADD CONSTRAINT KoreanPart_578462454
    FOREIGN KEY (orderPlacerID)
    REFERENCES dbo.Party (partyID)
go

ALTER TABLE dbo.KoreanPartyAccount
    ADD CONSTRAINT KoreanPart_594462511
    FOREIGN KEY (principalID)
    REFERENCES dbo.Party (partyID)
go

ALTER TABLE dbo.KoreanStockExchangeAccount
    ADD CONSTRAINT acctID
    FOREIGN KEY (accountID)
    REFERENCES dbo.DarwinAccount (accountID)
go

ALTER TABLE dbo.KoreanStockExchangeAccount
    ADD CONSTRAINT acctSystem
    FOREIGN KEY (accountSystemRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Membership
    ADD CONSTRAINT Membership_1406885298
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.Membership
    ADD CONSTRAINT Membership_1422885355
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.Membership
    ADD CONSTRAINT Membership_1438885412
    FOREIGN KEY (partyIDFK,exchangeRNFK)
    REFERENCES dbo.PartyExchange (partyIDFK,exchangeRNFK)
go

ALTER TABLE dbo.Membership
    ADD CONSTRAINT Membership_1454885469
    FOREIGN KEY (exchangeMembershipTypeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.MSIdentifier
    ADD CONSTRAINT MSIdentifi_405833727
    FOREIGN KEY (businessProcessRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.MSIdentifier
    ADD CONSTRAINT MSIdentifi_421833784
    FOREIGN KEY (clientIdentifierTypeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.MSIdentifier
    ADD CONSTRAINT MSIdentifi_437833841
    FOREIGN KEY (businessDefinitionID)
    REFERENCES dbo.BusinessDefinition (businessDefinitionID)
go

ALTER TABLE dbo.ObjectRestriction
    ADD CONSTRAINT ObjectRestriction_ID
    FOREIGN KEY (complianceEventID)
    REFERENCES dbo.ComplianceEvent (complianceEventID)
go

ALTER TABLE dbo.ObjectRestrictionColumn
    ADD CONSTRAINT ObjectRestrictionColumn_table
    FOREIGN KEY (tableID)
    REFERENCES dbo.ObjectRestrictionTable (tableID)
go

ALTER TABLE dbo.ObjectRestrictionTable
    ADD CONSTRAINT ObjectRestrictionTable_ID
    FOREIGN KEY (objectRestrictionID)
    REFERENCES dbo.ObjectRestriction (objectRestrictionID)
go

ALTER TABLE dbo.OrderCapacityCodeCombination
    ADD CONSTRAINT OrderCapac_1203076591
    FOREIGN KEY (orderCapacityCode)
    REFERENCES dbo.OrderCapacityCode (orderCapacityCode)
go

ALTER TABLE dbo.OrderCapacityCodeCombination
    ADD CONSTRAINT OrderCapac_1219076648
    FOREIGN KEY (orderSubCapacityCode)
    REFERENCES dbo.OrderSubCapacityCode (orderSubCapacityCode)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1330361023
    FOREIGN KEY (mlDocumentsAccountIDFK)
    REFERENCES dbo.DarwinAccount (accountID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1346361080
    FOREIGN KEY (mlRegulatedJurisdictionRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1362361137
    FOREIGN KEY (mlSFAcustClassRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1378361194
    FOREIGN KEY (mlTransProvisRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1394361251
    FOREIGN KEY (mlBlanketIntermediaryLetterRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1410361308
    FOREIGN KEY (mlNoExemptionsRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1426361365
    FOREIGN KEY (mlApprovedExchangeListedRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1442361422
    FOREIGN KEY (mlInterimUndrlPrincRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1458361479
    FOREIGN KEY (mlFullyCertifiedRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1474361536
    FOREIGN KEY (mlTempCertifiedRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1490361593
    FOREIGN KEY (mlFATFcredFinRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1506361650
    FOREIGN KEY (issuerRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1522361707
    FOREIGN KEY (mlEEAcredFinRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1538361764
    FOREIGN KEY (mlBestExecutionRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1554361821
    FOREIGN KEY (jpnDesigFinancialInstRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1570361878
    FOREIGN KEY (UKRegCapacityClassificationRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1586361935
    FOREIGN KEY (localJurisdictionRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1602361992
    FOREIGN KEY (capacityClassificationRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1618362049
    FOREIGN KEY (legalFormRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1634362106
    FOREIGN KEY (countryOfJurisdictionRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1650362163
    FOREIGN KEY (UKFSACustomerClassificationRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1666362220
    FOREIGN KEY (validationSourceRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1682362277
    FOREIGN KEY (partyValidationStatusRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1698362334
    FOREIGN KEY (erisaIndicatorRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1714362391
    FOREIGN KEY (mlPre1994RN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1730362448
    FOREIGN KEY (mlCertifiedByUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1746362505
    FOREIGN KEY (validatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1762362562
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1778362619
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1794362676
    FOREIGN KEY (tradingNameIDFK)
    REFERENCES dbo.TradingName (tradingNameID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1810362733
    FOREIGN KEY (jpnCustomerIntroductionRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_1826362790
    FOREIGN KEY (eligibleInvestorIndRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.Party
    ADD CONSTRAINT Party_CIPgroupNum
    FOREIGN KEY (CIPgrandFatheredGroupNumFK)
    REFERENCES dbo.CIPGrandFatheredGroupLU (CIPgroupNum)
go

ALTER TABLE dbo.PartyAlias
    ADD CONSTRAINT PartyAlias_514462226
    FOREIGN KEY (partyIDFK)
    REFERENCES dbo.Party (partyID)
go

ALTER TABLE dbo.PartyAlias
    ADD CONSTRAINT PartyAlias_654882619
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.PartyAlias
    ADD CONSTRAINT PartyAlias_670882676
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.PartyAttribute
    ADD CONSTRAINT PartyAttri_1736754609
    FOREIGN KEY (partyIDFK)
    REFERENCES dbo.Party (partyID)
go

ALTER TABLE dbo.PartyConfirmSettlement
    ADD CONSTRAINT PartyConfSettl_assets
    FOREIGN KEY (assetsUnderManagementRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.PartyConfirmSettlement
    ADD CONSTRAINT PartyConfSettl_rateNotice
    FOREIGN KEY (ratingNoticeOptInRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.PartyConfirmSettlement
    ADD CONSTRAINT PartyConfSettl_tradeNotice
    FOREIGN KEY (tradeNoticeOptInRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.PartyContact
    ADD CONSTRAINT PartyConta_450461998
    FOREIGN KEY (partyIDFK)
    REFERENCES dbo.Party (partyID)
go

ALTER TABLE dbo.PartyContact
    ADD CONSTRAINT PartyConta_734882904
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.PartyContact
    ADD CONSTRAINT PartyConta_750882961
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.PartyDocRelation
    ADD CONSTRAINT PartyDocRe_370461713
    FOREIGN KEY (partyIDFK)
    REFERENCES dbo.Party (partyID)
go

ALTER TABLE dbo.PartyExchange
    ADD CONSTRAINT PartyExcha_466462055
    FOREIGN KEY (partyIDFK)
    REFERENCES dbo.Party (partyID)
go

ALTER TABLE dbo.PartyExchange
    ADD CONSTRAINT PartyExcha_814883189
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.PartyExchange
    ADD CONSTRAINT PartyExcha_830883246
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.PartyExchange
    ADD CONSTRAINT PartyExcha_846883303
    FOREIGN KEY (exchangeRNFK)
    REFERENCES dbo.Exchange (exchangeRN)
go

ALTER TABLE dbo.PartyExchangeListing
    ADD CONSTRAINT PartyExcha_1036124001
    FOREIGN KEY (exchangeListedIndRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.PartyExchangeListing
    ADD CONSTRAINT PartyExcha_546462340
    FOREIGN KEY (partyIDFK)
    REFERENCES dbo.Party (partyID)
go

ALTER TABLE dbo.PartyHierarchy
    ADD CONSTRAINT PartyHiera_386461770
    FOREIGN KEY (parentPartyIDFK)
    REFERENCES dbo.Party (partyID)
go

ALTER TABLE dbo.PartyHierarchy
    ADD CONSTRAINT PartyHiera_402461827
    FOREIGN KEY (childPartyIDFK)
    REFERENCES dbo.Party (partyID)
go

ALTER TABLE dbo.PartyHierarchy
    ADD CONSTRAINT PartyHiera_910883531
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.PartyHierarchy
    ADD CONSTRAINT PartyHiera_926883588
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.PartyHierarchy
    ADD CONSTRAINT PartyHiera_942883645
    FOREIGN KEY (overrideRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.PartyHierarchy
    ADD CONSTRAINT PartyHiera_958883702
    FOREIGN KEY (partyHierarchyTypeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.PartyQIBApprovalSource
    ADD CONSTRAINT PartyQIBApprSr_partyID
    FOREIGN KEY (partyIDFK,partyAs)
    REFERENCES dbo.PartyQIBQP (partyIDFK,partyAs)
go

ALTER TABLE dbo.PartyQIBApprovalSource
    ADD CONSTRAINT PartyQIBApprSr_qibApprSrRN
    FOREIGN KEY (qibApprovalSourceRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.PartyQIBQP
    ADD CONSTRAINT PartyQIBQP_1648982170
    FOREIGN KEY (qibIndRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.PartyQIBQP
    ADD CONSTRAINT PartyQIBQP_1664982227
    FOREIGN KEY (qpIndRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.PartyQIBQP
    ADD CONSTRAINT PartyQIBQP_1728982455
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.PartyQIBQP
    ADD CONSTRAINT PartyQIBQP_1744982512
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.PartyQIBQP
    ADD CONSTRAINT PartyQIBQP_418461884
    FOREIGN KEY (partyIDFK)
    REFERENCES dbo.Party (partyID)
go

ALTER TABLE dbo.PartyQPApprovalSource
    ADD CONSTRAINT PartyQPApprSr_partyID
    FOREIGN KEY (partyIDFK,partyAs)
    REFERENCES dbo.PartyQIBQP (partyIDFK,partyAs)
go

ALTER TABLE dbo.PartyQPApprovalSource
    ADD CONSTRAINT PartyQPApprSr_qpApprSrRN
    FOREIGN KEY (qpApprovalSourceRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.PartySite
    ADD CONSTRAINT PartySite_334881479
    FOREIGN KEY (siteValidationUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.PartySite
    ADD CONSTRAINT PartySite_350881536
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.PartySite
    ADD CONSTRAINT PartySite_366881593
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.PartySite
    ADD CONSTRAINT PartySite_382881650
    FOREIGN KEY (tradingNameLocationIDFK)
    REFERENCES dbo.TradingNameLocation (tradingNameLocationID)
go

ALTER TABLE dbo.PartySite
    ADD CONSTRAINT PartySite_398881707
    FOREIGN KEY (siteValidationSourceRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.PartySite
    ADD CONSTRAINT PartySite_414881764
    FOREIGN KEY (siteValidationStatusRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.PartySite
    ADD CONSTRAINT PartySite_430881821
    FOREIGN KEY (creditSensitiveRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.PartySite
    ADD CONSTRAINT PartySite_446881878
    FOREIGN KEY (siteTypeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.PartySite
    ADD CONSTRAINT PartySite_462881935
    FOREIGN KEY (cisSensitiveRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.PartySite
    ADD CONSTRAINT PartySite_478881992
    FOREIGN KEY (siteCreationReasonRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.PartySite
    ADD CONSTRAINT PartySite_494882049
    FOREIGN KEY (siteCreationBusinessUnitRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.PartySite
    ADD CONSTRAINT PartySite_498462169
    FOREIGN KEY (partyIDFK)
    REFERENCES dbo.Party (partyID)
go

ALTER TABLE dbo.PartySite
    ADD CONSTRAINT PartySite_695930770
    FOREIGN KEY (postalAddressIDFK)
    REFERENCES dbo.PostalAddress (postalAddressID)
go

ALTER TABLE dbo.PartyTaxExemption
    ADD CONSTRAINT PartyTaxEx_1038883987
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.PartyTaxExemption
    ADD CONSTRAINT PartyTaxEx_1054884044
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.PartyTaxExemption
    ADD CONSTRAINT PartyTaxEx_1070884101
    FOREIGN KEY (countryRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.PartyTaxExemption
    ADD CONSTRAINT PartyTaxEx_1086884158
    FOREIGN KEY (taxExemptionTypeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.PartyTaxExemption
    ADD CONSTRAINT PartyTaxEx_530462283
    FOREIGN KEY (partyIDFK)
    REFERENCES dbo.Party (partyID)
go

ALTER TABLE dbo.PostalAddress
    ADD CONSTRAINT PostalAddr_546358230
    FOREIGN KEY (lastUpdaterUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.PostalAddress
    ADD CONSTRAINT PostalAddr_562358287
    FOREIGN KEY (creatorUserIDFK)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.PostalAddress
    ADD CONSTRAINT PostalAddr_578358344
    FOREIGN KEY (geoLocationIDFK)
    REFERENCES dbo.GeoLocation (geoLocationRN)
go

ALTER TABLE dbo.RefName
    ADD CONSTRAINT RefName_556786260
    FOREIGN KEY (refLanguageRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.RefName
    ADD CONSTRAINT RefName_572786317
    FOREIGN KEY (refTranslatedFromRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.RefName
    ADD CONSTRAINT RefName_588786374
    FOREIGN KEY (refDomainRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.RefNameRelationship
    ADD CONSTRAINT RefNameRel_665310649
    FOREIGN KEY (relTypeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.RefNameRelationship
    ADD CONSTRAINT RefNameRel_681310706
    FOREIGN KEY (relChildRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.RefNameRelationship
    ADD CONSTRAINT RefNameRel_697310763
    FOREIGN KEY (relParentRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.SpecificAccountUsageCode
    ADD CONSTRAINT SpecificAc_1865314924
    FOREIGN KEY (generalAccountUsageCode)
    REFERENCES dbo.GeneralAccountUsageCode (generalAccountUsageCode)
go

ALTER TABLE dbo.SpecificBrokerLU
    ADD CONSTRAINT SpecificBr_1824982797
    FOREIGN KEY (genericBrokerCode)
    REFERENCES dbo.GenericBrokerLU (genericBrokerCode)
go

ALTER TABLE dbo.SpecificBrokerLU
    ADD CONSTRAINT SpecificBr_1840982854
    FOREIGN KEY (exchangeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TIDAcctSecGrWorkGr
    ADD CONSTRAINT TIDAcctSec_569310307
    FOREIGN KEY (acctPrivGrCode)
    REFERENCES dbo.TIDAcctSecGr (acctPrivGrCode)
go

ALTER TABLE dbo.TIDAcctSecGrWorkGr
    ADD CONSTRAINT TIDAcctSec_585310364
    FOREIGN KEY (workgroupName)
    REFERENCES dbo.TIDWorkgroup (workgroupName)
go

ALTER TABLE dbo.TIDPackage
    ADD CONSTRAINT TIDPackage_1742222526
    FOREIGN KEY (currentUserId)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.TIDPackage
    ADD CONSTRAINT TIDPackage_1758222583
    FOREIGN KEY (msdwUserId)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.TIDPackage
    ADD CONSTRAINT TIDPackage_1774222640
    FOREIGN KEY (workgroupName)
    REFERENCES dbo.TIDWorkgroup (workgroupName)
go

ALTER TABLE dbo.TIDPartySiteFavorite
    ADD CONSTRAINT TIDPartySi_2117839826
    FOREIGN KEY (msdwUserId)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.TIDRRFavorite
    ADD CONSTRAINT TIDRRFavor_1845838857
    FOREIGN KEY (msdwUserId)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.TIDUser
    ADD CONSTRAINT TIDUser_1491077617
    FOREIGN KEY (workgroupRollupLK)
    REFERENCES dbo.WorkgroupRollupLookup (workgroupRollupName)
go

ALTER TABLE dbo.TIDUser
    ADD CONSTRAINT TIDUser_1493837603
    FOREIGN KEY (adminRegionRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TIDUser
    ADD CONSTRAINT TIDUser_1509837660
    FOREIGN KEY (workgroupName)
    REFERENCES dbo.TIDWorkgroup (workgroupName)
go

ALTER TABLE dbo.TIDUserTest
    ADD CONSTRAINT TIDUserTes_1475077560
    FOREIGN KEY (workgroupRollupLK)
    REFERENCES dbo.WorkgroupRollupLookup (workgroupRollupName)
go

ALTER TABLE dbo.TIDUserTest
    ADD CONSTRAINT TIDUserTes_1625314069
    FOREIGN KEY (adminRegionRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TIDUserTest
    ADD CONSTRAINT TIDUserTes_1641314126
    FOREIGN KEY (workgroupName)
    REFERENCES dbo.TIDWorkgroup (workgroupName)
go

ALTER TABLE dbo.TIDWorkgroup
    ADD CONSTRAINT TIDWorkgro_668786659
    FOREIGN KEY (primaryAcctSecGrCode)
    REFERENCES dbo.TIDAcctSecGr (acctPrivGrCode)
go

ALTER TABLE dbo.TIDWorkgroupAccountRange
    ADD CONSTRAINT TIDWorkgro_1932791162
    FOREIGN KEY (firstNum,lastNum)
    REFERENCES dbo.TIDAccountRange (firstNum,lastNum)
go

ALTER TABLE dbo.TIDWorkgroupAccountRange
    ADD CONSTRAINT TIDWorkgro_1948791219
    FOREIGN KEY (workgroupName)
    REFERENCES dbo.TIDWorkgroup (workgroupName)
go

ALTER TABLE dbo.TNDAccount
    ADD CONSTRAINT TNDAccount_755895129
    FOREIGN KEY (tradingNameDefinitionIDFK)
    REFERENCES dbo.TradingNameDefinition (tradingNameDefinitionID)
go

ALTER TABLE dbo.TNDInterest
    ADD CONSTRAINT TNDInteres_1708230505
    FOREIGN KEY (tradingNameDefinitionIDFK)
    REFERENCES dbo.TradingNameDefinition (tradingNameDefinitionID)
go

ALTER TABLE dbo.TNLBDBookingSelection
    ADD CONSTRAINT TNLBDBooki_110880681
    FOREIGN KEY (tradingNameLocationID)
    REFERENCES dbo.TradingNameLocation (tradingNameLocationID)
go

ALTER TABLE dbo.TNLBDBookingSelection
    ADD CONSTRAINT TNLBDBooki_126880738
    FOREIGN KEY (businessDefinitionID)
    REFERENCES dbo.BusinessDefinition (businessDefinitionID)
go

ALTER TABLE dbo.TNLBDBookingSelection
    ADD CONSTRAINT TNLBDBooki_94880624
    FOREIGN KEY (bookingSelectionID)
    REFERENCES dbo.BookingSelection (bookingSelectionID)
go

ALTER TABLE dbo.TNLBDBookingSelectionCIC
    ADD CONSTRAINT TNLBDBooki_174880909
    FOREIGN KEY (businessProcessRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TNLBDBookingSelectionCIC
    ADD CONSTRAINT TNLBDBooki_190880966
    FOREIGN KEY (clientIdentifierTypeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TNLBDBookingSelectionCIC
    ADD CONSTRAINT TNLBDBooki_206881023
    FOREIGN KEY (TNLBDBookingSelectionID)
    REFERENCES dbo.TNLBDBookingSelection (TNLBDBookingSelectionID)
go

ALTER TABLE dbo.TNLBDBrokerCode
    ADD CONSTRAINT TNLBDBroke_1077888176
    FOREIGN KEY (accountNumber,accountSystem)
    REFERENCES dbo.TAPSAccount (accountNumber,accountSystemRN)
go

ALTER TABLE dbo.TNLBDBrokerCode
    ADD CONSTRAINT TNLBDBroke_1980127364
    FOREIGN KEY (brokerCodeIssuer,brokerID)
    REFERENCES dbo.BrokerCode (brokerCodeIssuer,brokerID)
go

ALTER TABLE dbo.TNLBDBrokerCode
    ADD CONSTRAINT TNLBDBroke_1996127421
    FOREIGN KEY (brokerRelationshipType)
    REFERENCES dbo.BrokerRelationshipType (brokerRelationshipType)
go

ALTER TABLE dbo.TNLBDBrokerCode
    ADD CONSTRAINT TNLBDBroke_2012127478
    FOREIGN KEY (businessDefinitionID)
    REFERENCES dbo.BusinessDefinition (businessDefinitionID)
go

ALTER TABLE dbo.TNLBDBrokerCode
    ADD CONSTRAINT TNLBDBroke_2028127535
    FOREIGN KEY (tradingNameLocationID)
    REFERENCES dbo.TradingNameLocation (tradingNameLocationID)
go

ALTER TABLE dbo.TNLBDBrokerCodeGiveUpReference
    ADD CONSTRAINT TNLBDBroke_2108127820
    FOREIGN KEY (TNLBDBrokerCodeID)
    REFERENCES dbo.TNLBDBrokerCode (TNLBDBrokerCodeID)
go

ALTER TABLE dbo.TNLBDOrderCapacity
    ADD CONSTRAINT TNLBDOrder_1187076534
    FOREIGN KEY (orderCapacityCode,orderSubCapacityCode)
    REFERENCES dbo.OrderCapacityCodeCombination (orderCapacityCode,orderSubCapacityCode)
go

ALTER TABLE dbo.TNLBDOrderCapacity
    ADD CONSTRAINT TNLBDOrder_350673316
    FOREIGN KEY (businessDefinitionID)
    REFERENCES dbo.BusinessDefinition (businessDefinitionID)
go

ALTER TABLE dbo.TNLClientIdentifier
    ADD CONSTRAINT TNLClientIdentifier_TNLID
    FOREIGN KEY (tradingNameLocationIDFK)
    REFERENCES dbo.TradingNameLocation (tradingNameLocationID)
go

ALTER TABLE dbo.TNLClientIdentifierCode
    ADD CONSTRAINT TNLClientI_1364457154
    FOREIGN KEY (bookingSelectionID)
    REFERENCES dbo.BookingSelection (bookingSelectionID)
go

ALTER TABLE dbo.TNLClientIdentifierCode
    ADD CONSTRAINT TNLClientI_1380457211
    FOREIGN KEY (businessProcessRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TNLClientIdentifierCode
    ADD CONSTRAINT TNLClientI_1396457268
    FOREIGN KEY (clientIdentifierTypeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TNLClientIdentifierCode
    ADD CONSTRAINT TNLClientI_1412457325
    FOREIGN KEY (tradingNameLocationID)
    REFERENCES dbo.TradingNameLocation (tradingNameLocationID)
go

ALTER TABLE dbo.TNLClientIdentifierCode
    ADD CONSTRAINT TNLClientI_1428457382
    FOREIGN KEY (businessDefinitionID)
    REFERENCES dbo.BusinessDefinition (businessDefinitionID)
go

ALTER TABLE dbo.TPDAdapterMap
    ADD CONSTRAINT TPDAdapter_724454874
    FOREIGN KEY (adpt_fieldid)
    REFERENCES dbo.TPDDictionary (dict_fieldid)
go

ALTER TABLE dbo.TPDDictionary
    ADD CONSTRAINT TPDDiction_1381837204
    FOREIGN KEY (dict_dom_assignor_fieldid)
    REFERENCES dbo.TPDDictionary (dict_fieldid)
go

ALTER TABLE dbo.TPDDictionary
    ADD CONSTRAINT TPDDiction_1397837261
    FOREIGN KEY (dict_fm_fieldname)
    REFERENCES dbo.TPDFieldMaster (fm_fieldname)
go

ALTER TABLE dbo.TPDDictionary
    ADD CONSTRAINT TPDDiction_1413837318
    FOREIGN KEY (dict_assignor_reltype_id)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TPDDomainMap
    ADD CONSTRAINT TPDDomainM_270881251
    FOREIGN KEY (dom_mapdom_id)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TPDDomainMap
    ADD CONSTRAINT TPDDomainM_286881308
    FOREIGN KEY (dom_id)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TPDDomainMap
    ADD CONSTRAINT TPDDomainM_500454076
    FOREIGN KEY (dom_dict_fieldid)
    REFERENCES dbo.TPDDictionary (dict_fieldid)
go

ALTER TABLE dbo.TPDDunsGeoRegion
    ADD CONSTRAINT TPDDunsGeo_1893839028
    FOREIGN KEY (dgeo_lastupd_usr_oid)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.TPDDunsGeoRegion
    ADD CONSTRAINT TPDDunsGeo_1909839085
    FOREIGN KEY (dgeo_create_usr_oid)
    REFERENCES dbo.TIDUser (msdwUserId)
go

ALTER TABLE dbo.TPDDunsGeoRegion
    ADD CONSTRAINT TPDDunsGeo_1925839142
    FOREIGN KEY (dgeo_parent_id)
    REFERENCES dbo.TPDDunsGeoRegion (dgeo_ref_id)
go

ALTER TABLE dbo.TPDDunsGeoRegion
    ADD CONSTRAINT TPDDunsGeo_1941839199
    FOREIGN KEY (dgeo_level_id)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TPDDunsGeoRegion
    ADD CONSTRAINT TPDDunsGeo_1957839256
    FOREIGN KEY (dgeo_geo_ref_id)
    REFERENCES dbo.GeoLocation (geoLocationRN)
go

ALTER TABLE dbo.TPDDunsGeoRegion
    ADD CONSTRAINT TPDDunsGeo_1973839313
    FOREIGN KEY (dgeo_ref_id)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TPDLOSCombination
    ADD CONSTRAINT TPDLOSComb_1740790478
    FOREIGN KEY (lsc_lo_suit_acua_val_id)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TPDLOSCombination
    ADD CONSTRAINT TPDLOSComb_1756790535
    FOREIGN KEY (lsc_lo_suit_act_id)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TPDLOSCombination
    ADD CONSTRAINT TPDLOSComb_1772790592
    FOREIGN KEY (lsc_lo_suit_st_id)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TPDLOSCombination
    ADD CONSTRAINT TPDLOSComb_1788790649
    FOREIGN KEY (lsc_lo_suit_pr_id)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TPDPRCombination
    ADD CONSTRAINT TPDPRCombi_1660790193
    FOREIGN KEY (prc_agreement_id)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TPDPRCombination
    ADD CONSTRAINT TPDPRCombi_1676790250
    FOREIGN KEY (prc_specific_pr_id)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TPDPRCombination
    ADD CONSTRAINT TPDPRCombi_1692790307
    FOREIGN KEY (prc_general_pr_id)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TradingName
    ADD CONSTRAINT TradingNam_1388789224
    FOREIGN KEY (ultimatePrntTradingNameFK)
    REFERENCES dbo.TradingName (tradingNameID)
go

ALTER TABLE dbo.TradingName
    ADD CONSTRAINT TradingNam_1404789281
    FOREIGN KEY (parentTradingNameFK)
    REFERENCES dbo.TradingName (tradingNameID)
go

ALTER TABLE dbo.TradingName
    ADD CONSTRAINT TradingNam_1420789338
    FOREIGN KEY (creatorUserLoginFK)
    REFERENCES dbo.TNUser (tnUserLogin)
go

ALTER TABLE dbo.TradingName
    ADD CONSTRAINT TradingNam_1436789395
    FOREIGN KEY (lastUpdaterUserLoginFK)
    REFERENCES dbo.TNUser (tnUserLogin)
go

ALTER TABLE dbo.TradingNameGroupDesi
    ADD CONSTRAINT TradingNam_1407601322
    FOREIGN KEY (tradingNameIDFK)
    REFERENCES dbo.TradingName (tradingNameID)
go

ALTER TABLE dbo.TradingNameInterest
    ADD CONSTRAINT TradingNam_1487601607
    FOREIGN KEY (divisionRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TradingNameInterest
    ADD CONSTRAINT TradingNam_1503601664
    FOREIGN KEY (interestTypeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TradingNameInterest
    ADD CONSTRAINT TradingNam_1519601721
    FOREIGN KEY (tradingNameIDFK)
    REFERENCES dbo.TradingName (tradingNameID)
go

ALTER TABLE dbo.TradingNameLocAlias
    ADD CONSTRAINT TradingNam_1278884842
    FOREIGN KEY (foreignSystemRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TradingNameLocAlias
    ADD CONSTRAINT TradingNam_1294884899
    FOREIGN KEY (foreignSystemLocationRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TradingNameLocAlias
    ADD CONSTRAINT TradingNam_1310884956
    FOREIGN KEY (validityIndRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TradingNameLocAlias
    ADD CONSTRAINT TradingNam_1326885013
    FOREIGN KEY (tradingNameLocationIDFK)
    REFERENCES dbo.TradingNameLocation (tradingNameLocationID)
go

ALTER TABLE dbo.TradingNameLocAlias
    ADD CONSTRAINT TradingNam_1342885070
    FOREIGN KEY (creatorUserLoginFK)
    REFERENCES dbo.TNUser (tnUserLogin)
go

ALTER TABLE dbo.TradingNameLocAlias
    ADD CONSTRAINT TradingNam_1358885127
    FOREIGN KEY (lastUpdaterUserLoginFK)
    REFERENCES dbo.TNUser (tnUserLogin)
go

ALTER TABLE dbo.TradingNameLocation
    ADD CONSTRAINT TradingNam_1234360681
    FOREIGN KEY (geoLocationRNFK)
    REFERENCES dbo.GeoLocation (geoLocationRN)
go

ALTER TABLE dbo.TradingNameLocation
    ADD CONSTRAINT TradingNam_1250360738
    FOREIGN KEY (tradingNameIDFK)
    REFERENCES dbo.TradingName (tradingNameID)
go

ALTER TABLE dbo.TradingNameLocation
    ADD CONSTRAINT TradingNam_1266360795
    FOREIGN KEY (creatorUserLoginFK)
    REFERENCES dbo.TNUser (tnUserLogin)
go

ALTER TABLE dbo.TradingNameLocation
    ADD CONSTRAINT TradingNam_1282360852
    FOREIGN KEY (lastUpdaterUserLoginFK)
    REFERENCES dbo.TNUser (tnUserLogin)
go

ALTER TABLE dbo.TradingNameLocationAccount
    ADD CONSTRAINT TradingNam_1599602006
    FOREIGN KEY (tradingNameLocationIDFK)
    REFERENCES dbo.TradingNameLocation (tradingNameLocationID)
go

ALTER TABLE dbo.TradingNameLocBusDef
    ADD CONSTRAINT TradingNam_30880396
    FOREIGN KEY (tradingNameLocationID)
    REFERENCES dbo.TradingNameLocation (tradingNameLocationID)
go

ALTER TABLE dbo.TradingNameLocBusDef
    ADD CONSTRAINT TradingNam_46880453
    FOREIGN KEY (businessDefinitionID)
    REFERENCES dbo.BusinessDefinition (businessDefinitionID)
go

ALTER TABLE dbo.TradingNameLocExchange
    ADD CONSTRAINT TradingNam_1383933221
    FOREIGN KEY (exchangeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TradingNameLocExchange
    ADD CONSTRAINT TradingNam_1399933278
    FOREIGN KEY (clientClearingRelTypeRN)
    REFERENCES dbo.RefName (refID)
go

ALTER TABLE dbo.TradingNameLocExchange
    ADD CONSTRAINT TradingNam_1415933335
    FOREIGN KEY (tradingNameLocationIDFK)
    REFERENCES dbo.TradingNameLocation (tradingNameLocationID)
go

ALTER TABLE dbo.TradingNameLocExchange
    ADD CONSTRAINT TradingNam_1431933392
    FOREIGN KEY (creatorUserLoginFK)
    REFERENCES dbo.TNUser (tnUserLogin)
go

ALTER TABLE dbo.TradingNameLocExchange
    ADD CONSTRAINT TradingNam_1447933449
    FOREIGN KEY (lastUpdaterUserLoginFK)
    REFERENCES dbo.TNUser (tnUserLogin)
go

ALTER TABLE dbo.TradingNameLocExchange
    ADD CONSTRAINT TradingNam_483074026
    FOREIGN KEY (genericBrokerCode)
    REFERENCES dbo.GenericBrokerLU (genericBrokerCode)
go

ALTER TABLE dbo.TradingNameLocExchange
    ADD CONSTRAINT TradingNam_707074824
    FOREIGN KEY (genericBrokerCode)
    REFERENCES dbo.GenericBrokerLU (genericBrokerCode)
go

ALTER TABLE dbo.TradingNameParty
    ADD CONSTRAINT TradingNam_1663602234
    FOREIGN KEY (tradingNameIDFK)
    REFERENCES dbo.TradingName (tradingNameID)
go

ALTER TABLE dbo.TradingNameParty
    ADD CONSTRAINT TradingNam_434461941
    FOREIGN KEY (partyIDFK)
    REFERENCES dbo.Party (partyID)
go
