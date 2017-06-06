create   nonclustered index IDX1_MasterAgreementDetails on srf_main.MasterAgreementDetails(Party1SDSID asc,Party2SDSID asc,ProductMainType asc,ProductSubType asc) with (maxdop=0, SORT_IN_TEMPDB=ON) ON [FALCON_SRF_D02_Group1];
GO
create   nonclustered index Idx3_MA_party1_Party2 on srf_main.MasterAgreementDetails(Party1SDSID asc,Party2SDSID asc) INCLUDE (AgreementDate) with (maxdop=0, SORT_IN_TEMPDB=ON) ON [FALCON_SRF_D02_Group1];
GO
create   nonclustered index Idx2_MA_AgreementDate on srf_main.MasterAgreementDetails(AgreementDate asc) with (maxdop=0, SORT_IN_TEMPDB=ON) ON [FALCON_SRF_D02_Group1];
GO
create   nonclustered index IDX2_MasterAgreementDetails on srf_main.MasterAgreementDetails(AgreementId asc) with (maxdop=0, SORT_IN_TEMPDB=ON) ON [FALCON_SRF_D02_Group1];
GO


drop index IDX1_MasterAgreementDetails on srf_main.MasterAgreementDetails;
GO
drop index Idx3_MA_party1_Party2 on srf_main.MasterAgreementDetails;
GO
drop index Idx2_MA_AgreementDate on srf_main.MasterAgreementDetails;
GO
drop index IDX2_MasterAgreementDetails on srf_main.MasterAgreementDetails;
GO

