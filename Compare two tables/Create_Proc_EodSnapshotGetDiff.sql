if OBJECT_ID('srf_main.EodSnapshotGetDiff') is not null
  drop proc srf_main.EodSnapshotGetDiff
go

-- ==============================================================================================
-- Author: Eli Baron
-- Create date: 2015-04-02
-- Description: Get Diff in Fields from EOD Snapshot Files Summary Report
-- ==============================================================================================
create proc srf_main.EodSnapshotGetDiff
@cobDate date, 
@publisher varchar(100),
@reportingJurisdiction varchar(100),
@tradeParty1TransactionId varchar(100),
@tradeParty2TransactionId varchar(100)
with execute as owner, recompile
as

set transaction isolation level read uncommitted 
set implicit_transactions off 
set nocount on 

declare @sqlstr varchar(max), @mismatchedFields varchar(max)

select @mismatchedFields = mismatchedFields
from srf_main.EODSnapshotCompareResult
where cobDate = @cobDate
and publisher = @publisher
and reportingJurisdiction = @reportingJurisdiction
and tradeParty1TransactionId = @tradeParty1TransactionId
and tradeParty2TransactionId = @tradeParty2TransactionId

set @sqlstr = 'select ''BW'' as DataSource, '+@mismatchedFields+' from srf_main.EODSnapshotBW where '+
'cobDate = '''+cast(@cobDate as char(10))+
''' and publisher = '''+@publisher+
''' and reportingJurisdiction = '''+@reportingJurisdiction+
'''and tradeParty1TransactionId = '''+@tradeParty1TransactionId+
'''and tradeParty2TransactionId = '''+@tradeParty2TransactionId+''''

exec (@sqlstr)

set @sqlstr = 'select ''FAEOD'' as DataSource, '+@mismatchedFields+' from srf_main.EODSnapshotFAEOD where '+
'cobDate = '''+cast(@cobDate as char(10))+
''' and publisher = '''+@publisher+
''' and reportingJurisdiction = '''+@reportingJurisdiction+
'''and tradeParty1TransactionId = '''+@tradeParty1TransactionId+
'''and tradeParty2TransactionId = '''+@tradeParty2TransactionId+''''

exec (@sqlstr)

