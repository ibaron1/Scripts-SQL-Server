echo off

rem Data_export_import.SQLServer.SeveralTbls.Credit.cmd

set SourceInstance="NYKPCM05777V05A\FAL_MAIN3_UAT"
set SourceDbName=FALCON_SRF_EQ_EMIR
set backup=Gul_Masteragreementdetails.EQ.txt

set bcpDir=C:\bcp

if not exist %bcpDir%\%TargetDbName% (mkdir %bcpDir%\%TargetDbName%)
set bcpDb=%bcpDir%\%TargetDbName%
if not exist %bcpDb%\bcp_err (mkdir %bcpDb%\bcp_err)

set bcpbin="C:\Program Files\Microsoft SQL Server\100\Tools\Binn"

echo truncate table srf_main.Masteragreementdetails > %bcpDir%\tmp.Masteragreementdetails.sql
echo exec srf_main.SaveMasterAgreementDetailsIdxDef >> %bcpDir%\tmp.Masteragreementdetails.sql
echo exec srf_main.DropMasterAgreementIdx >> %bcpDir%\tmp.Masteragreementdetails.sql
echo go >>  >> %bcpDir%\tmp.Masteragreementdetails.sql
sqlcmd -Usrfmain -Psrfmain1 -S%SourceInstance% -d%SourceDbName% -i%bcpDir%\tmp.Masteragreementdetails.sql

%bcpbin%\bcp %SourceDbName%.srf_main.Masteragreementdetails in %backup% -S%SourceInstance% -Usrfmain -Psrfmain1 -c -b10000 -m1000000 -e%bcpDb%\bcp_err\Masteragreementdetails.err.txt

echo exec srf_main.RecreateMasterAgreementIdx > %bcpDir%\tmp.Masteragreementdetails.sql
echo go >> %bcpDir%\tmp.Masteragreementdetails.sql
sqlcmd -Usrfmain -Psrfmain1 -S%SourceInstance% -d%SourceDbName% -i%bcpDir%\tmp.Masteragreementdetails.sql

