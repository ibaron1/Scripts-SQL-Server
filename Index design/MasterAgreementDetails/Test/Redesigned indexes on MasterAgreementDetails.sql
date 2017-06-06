
create clustered index CI_MasterAgreementDetails on srf_main.MasterAgreementDetails(Party1SDSID, Party2SDSID, ProductMainType) with (maxdop=12, SORT_IN_TEMPDB=ON);

create nonclustered index NC1_MasterAgreementDetails on srf_main.MasterAgreementDetails(Party1SDSID asc,Party2SDSID asc, AgreementDate asc) with (maxdop=12, SORT_IN_TEMPDB=ON);

create nonclustered index NC2_MasterAgreementDetails on srf_main.MasterAgreementDetails(AgreementId, AgreementDate) with (maxdop=12, SORT_IN_TEMPDB=ON);

create nonclustered index NC3_MasterAgreementDetails 
on srf_main.MasterAgreementDetails(Party1SDSID asc,Party2SDSID asc,AgreementDate desc,Collateralized asc) 
include (AgreementTypeName, AgreementTypeVersion,AgreementId, GNA_ID, agreement_asset_class) with (maxdop=12, SORT_IN_TEMPDB=ON);

exec sp_recompile N'srf_main.MasterAgreementDetails';


----------------------------

drop index NC1_MasterAgreementDetails on srf_main.MasterAgreementDetails;

drop index NC2_MasterAgreementDetails on srf_main.MasterAgreementDetails;

drop index CI_MasterAgreementDetails on srf_main.MasterAgreementDetails;
