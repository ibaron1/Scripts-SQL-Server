   print "exec getTritonAccountsByBDTAP @application='TEST', @divisionCode='<some value>' {, @productTypeCode='<some value>', @underlyingProductTypeCode='<some value>', @accountCategory='<some value>', @bookingCompany='<some value>', @generalAccountUsage=<some value>, @specificAccountUsage=<some value>, @accountClassification='<some value>', @omnibusContraGLCoSub='<some value>'}, @debugInd=0"
   exec getTATNTNLBDByParty @application='TEST', @inputTable='<table name>'
   print "exec getTATNTNLBDByParty @application='TEST', @inputTable='<table name>'"
  exec getTCUserIDByAcctNumber @application='TEST', @accountNumber='0700002G8', @accountSystem=1435, @debugInd=3
   print "exec getElecConReqd_20 @application='TEST', @accountNumber='<account number>', @debugInd=0"
 ***     exec getTradingNameByUltimateID 'test','TN000002087'

   print "exec getPrimDealerByAccountList @application='TEST', @inputTable='#accounts', @debugInd=0"
   print "exec getNameAddrBySiteIDL @application='TEST', @debugInd=0"
   exec getTATNTNLByAccountAxiom @application='TEST', @inputTable='<table name>', @selectFields='accountNumber, accountSystemRN, accountStatus'
   print "exec getTATNTNLByAccountAxiom @application='TEST', @inputTable='<table name>', @selectFields='accountNumber, accountSystemRN, accountStatus'"
  exec getTCTaxExemptionByPartyID @application='TEST', @partyID='BBB00372616', @debugInd=3
exec getEmpByTNLIDBD 'test',@tradingNameLocationID = 'TNL00070597',@coverageGroupRoleCode = 'SALES',@coverageGroupSubRoleCode = 'TRADER', @searchUp = 1,@searchDown = 0,@coverageGroupTypeCode = 'INTERNAL'


   print "exec getTreasuryBaselDarwinData @application='TEST', @debugInd=0"
  exec getEODSubAccount @application='TEST', @param1=<some value>, @param2=<some value>, @debugInd=3

   print "exec getFC3StockLendingData @application='TEST', @debugInd=0"
   exec getTCDSATNByAccount @application='TEST', @inputTable='<table name>'
   print "exec getTCDSATNByAccount @application='TEST', @inputTable='<table name>'"
  exec getTCAFPByAcctNumber @application='TEST', @accountNumber='052804309', @debugInd=3
exec getPartyUltimate @partyID, 1300, 'N', @ultimateParty OUT

   print "exec getTNandDivisionbyInterest @application='TEST', @debugInd=0"
  exec getThreeDAccounts @application='threed', @accountNumber = '00000099', @debugInd=3
  exec getTCPEMByAcctNumberExchID @application='TEST', @partyID='BBB00078196', @mdExchangeID='l', @debugInd=3
   print "exec getEquitySwapsSTPAllocation @application='TEST', @debugInd=0"
 ***     exec getAcctsByEmployeeBDdrivers @application='tradeweb',   
 exec getBDidTNLidByCoverageLR @application = @application,   
  exec getAccountsByAccountCategory @application='TEST', @accountCategory='<some value>', @debugInd=3
  exec getTNandCoverageByAccount_20 @application='TEST', @accountNumber='058307802', @accountSystemRN=1435, @debugInd=3
exec dbLogProcUpd @proc_name = @proc_name, 
  exec getAcctsByEmpBDdrivers_40 @application='TEST', @employeeID='jgennet', @divisionCode='IED', @debugInd=3
exec getCoverageGroupsByCoverageLR
   print "exec getERiskAcctAddr @application='TEST', @param1=<some value>, @debugInd=0"
 ***   exec getCoverageGroup 'test',@coverageGroupID = 'CG000000124'
   print "exec getAMLAccount_20 @application='<application name>', @nameAddressType='<name address type', @openDate='<date>', @debugInd=0"
   print "exec getTNbyAccountandDivision @application='<your application name>', @accountNumber='<account number>', @divisionCode='<division code [IED|FID|FX]>', @debugInd=0"
  exec getCreditRRByAccount @application='TEST', @accountNumber='000925933', @tapsPersonnelType = '02', @debugInd=3
  exec getETCBDDriversbyAcct @application='TEST', @accountNumber='042TWAAM1', @accountSystemRN=1435, @debugInd=3

 exec getAccountsNoOrderPlacer @application = 'TEST'
 exec getAcctDatabyAcct_20 @application='TEST', @accountNumber = '000559161', @accountSystem = 1436, @debugInd=3
   exec getTNLAccountUsageByAccount @application = 'IED',  @accountNumber ='0984H3293', @accountSystem = 1435
   print "exec getAccountbyTNLIDBusDrivers @application='TEST', @divisionCode='IED', @tradingNameLocationID='TNL00026536'"
   print "exec getETCTradeNameLocAlias @application='TEST', @param1=<some value>, @debugInd=0"

 exec getAccountsNoPrincipal @application = 'TEST'
 exec getAcctDatabyAcct @application='TEST', @accountNumber = '000559161', @accountSystem = 1436, @debugInd=3
   exec findAssocCoverageGroup @application, @coverageGroupID, @searchUp=@searchUp, @searchDown=@searchDown, @selectInd = 'N'
  exec getCoverageByTNLIDBD_20 @application='TEST', @tradingNameLocationID='<some value>', @coverageGroupRoleCode='<some value>', @coverageGroupSubRoleCode='<some value>', @businessDefinitionID='<some value>', @divisionCode='<some value>', @businessLineCode='<some value>', @businessLineRegionCode='<some value>', @businessLineOfficeCode='<some value>', @businessLineLevel2Code='<some value>', @productTypeCode='<some value>', @underlyingProductTypeCode='<some value>', @countryOfIssueCode='<some value>', @countryOfIssuerCode='<some value>', @coveringPersonRole='<some value>', @coveringPersonFunction='<some value>', @coverageGroupTypeCode='<some value>', @searchUp=<some value>, @searchDown=<some value>, @debugInd=3
   print "exec getETCUltTradeName @application='TEST', @tradingNameLocAlias = 'MASSLIFE', @foreignSystemCode = 'OMS', @foreignSystemLocationCode = 'NY', @debugInd=0"
   print "exec getTNHierAndInterestByTNID @application = 'test', @tradingNameID = 'TN000002748' , @debugInd='N'"
exec getTNHierAndInterestByTNID @application = 'CIA', @tradingNameID = 'TN000002748' , @debugInd='N'
    print 'exec getEUCDarwinAcctFundtype @applicaiton=''AppName'',@tblFundtype =''#Fundtype'', @debugInd=0 '
      exec getPartyUltimate  @partyID_PR,  1300,  'N',  @ultimatePartyID_PR output
   print "exec reconcileAccountUsage @application='TEST', @debugInd=0"
  exec getSubAccountsmissingGrDesi @application='TEST', @debugInd=3
    print 'exec getEUCDIMDIAccount @applicaiton=''AppName'',@OutputTable=''#DIMDIAccount'',@debugInd=0 '

   print "exec LawActimizeA2DataDump @application='TEST'"
   print "exec getTNITNTNLByTNI @application='TEST', @divisionCode='<division code>', @selectFields='divisionCode, tradingNameID, tradingName, tradingNameLocationID, tradingNameLocation'"
exec ("insert into #partyID (partyID) select prty_ID from " + @inputTable + " where prty_ID is not null and prty_ID <> 'NULL'")
exec (@query)
    print 'exec getEUCGrpDesiNameByGrpDesi @applicaiton=''AppName'',@accountSystemRN =1436 ,@nameAddressType =''91'',@tblGroupDesi =''#tblGroupDesi'',@debugInd=8 '

   print "exec getAccountRelDataforCapri @application='TEST', @accountCloseDate='<some value>', @debugInd=0"
  exec findAssocCoverageGroup @application,@coverageGroupID,@searchUp=@searchUp,@searchDown=@searchDown,@selectInd = 'N'
exec getTNLAByCoverage 'test','vanam','kerberos','SALES','TRADER',@searchUp = 0,@searchDown = -1
exec getTNLAByCoverage 'test','vanam','kerberos','SALES','TRADER',@searchUp = 1,@searchDown = 0
  exec getFirmAccountsForFID @application='TEST', @debugInd=3

   print "exec getTradingNameDataforCapri @application='TEST', @accountCloseDate='<some value>', @debugInd=0"
  exec getAssocCoverageGroup @application,@coverageGroupID,@searchUp=@searchUp,@searchDown=@searchDown,@selectInd = 'N' 
   /* exec NYQINA9.cis_db..GetDarwinTradingName @contact_id = @CISContactIDFS, @darwin_trading_name_id_xref = @darwin_trading_name_id_xref output,
  exec getCISContactTNID_rep @application='TEST', @debugInd=3

   print "exec getAcctAddrFullByAcct_20 @application='TEST', @accountNumber='<account number>', @debugInd=0"
   print "exec getDesiDataforCapri @application='TEST', @accountCloseDate='<some value>', @debugInd=0"
exec getTNLAByCovTNLID @application='test', 
exec getTNLIDByCoverage @application=@application, 
  exec getAcctbyTaxEligibilityCtry_20 @application='TEST', @taxeligibilitytype='GST', @country='SINGAPORE', @debugInd=3
    print 'exec getEUCOrderPlacerByAcctNum @applicaiton=''AppName'',@accountSystemRN =1436 ,@tblOrderPlacer =''#tblOrderPlacer'', @debugInd=0 '
 ***     exec getBDFactsByBDDivDriverL @application='appl',


    print 'exec getEUCTAPSGeneralAddress @applicaiton=''AppName'',@accountSystemRN =1436 ,@nameAddressType =''91'',@tblAccountNameAddress =''#AccountNameAddress'', @debugInd=8 '

    exec @subprocRetval = dbo.getAcctsByBDDrivers
   print "exec getAcctBDDrivers "
 ***     exec getAcctTaxEligibleIndByAcctID @application='tradeweb', @accountnumber='03385D019', @accountsystem = 1435 
   print "exec getRefName_sync_test @application='CIS', @refLanguageRN=8017990, @delimiter='|', @debugInd=0"
  exec spGetTreasuryProducts @application='TEST', @debugInd=3
    print 'exec getEUCTAPSGeneralAddress_20 @applicaiton=''AppName'',@accountSystemRN =1436 ,@nameAddressType =''91'',@tblAccountNameAddress =''#AccountNameAddress'', @debugInd=8 '


  exec getGroupDesisWithoutPOrTN @application='TEST', @debugInd=3
  exec getEUSTAPSFirmAccount @application='TEST', @accountNumber = '0700001N4', @debugInd=3
 ***                           exec getGDSRRCostCenter 'app Name', @rrID = 1, @rrSequenceCode = '000'
 ***                           exec getGDSRRCostCenter 'app Name', @rrSequenceCode = '000'


   print "exec reconcileAccountUsage_V10 @application='TEST', @debugInd=0"
   print "exec getPartyToTradingNameAudit @application = 'test', @modifiedTS = '10/28/2003', @debugInd=0, @debugInd=0"
   exec getExistAccount @application='TEST', @companyCode='0302', @accountNumber='123456789', @accountStatus='A', @debugInd=0
   print "exec getExistAccount @application='TEST', @companyCode='0302', @accountNumber='123456789', @accountStatus='A', @debugInd=0"
***      exec getBDidByBDDriversL @application='tradeweb', 
***      exec getAcctByTNBDL @application='tradeweb', @tradingNameID  = 'TN000003393', @arrayInd = 'Y'   
 ***      exec getTNLdataByClientIdentifier 'unit testing',
   print "exec getEDartTradingNameInfo @application='TEST', @param1=<some value>, @param2=<some value>, @debugInd=0"
  exec getTNBDDataByAcctRange @application='TEST', @accountStatus='A', @accountRange='0538', @glCoSub='0302', @foreignSystemCode='OMS', @foreignSystemLocationCode='NY', @debugInd=3
   print "exec getExistTradingNameInterest @application='TEST', @tradingNameID='<trading name id>', @divisionCode='IED', @debugInd=0"




   exec getAccountUsage @application, @accountNumber, @accountSystem,
 ***                           exec  getTradingNameAll 'app Name', 'TN00000001'
   print "exec getAccountsUndiscPrincipal_10 @application='TEST', @debugInd=0"

   exec getAcctsMissingTNLbyDivision @application='TEST', @division='FID', @debugInd=3                        
   print "exec getFC3TAAPByAccount @application='TEST', @accountNumber='<some value>', @accountSystem=<some value>, @partyRoleRN=<some value>, @debugInd=0"
***      exec getTNLByCoverageL @application='appl',  

  exec getInvestorIDByKSEAccount_20 @application='TEST', @KSEAccountNumber='<some value>', @debugInd=3


  exec getCoverageGroupMemsByUserID @application='TEST', @userID='<some value>', @debugInd=3


   print "exec getAccountsConfDisPrincipal @application='TEST', @debugInd=0"

    print 'exec getTAPSFirmAccount_20 @applicaiton=''AppName'',@accountSystemRN =1436 ,@tblTAPSFirmAccount =''#tblTAPSFirmAccount'',@debugInd=0 '

  exec getTaxExemptIndByKSEAccount_20 @application='TEST', @KSEAccountNumber='<some value>', @taxExemptionTypeCode='<some value>', @debugInd=3
   print "exec FXCleansingGetAccountData @application='TEST', @debugInd=0"

  exec getKoreaInvestorIDByAccount_20 @application='TEST', @accountNumber='<some value>', @accountSystemRN=<some value>, @debugInd=3


   print "exec getFXFC3NameAndAddress @application='TEST', @debugInd=0"





   print "exec getOFACPartyAddress_20 @application='TEST', @date='<some value>', @debugInd=0"
   print "exec getTNLHierByTNID @application = 'test', @tradingNameID = 'TN000002748' , @debugInd='N'"
exec getTNLHierByTNID @application = 'CIA', @tradingNameID = 'TN000002748' , @debugInd='N'
   print "exec getTNTNLLocationByTN_20 @application='TEST', @tradingName='<some value>', @debugInd=3"
  exec getTNTNLLocationByTN_20 @application='TEST', @tradingName='<some value>', @debugInd=3



  exec getTCDIDTCByAcctNumber @application='TEST', @accountNumber='004497830', @accountSystem=1435, @debugInd=3
exec getTNLIDByCoverage @application='test', 
   print "exec getTNPLocationbyTN @application='TEST', @tradingName='<some value>', @debugInd=3"
  exec getTNPLocationbyTN @application='TEST', @tradingName='<some value>', @debugInd=3


   print "exec getNameAddrBySiteID @application='TEST', @partyID='BBB01590274', @siteID='MS100128750', @debugInd=0"
  exec getFIDCleansingByDesi @application='TEST',@debugInd=3
   exec getAccountUsagebyAccountNumber @application='TEST', @inputTable='tempdb..testaccounts'

  exec getTNLSBLbyTN @application='TEST', @tradingName='ABN AMRO%', @debugInd=3
   print "exec getOFACPartyAddress @application='TEST', @date='<some value>', @debugInd=0"

   exec getTATNByBDTNOP @application='TEST', @businessDefinitionID='<business definition id>', @tradingName='<trading name>'
   print "exec getTATNByBDTNOP @application='TEST', @businessDefinitionID='<business definition id>', @tradingName='<trading name>'"
   print "exec getTNLTAFABDDByTNLIDFundID @application='TEST', @tradingNameLocationID='TNL00032654', @fundIDType='PASSPORT', @resultType='N', @debugInd=0"


   print "exec getERiskAcctAddr_20 @application='TEST', @param1=<some value>, @param2=<some value>, @debugInd=0"

  exec GAUTBDsms @application='app_name', @userID='a_kerberos_userid', @divisionCode='IED',@debugInd=0
exec getCoverageGroupsByCoverageLR   @application              = @application,

	exec gdsQueryPartyCommon @partyID=@partyID, @siteID=@siteID
   print "exec getUnixIDByAcctRiskMgr_20 @application='TEST', @accountSystem=<account system>, @accountNumber='<account number>' {, @debugInd=0}"

   print "exec getFXAccounts2 @application='TEST', @debugInd=0"

   print "exec getTNReportsGroupDesiTN @application='TEST', @debugInd=0"
    print 'exec getAntiMoneyLaunderingAccount @applicaiton=''AppName'',@nameAddressType =''21'',@openDate=''20040301'',@debugInd=0 '

   exec lookupAccounts_20 @application='TEST', @tradingName='<some value>', @debugInd=3
   print "exec lookupAccounts_20 @application='TEST', @tradingName='<some value>', @debugInd=3"
   exec getBrokerDataByCoverage_20 @application='TEST', @param1=<some value>, @param2=<some value>, @param3=<some value>, @param4=<some value>, @param5=<some value>, @param6=<some value>, @param7=<some value>, @debugInd=3
exec getTNLIDByCoverage @application=@application,
   print "exec getTNReportsNoACTNLink @application='TEST', @debugInd=0"
  exec getTNTNLBDBySubaccount  @application = 'FID', 

   print "exec getGiveUpAcctByTNLID_20 @application='TEST', @tradingNameLocationID = 'TNL00027071', @accountNumber = NULL, @accountSystemRN = NULL, @debugInd=0"
   exec lookupAccounts_20 @application='TEST', @tradingName='<some value>', @debugInd=3
   print "exec lookupAccounts_20 @application='TEST', @tradingName='<some value>', @debugInd=3"
  exec getTNTNLbyCISContactID @application='TEST', @CISContactID='N10318969', @debugInd=3
   exec getEUROA1A2CSGCoverbyOMWCover @application='TEST', @debugInd=3

   print "exec getA2DataDIGUltimateTN @application='TEST' {@divisionCode='<division code>', @interestType='<interest type>', @days='<number of days back>', @debugInd=0}"
   exec getTNTNLByCoverage @application='TEST', @param1=<some value>, @param2=<some value>, @param3=<some value>, @param4=<some value>, @param5=<some value>, @param6=<some value>, @param7=<some value>, @debugInd=3
exec getTNLIDByCoverage @application=@application, 
  exec lookupTradingNames @application='TEST', @divisionCode='FX', @tradingNameLocAlias='AXA', @coverageGroupRole='SALES', @debugInd=3

   print "exec getAcctsByUsageAndBD @application='TEST', @generalUsage = 'CUSTOMER', @specificUsage = 'CUSTCNTRL'"
   exec getPBRelTNByTNName @application='TEST', @tradingName = 'EQUITABLE'
   exec getBrokerDataByTNL_20 @application='TEST', @tradingNameLocationID='<some value>', @accountStatus='I', @debugInd=3
  exec getTNTNLbyGroupDesiforFIDAlloc  @application='TEST',  @groupDesi = 'JPMM', @debugInd=3
   print "exec getIBISAccountbyAccount @application='TEST', @accountNumber='0463E8651', @debugInd=0"

   exec getAcctsByUserAndBDDrivers @application='OMW', @userID='123456', @userIDType='CISContactID', @divisionCode='IED', @debugInd=1
   exec getAcctsByUserAndBDDrivers @application='OMW', @userID='N10518071', @userIDType='CISContactID', @divisionCode='IED', @debugInd=1
exec getCoverageGroupsByCoverageLR @application = @application,
   exec getPBRelPartyByPartyName @application='TEST', @partyName = 'EQUITABLE'
   print "exec getAccountsWithNoShortName @application='TEST', @debugInd=0"
   exec getTNTNLByIEDTNI @application='TEST', @tradingNameLocationID='<some value>', @debugInd=3
   print "exec getTNTNLByIEDTNI @application='TEST', @tradingNameLocationID='<some value>', @debugInd=3"
   print "exec getIBISTNLbyTNid @application='TEST', @TNID='TN000003471', @debugInd=0"

   exec getPBSyncParty_20 @application='TEST'
   exec getAccountsNoOrderPlacer_10 @application='TEST', @debugInd=3
  exec getTNTNLbyTN @application='TEST', @param1=<some value>, @param2=<some value>, @param3=<some value>, @param4=<some value>, @param5=<some value>, @param6=<some value>, @param7=<some value>, @param8=<some value>, @param9=<some value>, @param10=<some value>, @param11=<some value>, @debugInd=3
   print "exec getIBISTradeCustAcctByAccount @application='TEST', @tradingAccountNumber='000000182', @customerAccountNumber='000000620', @debugInd=0"
   print "exec getFXAccountsWithNoTNLAFOREX @application='TEST', @debugInd=0"
 ***  exec  getExecAsCapacityByTNLABD @application='tradeweb',   
   exec getPBSyncPartyExchangeList_20 @application='TEST'
   exec getTNTNLByTNTNL @application='TEST', @tradingNameLocationID='TNL00081827', @selectFields='tradingName, tradingNameID, tradingNameLocation, tradingNameLocationID'
   print "exec getTNTNLByTNTNL @application='TEST', @tradingName='AXA', @usePartialMatch='Y', @selectFields='tradingName, tradingShortName'"
   print "exec getFXAccountswithMultBusDef @application='TEST', @debugInd=0"
   print "exec getFXDormantAccounts @application='TEST', @param1=<some value>, @debugInd=0"
 ***  exec  getExecAsCapacityByTNLIDBD @application='tradeweb',  

   print "exec getPBSyncTNLAlias @application='TEST'"

   print "exec getTNTNLPbyTNLA @application='TEST', @tradingNameLocAlias='<some value>', @foreignSystemCode='<some value>', @foreignSystemLocationCode='<some value>'"
exec CommonDB..GetEmplsByList @kerberosid = 'fastuser', @application = 'EDART'
   print "exec getPBSyncPartyList @application='TEST', @tradingName = '<partial trading name>'"

exec  O2A2TNLAByTNLID @application='USAGE'
exec O2A2TNLAByTNLID @application='O2A2', @mode=1, @raiseError=1

   exec getTNTNLTNLAByTNTNL @application='TEST', @tradingNameLocationID='TNL12345678', @selectFields='tradingName, tradingNameID, tradingShortName, tradingNameLocation, tradingNameLocationID, tradingNameLocAlias'
   print "exec getTNTNLTNLAByTNTNL @application='TEST', @tradingNameLocationID='TNL12345678', @selectFields='tradingName, tradingNameID, tradingShortName, tradingNameLocation, tradingNameLocationID, tradingNameLocAlias'"

   exec getFXTNLAssignments @application='TEST', @debugInd=3

exec @applicaiton='O2A2',@mode= 1,@raiseError = 1
exec @applicaiton='USAGE'

 ***     exec getTradingName @application = 'application name', @tradingName = 'GULF%'
  exec getTNTNLByFundID @application='TEST', @fundID='MERRILL LYNCH INVESTMENT MGERS', @debugInd=3
exec getPartyUltimate @origPartyID, @partyHierarchyType, 'N', @ultimatePartyID output
   exec getTAPByAccountPartyRole @application='TEST', @inputTable='<table name>, @selectFields=''accountNumber, partyID, partyName'
   print "exec getTAPByAccountPartyRole @application='TEST', @inputTable='<table name>, @selectFields='accountNumber, partyID, partyName'"

 ***     exec getTradingName_R @application = 'application name', @tradingName = 'GULF%'


   print "exec getEQSDataforAccountNumber_30 @application='EQS account linklet', @accountNumber='000000018', @debugInd=0"        

  exec getTradingNameandDivision @application='TEST', @param1=<some value>, @param2=<some value>, @param3=<some value>, @param4=<some value>, @debugInd=3
   exec getFuturesAccountsByDate @application='TEST', @fromDate='2004/10/01', @toDate='2004/10/20', @dateType='C'


   print "exec getFXAcctsInfobyBusLine @application='TEST', @divisionCode='FX', @businessLineCode='FX Broker', @debugInd=0"

  exec getTradingNameAudit @application='TEST', @modifiedTS='5/1/2003', @debugInd=0
   print "exec getAPMatchAcctName @application='TEST', @param1=<some value>, @param2=<some value>, @param3=<some value>, @debugInd=0"
  exec getAPMatchAcctName @application='TEST', @accountNumber='000004', @nameAddressType = '01', @debugInd=3
  exec getTaiwanAccountMinInfo @application='TEST', @rrID=<some value>, @debugInd=3
exec getAccountGenSpecUsage
   print "exec getTradingNamebyCreationTS @application='TEST', @startCreationTS='<start date yyyy/mm/dd>', @endCreationTS='<end date yyyy/mm/dd>', @selectFields='tradingNameID, tradingName, creationTS', @orderBy='creationTS, tradingName'"
   print "exec getPartyHierarchyByPartyID @application = 'test', @partyID = 'BBB00156057', @debugInd='Y'"
exec getPartyHierarchyByPartyID @application = 'CIA', @partyID = 'BBB00192062' , @debugInd='N'
   print "exec getIBISTradingNameList @application='TEST', @tradingName='ADVAN', @debugInd=0"



   print "exec getTradingNameByPartyRole @application='TEST', @partyRole=<some value>, @debugInd=0"
exec getTradingNamePartyByPartyID @application = 'test', @partyID = 'BBB02531295', @debugInd='Y'
  exec getIEDDIGTradingName @application='TEST', @debugInd=3

   exec getAcctByBDTNLCoFundID 'test','BD000001448','TNL00048428','0302','6366'

exec getTradingNamePartyByTNID @application = 'test', @tradingNameID = 'TN000007334', @debugInd='Y'
   exec getIEDPropAccountBDTiers @application='OMW', @debugInd=3

exec @applicaiton='O2A2',@mode= 1,@raiseError = 1
exec @applicaiton='USAGE'

    print 'exec getTradingNameInterest_sync, @applicaiton="CIS",@delimiter="|" @debugInd=0'
   exec getTNLATNLTNByTNLA @application='TEST', @tradingNameLocAlias='MC', @usePartialMatch='Y', @selectFields='tradingNameLocAlias, foreignSystemCode, foreignSystemLocationCode, tradingNameLocation, tradingNameLocationID'
   print "exec getTNLATNLTNByTNLA @application='TEST', @tradingNameLocAlias='MC', @usePartialMatch='Y', @selectFields='tradingNameLocAlias, foreignSystemCode, foreignSystemLocationCode, tradingNameLocation, tradingNameLocationID'"




 ***                           exec  getTradingNameLocAlias 'app Name', 'TN00000001'
   print "exec getFXBrokers @application='TEST', @debugInd=0"

   exec getBAACHierarchy_30 @application='<application name>', @divisionCode='FID', @accountStatus='I'
   print "exec getBAACHierarchy_30 @application='TEST', @param1=<some value>, @param2=<some value>, @debugInd=0"
 ***                           exec  getTradingNameLocation 'app Name', 'TN00000001'
   print "exec getPAPByPA @application='TEST', @startCreationTS='<start date yyyy/mm/dd>', @endCreationTS='<end date yyyy/mm/dd>', @selectFields='tradingNameID, tradingName, creationTS', @orderBy='creationTS, tradingName'"
 exec getAccountsUndisclosePrincipal @application = 'TEST'
   exec getBAACHierarchy_40 @application='<application name>', @divisionCode='FID', @accountStatus='I'
   print "exec getBAACHierarchy_40 @application='TEST', @param1=<some value>, @param2=<some value>, @debugInd=0"

    print 'exec getTradingNameLocation_sync @application="CIS",@delimiter="|",@debugInd = 0'
   print "exec getTAByAccountRange @application='TEST', @startCreationTS='<start date yyyy/mm/dd>', @endCreationTS='<end date yyyy/mm/dd>', @selectFields='tradingNameID, tradingName, creationTS', @orderBy='creationTS, tradingName'"


    print 'exec getTradingNameParty_sync @application="CIS",@delimiter="|",@debugInd = 0'
   exec getTAPSPTNLTNByAccountOP @application='TEST', @inputTable='<table name>'
   print "exec getTAPSPTNLTNByAccountOP @application='TEST', @inputTable='<table name>'"
  exec getKSEAcctTNLbyAccount @application='TEST', @accountNumber= '03K100026', @accountSystemRN= 1436, @debugInd=3
 exec getAccountsNoTradingNameLoc @application = 'TEST'

  exec GetGroupDesiList @ApplnName='MySuperDuperApp', @KrbrsID='zappavic', @GroupDesi='SAC', @searchType=1

    exec getHighVolumebyTradingName @application='TEST', @tradingNameLocationID= 'TNL00029232', @debugInd=0
   exec getBrokerDataByTNL @application='TEST', @tradingNameLocationID='<some value>', @accountStatus='I', @debugInd=3
  exec getLegalCreditUltPartyInfo @application='TEST', @partyID=<some value>, @debugInd=3
exec getPartyUltimate @partyID, 1300, 'N', @legalUltimatePartyID output
 exec getAccountsTradingNameNoLoc @application = 'TEST'


   print "exec getTritonIntercompanyAccounts @application='TEST', @debugInd=0"
   print "exec getETSTAPSFirmAccountInfo @application='TEST', @book='FINANCIALS', @bookDetail='INSURANCE/ALT INV/R EST', @companyCode1='0302', @companyCode2='0342'"
 ***     exec getBDByBDDrivers @application='tradeweb',


   print "exec getTSATAByAccount @application='TEST', @param1=<some value>, @debugInd=0"
  exec getTATFAByAccount @application='TEST'
   exec getMalaysiaCDSNumberByAcctNum @application = 'TC', @accountNumber = '037409661', @accountSystemRN = 1435, @debugInd=3
   print "exec getBDByBDDrivers_20 @application='TEST', @debugInd=0"
  exec getBDByBDDrivers_20 @application='tradeweb', @divisionCode='IED', @exchangeCode='ader', @filterCode='COVERAGE'
        exec (@SQL)
    exec getUltimatePartyNameByPartyL @application = @ApplnName, @hierarchyType = 1300, @inputTable = '#in2', @outputTable = '#out2'
    exec getUltimatePartyNameByPartyL @application = @ApplnName, @hierarchyType = 1301, @inputTable = '#in2', @outputTable = '#out2'
exec GetPartyHierarchyDetail @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @partyID='BBB00179256'
  exec getUKFSACustClassByAcct @application='DocPoint', @accountSystem=1436, @accountNumber='03K149171', @debugInd=3
   print "exec getIMCOEInstitutionalAccounts @application='TEST', @accountCategory='27', @debugInd=0"
   print "exec getO2ETLTNByTNID @application='TEST', @tradingNameID='<trading name id>', @tradingName=@tradingName, @debugInd=0"

   print "exec getUltimateTNByBUInterest @application='TEST', @divisionCode='IED'"
   print "exec getO2ETLTNLByTNLID @application='TEST', @tradingNameLocationID='<trading name location id>', @tradingNameLocation=@tradingNameLocation, @debugInd=0"
exec @retval=getMatchingBusinessDefinition 
  exec getXenaAccountbyAccount @application='TEST', @accountNumber='0463E8651', @debugInd=3
   exec getEDARTIniDarwinbyParty @application='TEST', @partyName='CITADEL', @setrowcnt=20, @debugInd=0
   exec getWardCityStateCountry 
 ***     exec getBDidByBDDrivers @application='tradeweb',  

  exec getXenaBrokerNameByAcct @application='TEST', @accountNumber='000000174', @debugInd=3

   exec getBestExecByTNL @application='TEST', @tnlid='TNL00030876',  @debugInd=3
   print "exec getXenaCustTradeAcctByAcct @application='TEST', @param1='000000182', @param2='000000620', @debugInd=0"
    print 'exec getPartyHierarchy_sync @application="CIS",@partyHierarchyTypeRN=1301,@delimiter="|",@debugInd = 0'
   print "exec getOMWBDTAByBDName @application='TEST', @businessDefinition='<business definition>', @usePartialMatch='Y', @debugInd=0"

 ***   exec getBestExecutionByTNLA @appl='tradeweb', @tnla= 'CGUAM', @foreignSystemCode = 'OMS' 
  exec GetRRList @ApplnName='MySuperDuperApp', @KrbrsID='zappavic', @RRName='SAC', @searchType=1

   exec getXenaTNLbyTNid @application='TEST', @TNid='TN000003467', @debugInd=3
   exec getBrokerDataByCoverage @application='TEST', @param1=<some value>, @param2=<some value>, @param3=<some value>, @param4=<some value>, @param5=<some value>, @param6=<some value>, @param7=<some value>, @debugInd=3
exec getTNLIDByCoverage @application=@application, 
   exec getOPSlinkByAccountFC3 @application='TEST', @accountNumber='<some value>', @accountSystem='<some value>', @accountStatus='<some value>', @debugInd=3
  exec getPartyUltimateByPartyIdLR @application, 1300, 'Y'
 ***                           exec  getBookingSelection 'app Name', 1

  exec getXenaTradeCustAcctByAccount @application='TEST', @tradingAccountNumber='000000182', @customerAccountNumber='000000620', @debugInd=3
  exec getOPSLinkDesiByAccount @application='TEST', @accountNumber='<some value>', @accountSystem=<some value>, @debugInd=3



   exec getXenaTradingName @application='TEST', @clientAlias='*EGNT', @debugInd=3

  exec getBSSAcctNameRRByAcct @application='TEST', @accountNumber='000502088', @debugInd=3


   exec getXenaTradingNamebyTNL @application='TEST', @TNLid='TNL00099209', @debugInd=3
   exec getPartyNameBySiteID @application = 'test', @inputTable='#SID', @selectFields = 'substring(partyName, 1, 50), LTRIM(siteID)', @siteID = '  001269695'
  exec @application='TEST', @accountNumber='058307802', @accountSystem=1435, @debugInd=3
    exec SplitList @ApplnName, @KrbrsID, @PartyIDList, ','

  exec getXenaTradingNameCoSub @application='TEST', @accountNumber='0W2E74003', @debugInd=3
  exec @application='TEST', @accountNumber='058307802', @accountSystem=1435, @debugInd=3

   print "exec getCGHCGTNTNLByCGH @application='TEST', @parentCoverageGroupID='CG000000123', @selectFields='childCoverageGroupID, childCoverageGroup, tradingNameLocationID, tradingNameLocation, tradingNameID, tradingName, tradingShortName', @orderBy='childCoverageGroup, childCoverageGroupID, tradingNameLocation, tradingName'"


   exec getXenaTradingNameList @application='TEST', @tradingName='ADVANTAGE', @debugInd=3
   print "exec getFIDCleansingByAccount @application='<your application name>', @accountRange='<account number range', @debugInd=0"
      exec @retval = subGetByDrExOrderCapByTNLIDBD

  exec getCheckDigit @application='TEST', @accountNumber='00000098', @accountSystemRN=1435, @debugInd=3




    exec (@SQL)


  exec getPartiesWithoutTN @application='TEST', @debugInd=3
         raiserror 30001 "Usage: exec getSubAccountForTradingName @application, @tradingName,[@raiseError],@debugInd"



exec getPartyPABySiteIDLR @application
 ***                           exec  getParty 'app Name', 'BBB0001212'

   print "exec getChildCGByParentCGID @application='TEST', @parentCoverageGroupID='CG000000123', @selectFields='childCoverageGroupID, childCoverageGroup, tradingNameLocationID, tradingNameLocation, tradingNameID, tradingName, tradingShortName', @orderBy='childCoverageGroup, childCoverageGroupID, tradingNameLocation, tradingName'"

 exec isValidTravelRule @application='app name', @accountNumber='005038385', @glCoSub='0201', @debugInd=0,
exec getWardCityStateCountry
  exec getPartybyLastUpdateTS @application='TEST', @lastUpdateTS=<some value>, @selectFields='partyID, partyName'
exec @applicaiton='O2A2',@mode= 1,@raiseError = 1
exec @applicaiton='USAGE'
  exec getCISContactIDTNLTN @application='TEST', @debugInd=3



exec @applicaiton='O2A2',@mode= 1,@raiseError = 1
exec @applicaiton='USAGE'
   print "exec getClientIDTNLMapping @application='TEST', @debugInd=0"

   exec MSDWIntroBrokerAccounts @application='TEST', @debugInd=3


 ***     exec getBDDriversByBDID @application='tradeweb', 


exec @applicaiton='O2A2',@mode= 1,@raiseError = 1
exec @applicaiton='USAGE'
   exec getTCDSATNBySubAccount @application='TEST', @inputTable='<table name>'
   print "exec getTCDSATNBySubAccount @application='TEST', @inputTable='<table name>'"
   exec getPartyNameByTradingName @application='TEST', @tradingName='<some value>', @usePartialMatch='Y', @debugInd=0
   print "exec getPartyNameByTradingName @application='TEST', @tradingName='<some value>', @usePartialMatch='Y', @debugInd=0"



   print "USAGE : exec getConsentToCrossForSingleTNL @application='ConsentForCross', @tradingNameLocationID='<TNLID>', @debugInd=0"

exec @application='O2A2', @mode=1, @raiseError=1
exec @application='USAGE'
exec getPartyPABySiteIDLR @application


  exec getControllerInfobyUIDAccount @application='TEST', @kerberosID='<some value>', @accountNumber='<some value>', @accountSystem=<some value>, @debugInd=3


        exec ('insert into #ttTNLID select tnlvalue from ' + @ttTradingNameLocationID)
    exec getConsentToCrossForMultiTNL @application='ConsentToCross', @ttTradingNameLocationID='#ttTradingNameLocationID', @businessLineRN='<BusinessLineRN>', @debugInd=0

   exec O2A2TrdngAcct @application='<your application name>', @accountNumber='SWPEHB'
   print "exec O2A2TrdngAcct @application='<your application name>', @accountNumber='SWPEHB'"



  exec GetAcctList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @AcctOpenStartDate='01/01/2004', @AcctOpenEndDate='02/01/2004', @SearchType=2, @AcctStatCD='A', @RowCount=1000, @AcctGroupCD='OMNII'
  exec GetAcctList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @AcctOpenStartDate='2004-09-01 00:00:00.0', @searchType=2, @RowCount=500, @SalesRRNo=2995
  exec GetAcctList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @TAPSAcctNo='001198', @searchType=2, @TrustBankAcctType=8019203
  exec GetAcctList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @TAPSAcctNo='03385D175', @searchType=1
  exec GetAcctList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @TAPSAcctNo='0354', @searchType=2, @AcctGroupCD='BRFM'
  exec GetAcctList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @TAPSAcctNo='045', @searchType=2, @RowCount=500, @SalesRRCostCtrNo='4165'
  exec GetAcctList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @TAPSAcctNo='0456', @searchType=2, @RowCount=500, @DivnID=8017051
  exec GetAcctList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @TAPSAcctNo='0456064J6', @searchType=1
    exec getConsentToCrossForAcctNumber @application='ConsentToCross', @accountNumber='001453638'
    exec getConsentToCrossForAcctNumber @application='ConsentToCross', @accountNumber=008281222, @accountSystemRN=1436, @debugInd=0
exec NMR_DOCPOINT..z_TKConsent
   exec getTATGATCDSAByTATGA @application='TEST', @accountName='FIDELITY', @usePartialMatch='Y', @debugInd=0


   exec findAssocCoverageGroup @application, @coverageGroupID, @searchUp=@searchUp, @searchDown=@searchDown, @selectInd = 'N'
  exec getCoverageByTNLIDBD_30 @application='TEST', @tradingNameLocationID='<some value>', @coverageGroupRoleCode='<some value>', @coverageGroupSubRoleCode='<some value>', @businessDefinitionID='<some value>', @divisionCode='<some value>', @businessLineCode='<some value>', @businessLineRegionCode='<some value>', @businessLineOfficeCode='<some value>', @businessLineLevel2Code='<some value>', @productTypeCode='<some value>', @underlyingProductTypeCode='<some value>', @countryOfIssueCode='<some value>', @countryOfIssuerCode='<some value>', @coveringPersonRole='<some value>', @coveringPersonFunction='<some value>', @coverageGroupTypeCode='<some value>', @searchUp=<some value>, @searchDown=<some value>, @debugInd=3
 ***                           exec  getPartySite 'app Name', 'BBB0001212'

    exec getConsentToCrossDQReport @application='ConsentToCross', @tradingNameLocationID='<TNLID>'
   print "USAGE : exec getConsentToCrossDQReport @application='ConsentForCross', @tradingNameLocationID='<TNLID>', @ttTradingNameLocationID='<TempTableName>', @debugInd=0"
exec NMR_DOCPOINT..z_TKConsent_Raw

  exec getPartySitebyLastUpdateTS @application='TEST', @lastUpdateTS=<some value>, @selectFields='siteID'


  exec SplitList @ApplnName, @KrbrsID, @TrdNameIDList, ','


   print "exec getGroupDesisWithoutTNGD @application='TEST', @debugInd=0"



  exec GetAddrAcctDtl @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @AcctID='AC011815904'
   print "exec Get10b10AcctTNByUltPartyID @ApplnNm = 'test', @PartyID = 'BBB00022077', @DivisionCD = 'IED', @GLCoSub = '0201'"

    print 'exec getPBSyncAccountGroup @application="CIS",@debugInd = 0'
   print "exec getPBIndicatorByAccountNumber @application='TEST', @param1=<some value>, @param2=<some value>, @debugInd=0"
  exec getCoverageByEmpIDAndTNID @application='TEST',@employeeId = 'lanzilot',@tradingNameID = NULL,@tradingNameLocationID = 'TNL00028757', @debugInd=3                                                                                                                                                                                                                                                                                                                                                                                                                                                                  


    print 'exec getPBSyncAccountGroupType @application="CIS",@debugInd = 0'








   print "exec getA2TAPSAccount @application='TEST', @accountNumber='<account number>', @systemID=<account system>, @shortName='<short name>', @companyCode='<company code>', @debugInd=0"

   exec getAssocGroupBatch @application='TEST', @searchDown=0, @searchDown=8, @debugInd=3

 ***      exec getBDidByBDDriversL @application='tradeweb',    
 ***   exec getBDTNByEmployeeR @application='EQS', @employeeID =  'mahonpat', @resType = 'BD', @resInd = 'Y' 
 ***   exec getCoverageEmployeeByTNIDAllL @application = 'EQS', @tradingNameID = 'TN000000034', @arrayInd = 'Y' 


    print 'exec getEUCKanjiPartyNameByAcctNum @application=''AppName'',@accountSystemRN =1436 ,@partyRole = ''Order Placer'', @inputTable =''#temptbl'', 


   exec getCoverageByTNLIDBD @application='TEST', @param1=<some value>, @debugInd=3
exec getAssocGroupBatch @application=@application, @searchUp = @searchUp, @searchDown = @searchDown, @linkexternalint = 'Y'
exec getCoverageByTNLIDBD 'test',@tradingNameLocationID = 'TNL00070597',@coverageGroupRoleCode = 'SALES',@coverageGroupSubRoleCode = 'TRADER', @searchUp = 1,@searchDown = 0,@coverageGroupTypeCode = 'INTERNAL' 
 exec getPostalAddressDump @application = 'TEST'
***      exec getBDidByBDDriversL @application='tradeweb',   


  exec GetCoreAcctDtl @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @AcctID='AC002533441'

  exec getAccountInfoByTNLUserID @application='TEST', @userID=<some value>, @tradingNameLocationID=<some value> {, @companyCode=<some value>, @accountStatus=<some value>, @businessDefinitionID=<some value>}, @debugInd=3
exec getMatchingBusinessDefinition @application = @application,

   print "exec getCoverageGroupsByCoverageIE 'test','ALL','kerberos',@coverageGroupSubRoleCode = 'ELETRA'"


exec getPartyUltimate @PartyID, @partyHierarchyTypeRN, @resFlag, @ultimatePartyID output

  exec reconcileTNbyGroupDesi  @application='TEST',  @groupDesi = 'JPMM', @debugInd=3
   exec getTNLBDByCoverageIE @application='TEST', @param1=<some value>, @param2=<some value>, @param3=<some value>, @param4=<some value>, @param5=<some value>, @param6=<some value>, @param7=<some value>, @param8=<some value>, @param9=<some value>, @param10=<some value>, @param11=<some value>, @param12=<some value>, @debugInd=3
exec getAssocGroupBatch @application=@application, @searchUp = @searchUp, @searchDown = @searchDown
   print "exec getPPEAccountNameDesi @application='TEST', @accountNumber=<some value>, @accountSystem=<some value>, @nameAddressType=<some value>, @debugInd=0"

   print "exec getAcctByCtgyAndClasn @application='TEST', @accountNumber='6L', @selectFields='accountNumber,fullName1'"


   print "exec getOPTradeNoticeByTNL @application='TEST', @debugInd=0"
  exec getPWMRegRep @application='TEST', @debugInd=3
  exec getCoverageGroupTypeByCovID @application,@coverageID,@coverageIDType,@coverageGroupTypeCode output,@selectInd = 'N'  
exec getCoverageGroupsByCoverage 'test',@coverageID = 'CG000003313',@coverageIDType = 'coverageGroup',@debugInd = 'N',@searchUp = 1, @searchDown = 1
exec getCoverageGroupsByCoverage 'test',@coverageID = 'vanam',@coverageIDType = 'kerberos',@debugInd = 'N',@searchUp = 2, @searchDown = -1

   print "exec getRTMA2Data @application='TEST', @debugInd=0"
   exec getAccountsbyProductType @application='TEST', @productType='STOCK', @debugInd=3                       


  exec getPWMRRByRRID @application='TEST', @rrID = 412, @debugInd=3
    print 'exec getEUCInactAcctsByCloseDate @applicaiton=''AppName'',@start_CloseDate=''20040510'' ,@end_CloseDate=''20040520'',@OutputTable=''#ClosedAccount'', @debugInd=0 '
   exec getCoverageGroupsByEmployeeID @application='TEST', @employeeID='62545'

   print "exec getCustAcctsByTNLIDBDID_30 @application='TEST', @tradingNameLocationID='<some value>', @debugInd=0"
   print "exec getAcctNameByAcct_20 @application='TEST', @accountNumber='<account number>', @debugInd=0"

   print "exec getBDByBDDrivers_30 @application='TEST', @accountNumber='<account number>', @selectFields='accountNumber, accountSystemRN, shortName'"
  exec getPWMRRCostCenterByDeparment @application='PWM', @debugInd=3
    print 	"exec getEUCInactiveAcctsByAcctNum
  exec getCoverageGroupsByUserID_10 @application='TEST', @kerberosID='xinshuj', @debugInd = 3


   print "exec getSubAccountforFIDAlloc @application='TEST', @groupDesi='<some value>', @debugInd=0"
  exec getAcctTNbyGroupDesi @application='TEST', @groupdesi='A5C', @debugInd=3




  exec GAUBDsms @application='app_name', @userID='a_kerberos_userid', @divisionCode='IED',@debugInd=0
exec getCoverageGroupsByCoverageLR @application              = @application,

 ***     exec getBDidByBDDrivers @application='tradeweb',   
  exec GetJPCoreAcctDtl @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @AcctID='AC008599480'
   print "exec getTNLAndCountryByDate @application='TEST', @debugInd=0"


   print "exec getCustAcctsByTNLIDBDID_20 @application='TEST', @tradingNameLocationID='<some value>', @debugInd=0"
 ***   exec getQIBQPByAcct @appl='appl',  @accountNumber = '036274223', @accountSystem = 1435   
   exec getTNTNLBDbySubAccount_20 @application='FID', @inputTable='#testdata', @debugInd=0
   print "exec getCoverageListByTNLBDTC2 @application='TEST', @kerberosID='grayston'"
***      exec getAcctByBDL @application = 'appl' 

   print "exec reconcileAccountUsage_20 @application='TEST', @debugInd=0"
   print "exec getBaselAccountInfo @application='TEST', @debugInd=0"
   print "exec getRatingNoticeForAcct @application='TEST', @debugInd=0"
  exec getRatingNoticeForAcct @application='TEST', @debugInd=3
   print "exec getCEEDCPLinkageData @application='TEST', @debugInd=0"


   print "exec getA2DataFIDaAccountFund @application='TEST', @groupDesi='<group desi>', @divisionCode='<division code>', @businessLineRegionCode='<business line region code>', @businessLineOfficeCode='<business line office code>', @assetTypeCode='<asset type code>', @countryOfIssueCode='<country of issue code>', @settlementLocationCode='<settlement location code>' {, @fundName varchar(64)='<fund name>', @fundShortName varchar(32)='<fund short name>'}"
  exec getAcctsByEmpBDdrivers @application='TEST', @employeeID='jgennet', @divisionCode='IED', @debugInd=3
  exec getCoverageGroupsByCoverageLR  @application = @application,

   print "exec getAxiomsA2DataRefresh @application='TEST', @accountCloseDate='<some value>', @debugInd=0"
   exec getRefName @application='TEST', @refID='<some value>', @selectFields='refID, refName, refCode'
   print "exec getRefName @application='TEST', @refCode='<some value>', @selectFields='refID, refName, refCode'"


   print "exec getTNTNLInterest @application='<your application name>', @type='[TN | TNL]' {, @debugInd=0}"
   print "exec getAccountByTNLandDivision_20 @application='TEST', @tradingNameLocationID='TNL00029959', @IEDAccounts='Y', @FXAccounts='N', @FIDAccounts='Y', @debugInd=0"
   print "exec getRefName_sync @application='CIS', @refLanguageRN=8017990, @delimiter='|', @debugInd=0"


   print "exec getA2DataFIDaBlockAccount @application='TEST', @tradingNameLocationID='<trading name location id>', @divisionCode='<division code>', @businessLineRegionCode='<business line region code>', @businessLineOfficeCode='<business like office code>', @assetTypeCode='<asset type code>', @countryOfIssueCode='<country of issue code>'"
   exec getDesiandTN @application='TEST', @debugInd=3
   print "exec getTNLByAccount_60 @ApplnNm='<your application name>', [@accountNumber='<account number>' | @accountID='<account id>'] {, @debugInd=0}"
   print "exec getAcctTNBDbyAcct_20 @application='tradeweb',@accountNumber='011533221' ,@accountSystem=1435,@accountStatus='A'"
   print "exec getRefNameByCodeandDomain @application='TEST', @refCode='<some value>', @refDomain=<some value>, @selectFields='refID, refName, refCode'"



   exec getDesibySubAccount @application='TEST', @inputTable='#accountlist', @accountSystem=1435
   print "exec getDesibySubAccount @application='TEST', @inputTable='#accountlist', @accountSystem=1435"
  exec getTradingNameData_20 @application='App Name', @debugInd=3





   print "exec getEUCPartyInfoByAcct @application='TEST', @accountNumber= '00888888'"
   print "exec getEQSDataforAccountNumber_40 @application='EQS account linklet', @accountNumber='000000018', @debugInd=0"        
  exec getTradingNameLocationByTS @application='App Name', @debugInd=3
    exec getSFXaccountbyAccountNumber @application='test', @accountNumber = '05805FGC0', @accountSystem = 1435, @debugInd=0
 ***                           exec getRegisteredRepresentative 'app Name', @rrID = 1, @rrSequenceCode = '000'
 ***                           exec getRegisteredRepresentative 'app Name', @rrSequenceCode = '000'



        exec getUltimatePartyNameByPartyL @application = @ApplnName, @hierarchyType = 1300, @inputTable = '#input', @outputTable = '#output'
  exec getPartyList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @PartyName='%', @StartDate='2004-12-01 00:00:00.0', @JurdtnCntryID=1000407, @LglFormID=8015250
  exec getPartyList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @PartyName='EVERGREEN%', @USPatActGrndfthrdIND=2002000
   print "exec getSurveillanceInfo @application = 'compliance', @accountSystem  = 1436,@addressType	= '01'"
  exec getTradingNameInterestByTS @application='App Name', @debugInd=3
    print 'exec getPBSyncAccountGroupAccount @application="CIS",@debugInd = 0'



  exec GetPartyListByAcctList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @AcctIDList='AC006388842,AC010770207', @PartyRoleID=100003
  exec GetPartyListByAcctList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @AcctIDList='AC013528112', @PartyRoleID=100050
   print "exec getPSPATNLDataForSFDC @application='TEST', @debugInd=0"

  exec getPBTNHierarchy @application = 'test'
  exec getPBTNHierarchy @application = 'test',@siteID = 'XXX'
  exec getPBTNHierarchy @application = 'test',@tradingNameLocationID = 'XXX'
  exec getPartyUltimate
    print 'exec getPBSyncCustAccount @application="CIS",@resultSet=1,@debugInd = 0'
exec @retVal =getPBAcctCallbackByAcctNumber 
   exec getRRMSPByRRMSP @application='TEST', @employeeNumber='44869', @selectFields = 'employeeNumber, rrID', @debugInd=0
   print "exec getRRMSPByRRMSP @application='TEST', @employeeNumber='44869', @selectFields = 'employeeNumber, rrID', @debugInd=0"

   exec getCreditActiveAccounts @application='Credit', @debugInd=3

   exec SplitList @ApplnName, @KrbrsID, @TrdNameIDList, ','
   print "exec getTNByUltTNTNIFIDAccount @application='TEST',  @tradingNameID ='TN000000229', @debugInd=0"
   print "exec getFXReporting @application='<your application name>' {, @debugInd=0}"
	exec @retval= getPBAcctCallbackByAcctNumber 
	exec getPartyUltimate
  exec getPartyHierarchyByPartyID
  exec getTNHierAndInterestByTNID
  exec getTradingNamePartyByTNID
exec getPartySiteAndAddrByPartyID
     exec dbLogProcUpd @proc_name  = @proc_name,
    print 'exec getPBSyncFirmAccount @application="CIS",@resultSet= 1,@debugInd = 0'



exec getPartyUltimate @partyID, 1300, 'N', @ultimatePartyID OUT
   print "exec getAccountInfoforTiger @application='TEST', @debugInd=0"
   print "exec getGDGDName @application='TEST', @debugInd=0"
	  exec getPartyUltimate @partyID = @childPartyID, @partyHierarchyTypeRN = 1300, @resFlag = 'N', @ultimatePartyID = @ultimatePartyID output
	exec getPartyExchangeListByPartyID
	exec getTNLHierByTNID
	exec getTradingNamePartyByTNID
    print "exec getPBSyncParty @application = 'test',@partyRole = 'O'"
exec getPBSyncParty @application = 'test',@partyRole = "O"

	exec @status = getAccountUsage 'A2ITTest', @accountNumber,  
  exec getPartyUltimate @partyID, 1301, @resFlag = 'N', @ultimatePartyID = @creditUltimatePartyID output

   print "exec getAccountCountry @application='TEST', @accountNumber = '007212756', @accountSystemrn =1435, @debugInd=0"
  exec getGroupDesiNameByAccount @application='TEST', @accountNumber='021629647', @debugInd=3
   print "exec getTritonAccountsByBDTA @application='TEST', @divisionCode='<some value>' {, @productTypeCode='<some value>', @underlyingProductTypeCode='<some value>', @accountCategory='<some value>', @bookingCompany='<some value>', @generalAccountUsageCode='<some value>', @specificAccountUsageCode='<some value>', @accountClassification='<some value>', @omnibusContraGLCoSub='<some value>'}, @debugInd=0"
exec getPBSyncPartyExchangeList @application = 'test',@partyRole = "P",@debugInd = 0
  exec getPartyUltimate @partyID, 1301, @resFlag = 'N', @ultimatePartyID = @creditUltimatePartyID output


   exec getIRDTNGDTARRMD @application='TEST', @groupDesi='<some value>'
   exec getIRDTNGDTARRMD @application='TEST', @rrID=<some value>
   print "exec getIRDTNGDTARRMD @application='<application name>', @accountNumber='<some value>'"
   print "exec getIRDTNGDTARRMD @application='<application name>', @employeeNumber='<some value>'"
   print "exec getIRDTNGDTARRMD @application='<application name>', @tradingName='<some value>'"
   print "exec getAccountsNoPrincipal_10 @application='TEST', @debugInd=0"
   exec getSTixTATNByAccount @application='TEST', @inputTable='<table name>, @selectFields='accountCategoryDescription'
   print "exec getSTixTATNByAccount @application='TEST', @inputTable='<table name>, @selectFields='accountCategoryDescription'"





   print "exec getOrderExecCapTNLIDByDiv @application='TEST', @param1=<some value>, @param2=<some value>, @debugInd=0"
   print "exec getGCMIRCA2Data @application='TEST', @debugInd=0"
   print "exec getSTPSettAccountData @application='TEST', @param1=<some value>, @debugInd=0"


  exec GetRefNameListByDomn @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @RefDomnIDList='222,-101'

   print "exec getOFACAcctAddress @application='TEST', @accountOpenDate='<some value>', @debugInd=0"

   print "exec getSubAccTNHierBySubAccBD @application='TEST', @groupDesi=<some value>, @tradingNameID=<some value>, [...]"





   print "exec getOFACAcctAddress2 @application='TEST', @accountOpenDate='<some value>', @debugInd=0"
    exec getSFXaccountDetailbyAccount @application='test', @accountID = 'AC013833427', @debugInd=0
    exec getSFXaccountDetailbyAccount @application='test', @accountNumber = '05805FGC0', @accountSystem = 1435, @debugInd=0






   print "exec getPWMDiscretAccProfile @ApplnNm='<your application name>', @accountName='<account name>', [@rrID='rr id' | @rrName='<rr name list>'] {, @usePartialMatch=['Y' | 'N']} {, @debugInd=0}"


  exec GetRltdRefNameListByDomn @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @RefID=8014352, @RelType=-101

   print "exec getDealAxisPartyQIBTN @application='TEST', @tradingNameID='<some value>', @deltaDate='<some value>', @debugInd=0"
   print "exec getCSGSwissStampTax @application='TEST', @param1=<some value>, @debugInd=0"

   print "exec getStixSubAccountData @application='TEST', @accountName='<some value>', @debugInd=0"
   print "exec getDealAxisPartyQIBTNAny @application='TEST', @tradingNameID='<trading name id>', @deltaDate='<delta date>', @debugInd=0"
   print "exec getSubAccountforFIDAlloc @application='TEST', @groupDesi='<some value>', @debugInd=0"
   print "exec getCSGUKFICOCode @application='TEST', @param1=<some value>, @debugInd=0"


   exec getTATGAByAccount @application='TEST', @inputTable='<table name>, @selectFields='accountCategoryDescription'
   print "exec getTATGAByAccount @application='TEST', @inputTable='<table name>, @selectFields='accountCategoryDescription'"
   exec getSTixFIDAccountQIB @application='TEST', @accountNumber='021737101', @accountSystem=1435, @debugInd=3
   print "exec getSTixFIDAccountQIB @application='TEST', @accountNumber='021737101', @accountSystem=1435, @debugInd=3"
 ***     exec getSubAcctByDesiAcctBDDriv
 ***    exec getSubAcctByDesiAcctBDDriv
  exec getAssocCoverageGroup @application,@coverageGroupID,@searchUp=@searchUp,@searchDown=@searchDown,@selectInd = 'N' 
   exec getCustAcctbyTranTypeBDETC_20 @application='TEST', @param1=<some value>, @param2=<some value>, @param3=<some value>, @param4=<some value>, @param5=<some value>, @param6=<some value>, @param7=<some value>, @debugInd=3

   exec getTATGAByGroupDesi @application='TEST', @inputTable='<table name>', @selectFields='groupDesi, accountNumber, fullName1'
   print "exec getTATGAByGroupDesi @application='TEST', @inputTable='<table name>', @selectFields='groupDesi, accountNumber, fullName1'"

 ***     exec getSubAcctByDesiAcctBDDriv_10
 ***    exec getSubAcctByDesiAcctBDDriv_10
   print "exec getCustAcctsByTNLIDBDID @application='TEST', @tradingNameLocationID='<some value>', @debugInd=0"

   exec getTATGAOPByAccount @application='TEST', @inputTable='<table name>, @selectFields='accountCategoryDescription'
   print "exec getTATGAOPByAccount @application='TEST', @inputTable='<table name>, @selectFields='accountCategoryDescription'"
  exec getCoverageGroupsByUserID @application='TEST', @kerberosID='xinshuj', @coverageGroupRole='SALES', @debugInd = 3
 ***     exec getSubAcctByDesiAcctBDDriv_20
 ***    exec getSubAcctByDesiAcctBDDriv_20
 ***  exec  getOrderExecCapByTNLABD @application='tradeweb',  

   exec getTATGARRByAccount @application='TEST', @inputTable='<table name>, @selectFields='accountNumber, fullName1, rrID'
   print "exec getTATGARRByAccount @application='TEST', @inputTable='<table name>, @selectFields='accountNumber, fullName1, rrID'"
  exec getPartyUltimateByPartyIdLR @application, 1300, 'Y'
 ***   exec setBusDefSearchAttr 'my application','divisionRN',8017051
***      exec getAcctByBDL @application = 'appl' 

   exec getTATGATCDSAByGroupDesi @application='TEST', @inputTable='#desilist', @accountSystem=1435
   print "exec getTATGATCDSAByGroupDesi @application='TEST', @inputTable='#desilist', @accountSystem=1435"
   print "exec getTNLByAccount_30 @application='TEST', @inputTable='<some value>', @debugInd=0"
   print "exec cis_getQIBPartyandResearch @application='TEST', @debugInd=0"
  exec getSummitAcctAddr @application='TEST', @debugInd=3
 ***      exec getBDidByBDDriversL @application='tradeweb',   

   print "exec getUSFuturesTradeCompletion @application='TEST', @debugInd=0"
   print "exec getBusLinebyTNLID @application = 'test', @tradingNameLocationID = 'TNL00025171'"
   print "exec getFuturesAccountData @application='TEST', @debugInd=0"
   print "exec getSummitTFA @application='TEST', @param1=<some value>, @debugInd=0"


   print "exec getFC3TrustFundByAccount @application='<your application name>', @accountNumber='<account number>' {, @accountSystem=<account system>, @debugInd=0}"
   print "exec getSummitTFA_20 @application='<your application name>', @accountNumber='<some value>', @debugInd=0"
  exec getDACTTKAcctNameByAcct @application='TEST', @accountNumber='000000497', @accountSystemRN=1435, @debugInd=3
   print "exec getAllFirmCostCenter @application='TEST', @debugInd=0"


   print "exec getTABDPTNTNLbyBusLine @application='TEST', @businessLineCode='<some value>', @debugInd=0"

   print "exec getDealAxisPartyQIB @application='TEST', @debugInd=0"

   print "exec getAccountsNoOrderPlacer_20 @application='TEST', @debugInd=0"
   print "exec getTAFAByAccount @application='TEST', @accountNumber='<account number>' {, @accountSystem=<account system>, @clientIdentifierTypeCode='<client identifier type code>'}"


 ***  exec  getOrderExecCapByTNLIDBD @application='tradeweb',
    exec SplitList @ApplnName, @KrbrsID, @AcctIDList, ','
else if (@siteID1!=NULL) exec gdsQueryPartyCommon @siteID=@siteID1
else if (@siteID10!=NULL) exec gdsQueryPartyCommon @siteID=@siteID10
else if (@siteID2!=NULL) exec gdsQueryPartyCommon @siteID=@siteID2
else if (@siteID3!=NULL) exec gdsQueryPartyCommon @siteID=@siteID3
else if (@siteID4!=NULL) exec gdsQueryPartyCommon @siteID=@siteID4
else if (@siteID5!=NULL) exec gdsQueryPartyCommon @siteID=@siteID5
else if (@siteID6!=NULL) exec gdsQueryPartyCommon @siteID=@siteID6
else if (@siteID7!=NULL) exec gdsQueryPartyCommon @siteID=@siteID7
else if (@siteID8!=NULL) exec gdsQueryPartyCommon @siteID=@siteID8
else if (@siteID9!=NULL) exec gdsQueryPartyCommon @siteID=@siteID9
   print "exec getTATFAByAccount @application='TEST'"
   exec getTAPSAccountBusDefByDivision @application='TEST', @divisionCode='IED', @accountStatus='A'
   print "exec getTAPSAccountBusDefByDivision @application='TEST', @divisionCode='IED', @accountStatus='A'"
    print 	"exec getInactiveAcctsAddrsByAcctNum

    exec SplitList @ApplnName, @KrbrsID, @PartyIDList, ','
   print "exec getAccountByFATNL @application='TEST', @fundID='<fund id>', @fundIDType='<fund id type>', @tradingNameLocationID='<trading name location id>' {, @debugInd=0}"
   exec getTAPSAccountByBusDef @application='TEST', @refID='<some value>', @selectFields='refID, refName, refCode'
   print "exec getTAPSAccountByBusDef @application='TEST', @refCode='<some value>', @selectFields='refID, refName, refCode'"
	exec getPBAcctCallbackByAcctNumber @application="CIS",@inputTable = "#AccountList",@debugInd = 0
    exec('insert into #input (accountSystemRN,accountNumber) select accountSystemRN,accountNumber from '+@inputTable)


    exec getTWAllocAccounts @application = 'Tradeweb', @desiAccountNumber ='000H12024', @accountsystemRN =1435, @TradeWebID ='858',	 @divisionCode ='FID',
   exec getTAPSAccountCategory @application='TEST', @inputTable='<table name>, @selectFields='accountCategoryDescription'
   print "exec getTAPSAccountCategory @application='TEST', @inputTable='<table name>, @selectFields='accountCategoryDescription'"
exec @applicaiton='O2A2',@mode= 1,@raiseError = 1
exec @applicaiton='USAGE'
   print "exec getEQSDataforAccountNumber_20 @application='EQS account linklet', @accountNumber='000000018', @debugInd=0"        

  exec GetAcctList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @AcctOpenStartDate='01/01/2004', @AcctOpenEndDate='02/01/2004', @SearchType=2, @AcctStatCD='A', @RowCount=1000, @AcctGroupCD='OMNII'
  exec GetAcctList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @AcctOpenStartDate='2004-09-01 00:00:00.0', @searchType=2, @RowCount=500, @SalesRRNo=2995
  exec GetAcctList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @TAPSAcctNo='001198', @searchType=2, @TrustBankAcctType=8019203
  exec GetAcctList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @TAPSAcctNo='03385D175', @searchType=1
  exec GetAcctList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @TAPSAcctNo='0354', @searchType=2, @AcctGroupCD='BRFM'
  exec GetAcctList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @TAPSAcctNo='045', @searchType=2, @RowCount=500, @SalesRRCostCtrNo='4165'
  exec GetAcctList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @TAPSAcctNo='0456', @searchType=2, @RowCount=500, @DivnID=8017051
  exec GetAcctList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @TAPSAcctNo='0456064J6', @searchType=1
    exec getTWNonAllocAccounts  @application = 'Tradeweb', @desiAccountNumber ='000631648', @accountsystemRN =1435,
 ***                           exec  getTapsFirmAccount 'app Name', '05666779'
exec @applicaiton='O2A2',@mode= 1,@raiseError = 1
exec @applicaiton='USAGE'

    print "exec getTWAllocAccounts @application = 'Tradeweb', @desiAccountNumber ='000J54543', @accountsystemRN =1435, @TradeWebID ='00040320',@divisionCode ='FID',
   exec getTATCDSAByAccount @application='TEST', @inputTable='<table name>', @selectFields='accountNumber, accountSystemRN, accountStatus'
   print "exec getTATCDSAByAccount @application='TEST', @inputTable='<table name>', @selectFields='accountNumber, accountSystemRN, accountStatus'"
 ***	exec getBDidByBDDriversL @application='summit', @businessLineCode='FINANCING',@resInd=NULL
 ***     exec getBDidByBDDrivers @application='tradeweb',   

   exec getA2Data_20 @application = 'CAPO', @account = '000500025', @debugInd=3
   print "exec getTATGATCDSAByBD_20 @application='TEST', @businessDefinitionID='BD000001108', @debugInd=0"
   exec getTATCDSARRByAccount @application='TEST', @inputTable='<table name>', @selectFields='accountNumber, accountSystemRN, accountStatus, rrCostCenter'
   print "exec getTATCDSARRByAccount @application='TEST', @inputTable='<table name>', @selectFields='accountNumber, accountSystemRN, accountStatus'"
  exec getAcctbyTaxEligibilityCountry @application = 'coit-asia-acc' 


   print "exec getUTNwithoutUPLink @application='TEST', @debugInd=0"
  exec getSubAccountForFIDa @application='TEST', @param1=<some value>, @param2=<some value>, @debugInd=3

   print "exec getTATGAbyAcctandAddrSeqNum @application='TEST'"
  exec getOrderPlacerbyKSEAcctNumber @application='TEST', @KSEAccountNumber='102163' 


   print "exec getFIDSTPTATNTNLByGroupDesi @application='TEST', @groupDesi='<group desi>' {, @accountSystem=<account system>, @debugInd=0}"
   print "exec getTNReportsTNLNotGlobal @application='TEST', @debugInd=0"
  exec getInfobyTradingName_20 @application='TEST', @tradingName='PUTNAM', @debugInd=3
  exec getDTCGovDIbyAccount @application='TEST', @inputTable='<input table>'

   print "exec getCovGrpRoleByModDate_10 @application='TEST', @lastModifiedDate='20050101', @businessLineCode='SYNDICATE', @debugInd=0"
   print "exec getTNReportsTNLNotCity @application='TEST', @debugInd=0"
  exec getDTTFA @application='TEST', @accountNumber = '07'
   print "exec  getCovGrpHierByModDate_10 @application = 'test', @lastModifiedDate = '12/31/2002', @businessLineCode = 'SYNDICATE'"

  exec getRRByAccount11 @application='TEST', @accountNumber='031000391', @tapsPersonnelType = '02', @rrSequenceCode = '001', @debugInd=3
   exec getDTTFA_20 @application='TEST', @accountNumber = '07'
 ***     exec getDesiTNByRR_R 'test',852,'01'
    exec SplitList @ApplnName, @KrbrsID, @PartyIDList, ','
  exec GetAcctListByPartyList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @PartyIDList='BBB00163520', @PartyRoleID=100003
  exec GetAcctListByPartyList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @PartyIDList='BBB00319701', @SiteID='  101147130', @PartyRoleID=100004, @RowCount=500
   print "exec getCovGrpEmpByModDate_10 @application='TEST', @param1=<some value>, @param2=<some value>, @debugInd=0"
  exec getDTTFAByDeskL @application='TEST', @debugInd=3
***  exec getDunsFields 'app name', @partyName = 'GOLDMAN SACHS'
exec getPartyPABySiteIDR @application, @siteID, 'Y'
exec getPartyPrntNmeAndUltNmeLR @application, 1301, 'N'
 ***     exec getGroupDesi_R 'test','M9M'
  exec GetTrdNameList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @TrdName='GULF', @SrchType=2, @TrdNameLocnAlias='K033884'
  exec GetTrdNameList @ApplnName='MySuperDuperApp', @KrbrsID='rigineu', @TrdNameLocnID='TNL00000031', @SrchType=1
   print "exec getAccountInfoforART @application='TEST', @debugInd=0"
   print "exec getCovTraderSalesByModDate_20 @application='TEST', @modifiedTS='2004/07/01', @businessLineCode='<some value>'"
 exec getCoverageGroupsByCoverageLR  @application = @application,  
   exec getTATNTNLBDByAccountAxiom @application='TEST', @inputTable='<table name>', @selectFields='accountNumber, accountSystemRN, accountStatus'
   print "exec getTATNTNLBDByAccountAxiom @application='TEST', @inputTable='<table name>', @selectFields='accountNumber, accountSystemRN, accountStatus'"


   print "exec  getCoverageGroupByModDate @application = 'test', @lastModifiedDate = '12/31/2002',@businessLineCode = 'SYNDICATE'"
