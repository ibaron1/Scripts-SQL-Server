if OBJECT_ID('srf_main.EodSnapshotGetOneTradeDiff') is not null
  drop proc srf_main.EodSnapshotGetOneTradeDiff
go
-- ==============================================================================================
-- Author: Eli Baron
-- Create date: 2015-04-02
-- Description: Get Diff in Fields fr all trades from EOD Snapshot Files Summary Report 
-- ==============================================================================================
create proc srf_main.EodSnapshotGetOneTradeDiff
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

if OBJECT_ID('tempdb.dbo.##EODSnapshotBWtmp') is not null
  drop table ##EODSnapshotBWtmp

set @sqlstr = 'select '+@mismatchedFields+' into ##EODSnapshotBWtmp from srf_main.EODSnapshotBW where '+
'cobDate = '''+cast(@cobDate as char(10))+
''' and publisher = '''+@publisher+
''' and reportingJurisdiction = '''+@reportingJurisdiction+
'''and tradeParty1TransactionId = '''+@tradeParty1TransactionId+
'''and tradeParty2TransactionId = '''+@tradeParty2TransactionId+''''

exec (@sqlstr)

select @sqlstr = 
'select unpvt.clmn, 
unpvt.value
from ##EODSnapshotBWtmp
unpivot (
 value for clmn in ('+stuff((
		select ','+ c.name from tempdb.sys.columns c join tempdb.sys.objects o
				on c.Object_id = o.Object_id
				where o.name = '##EODSnapshotBWtmp'
		for xml path('')
		)
		,1,1,'')+')
 
) unpvt'
from tempdb.sys.columns c join tempdb.sys.objects o
on c.Object_id = o.Object_id
where o.name = '##EODSnapshotBWtmp'

exec (@sqlstr)

if OBJECT_ID('tempdb.dbo.##EODSnapshotFAEOD') is not null
  drop table ##EODSnapshotFAEOD

set @sqlstr = 'select '+@mismatchedFields+' into ##EODSnapshotFAEOD from srf_main.EODSnapshotFAEOD where '+
'cobDate = '''+cast(@cobDate as char(10))+
''' and publisher = '''+@publisher+
''' and reportingJurisdiction = '''+@reportingJurisdiction+
'''and tradeParty1TransactionId = '''+@tradeParty1TransactionId+
'''and tradeParty2TransactionId = '''+@tradeParty2TransactionId+''''

exec (@sqlstr)

select @sqlstr = 
'select unpvt.clmn, 
unpvt.value
from ##EODSnapshotFAEOD
unpivot (
 value for clmn in ('+stuff((
		select ','+ c.name from tempdb.sys.columns c join tempdb.sys.objects o
				on c.Object_id = o.Object_id
				where o.name = '##EODSnapshotFAEOD'
		for xml path('')
		)
		,1,1,'')+')
 
) unpvt'
from tempdb.sys.columns c join tempdb.sys.objects o
on c.Object_id = o.Object_id
where o.name = '##EODSnapshotFAEOD'

exec (@sqlstr)