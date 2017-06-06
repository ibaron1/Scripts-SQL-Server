
/****** Object:  StoredProcedure [srf_main].[RefreshMasterAgreementDetails]    Script Date: 10/09/2014 20:06:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [srf_main].[RefreshMasterAgreementDetails]
(@OutFlag bit, 
 @batch_size int = 150000 --Eli
 ) 
WITH EXECUTE AS OWNER
AS

 --Eli
set transaction isolation level read uncommitted 
set implicit_transactions off
set nocount on 

DECLARE @errorMsg VARCHAR(255) ,
            @errorState VARCHAR(255) ,
            @errnumber VARCHAR(100) ,
            @ERROR_SEVERITY VARCHAR(100) ,
            @ERROR_LINE VARCHAR(100) ,
            @ERROR_PROCEDURE VARCHAR(500) ,           
@row_counter INT,
@maxrow_count INT;

declare @rc int --Eli

 --Eli
select  Party1SDSID ,
        Party2SDSID ,
        AgreementId ,
        AgreementDate ,
        AgreementTypeName ,
        AgreementTypeVersion ,
        Code ,
        Name ,
        TargetTaxonomyName ,
        ProductMainType ,
        ProductSubType ,
        GNA_ID ,
        Collateralized ,
        agreement_asset_class 
into #tmp
from srf_main.MasterAgreementDetailsStage
where 1=2


TRUNCATE TABLE srf_main.MasterAgreementDetails

 --Eli
--generate and save index definition for table MasterAgreementDetails
exec srf_main.SaveMasterAgreementDetailsIdxDef
--drop indexes from table MasterAgreementDetails for faster load
exec srf_main.DropMasterAgreementIdx      

BEGIN TRY

 --Eli
set @rc = @batch_size

 --Eli
WHILE @rc = @batch_size
BEGIN

truncate table #tmp

delete top (@rc) from srf_main.MasterAgreementDetailsStage 
	   output 
		deleted.Party1SDSID ,
		deleted.Party2SDSID ,
		deleted.AgreementId ,
		deleted.AgreementDate ,
		deleted.AgreementTypeName ,
		deleted.AgreementTypeVersion ,
		deleted.Code ,
		deleted.Name ,
		deleted.TargetTaxonomyName ,
		deleted.ProductMainType ,
		deleted.ProductSubType ,
		deleted.GNA_ID ,
		deleted.Collateralized ,
		deleted.agreement_asset_class
into #tmp 

set @rc = @@rowcount
 
INSERT INTO srf_main.MasterAgreementDetails
        ( Party1SDSID ,
          Party2SDSID ,
          AgreementId ,
          AgreementDate ,
          AgreementTypeName ,
          AgreementTypeVersion ,
          Code ,
          Name ,
          TargetTaxonomyName ,
          ProductMainType ,
          ProductSubType ,
          GNA_ID ,
          Collateralized ,
          agreement_asset_class
        )
        SELECT  Party1SDSID ,
                Party2SDSID ,
                AgreementId ,
                AgreementDate ,
                AgreementTypeName ,
                AgreementTypeVersion ,
                Code ,
                Name ,
                TargetTaxonomyName ,
                ProductMainType ,
                ProductSubType ,
                GNA_ID ,
                Collateralized ,
                agreement_asset_class 
       FROM #tmp


END

 --Eli
--recreate indexes from table MasterAgreementDetails
exec srf_main.RecreateMasterAgreementIdx

SET @OutFlag=1
RETURN @OutFlag
END TRY
BEGIN CATCH
	--
	SELECT  @errnumber = ERROR_NUMBER() --AS ErrorNumber    
                    ,
                    @ERROR_SEVERITY = ERROR_SEVERITY() --AS ErrorSeverity    
                    ,
                    @errorState = ERROR_STATE()-- AS ErrorState    
                    ,
                    @ERROR_LINE = ERROR_LINE() --AS ErrorLine    
                    ,
                    @ERROR_PROCEDURE = ERROR_PROCEDURE()-- AS ErrorProcedure    
                    ,
                    @errorMsg = ERROR_MESSAGE()-- AS ErrorMessage 

INSERT    INTO srf_main.SRFException
            (ApplicationName ,
             AssetClass ,
             ExceptionCode ,
             ExceptionMessage ,
             StackTrace ,
             COBDate ,
             InputString ,
             FeedIdVersion ,
             FeedType ,
             TradeFeedFileFragmentId ,
             ValuationFeedFileFragmentId ,
             MessageType ,
             USI ,
             UTI ,
             TradeId ,
             TradeVersion ,
             CreateDate ,
             UpdateDate ,
             Jurisdiction ,
             PublisherTradeId ,
             TradeMessageId ,
             [Level])
  VALUES    ('EMIRMasterAgreement' , -- ApplicationName - varchar(500)
             'LIBRA' , -- AssetClass - varchar(50)
             @errnumber , -- ExceptionCode - varchar(100)
             @errorMsg , -- ExceptionMessage - varchar(8000)
             @ERROR_LINE , -- StackTrace - varchar(8000)
             CAST(GETDATE() AS DATE) , -- COBDate - date
             @ERROR_PROCEDURE , -- InputString - varchar(max)
             '' , -- FeedIdVersion - varchar(100)
             '' , -- FeedType - varchar(100)
             '' , -- TradeFeedFileFragmentId - varchar(100)
             '' , -- ValuationFeedFileFragmentId - varchar(100)
             'LIBRA' , -- MessageType - varchar(100)
             '' , -- USI - varchar(100)
             '' , -- UTI - varchar(100)
             '' , -- TradeId - varchar(100)
             '' , -- TradeVersion - varchar(10)
             GETDATE() , -- CreateDate - datetime
             GETDATE() , -- UpdateDate - datetime
             '' , -- Jurisdiction - varchar(100)
             '' , -- PublisherTradeId - varchar(100)
             0 , -- TradeMessageId - int
             'MasterAgreement'  -- Level - varchar(100)
             )
 
  --Eli
	 --recreate indexes from table MasterAgreementDetails
	exec srf_main.RecreateMasterAgreementIdx
            
	SET @OutFlag=0
	RETURN @OutFlag
	
END CATCH



