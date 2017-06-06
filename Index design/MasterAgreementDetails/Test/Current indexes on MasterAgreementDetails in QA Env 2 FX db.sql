create   nonclustered index IDX1_MasterAgreementDetails on srf_main.MasterAgreementDetails(Party1SDSID asc,Party2SDSID asc,ProductMainType asc,ProductSubType asc) with (maxdop=0, SORT_IN_TEMPDB=ON) ON [FALCON_SRF_D02_Group1];
GO
create   nonclustered index Idx2_MA_AgreementDate on srf_main.MasterAgreementDetails(AgreementDate asc) with (maxdop=0, SORT_IN_TEMPDB=ON) ON [FALCON_SRF_D02_Group1];
GO
create   nonclustered index Idx4_MasterAgreementDetails on srf_main.MasterAgreementDetails(AgreementId asc,AgreementDate asc) INCLUDE (AgreementTypeName,AgreementTypeVersion,GNA_ID) with (maxdop=0, SORT_IN_TEMPDB=ON) ON [FALCON_SRF_D02_Group1];
GO
create   nonclustered index Idx5_MasterAgreementDetails on srf_main.MasterAgreementDetails(Party1SDSID asc,Party2SDSID asc,ProductMainType asc,ProductSubType asc,AgreementDate asc) INCLUDE (AgreementTypeName,AgreementTypeVersion,AgreementId,GNA_ID) with (maxdop=0, SORT_IN_TEMPDB=ON) ON [FALCON_SRF_D02_Group1];
GO
create   nonclustered index Idx6_MasterAgreementDetails on srf_main.MasterAgreementDetails(Party1SDSID asc,Party2SDSID asc,AgreementTypeName asc,AgreementDate asc) INCLUDE (AgreementTypeVersion,AgreementId,GNA_ID) with (maxdop=0, SORT_IN_TEMPDB=ON) ON [FALCON_SRF_D02_Group1];
GO
create   nonclustered index Idx7_MasterAgreementDetails on srf_main.MasterAgreementDetails(Party1SDSID asc,Party2SDSID asc,AgreementTypeName asc) INCLUDE (AgreementDate) with (maxdop=0, SORT_IN_TEMPDB=ON) ON [FALCON_SRF_D02_Group1];
GO
create   nonclustered index Idx3_MA_party1_Party2 on srf_main.MasterAgreementDetails(Party1SDSID asc,Party2SDSID asc) with (maxdop=0, SORT_IN_TEMPDB=ON) ON [FALCON_SRF_D02_Group1];
GO

exec sp_recompile N'srf_main.MasterAgreementDetails';


/****************************************************/


drop index IDX1_MasterAgreementDetails on srf_main.MasterAgreementDetails;
GO
drop index Idx2_MA_AgreementDate on srf_main.MasterAgreementDetails;
GO
drop index Idx4_MasterAgreementDetails on srf_main.MasterAgreementDetails;
GO
drop index Idx5_MasterAgreementDetails on srf_main.MasterAgreementDetails;
GO
drop index Idx6_MasterAgreementDetails on srf_main.MasterAgreementDetails;
GO
drop index Idx7_MasterAgreementDetails on srf_main.MasterAgreementDetails;
GO
drop index Idx3_MA_party1_Party2 on srf_main.MasterAgreementDetails;
GO