
-- ==============================================================================================
-- Author: Eli Baron
-- Create date: 2015-04-02
-- Description: Get Diff in Fields fr all trades from EOD Snapshot Files Summary Report
-- ==============================================================================================
ALTER proc [srf_main].[EodSnapshotGetAllDiff]
with execute as owner
as

set transaction isolation level read uncommitted 
set implicit_transactions off 
set nocount on 

declare @cobDate date, 
@publisher varchar(100),
@reportingJurisdiction varchar(100),
@tradeParty1TransactionId varchar(100),
@tradeParty2TransactionId varchar(100),
@mismatchedFields varchar(max),
@sqlstr varchar(max)

create table #MismatchBW
(cobDate date, 
publisher varchar(100) null,
reportingJurisdiction varchar(100),
tradeParty1TransactionId varchar(100),
tradeParty2TransactionId varchar(100),  
mismatchedFieldName varchar(100), 
mismatchedFieldvalue varchar(100) null)

create table #MismatchFAEOD
(cobDate date, 
publisher varchar(100) null,
reportingJurisdiction varchar(100),
tradeParty1TransactionId varchar(100),
tradeParty2TransactionId varchar(100),  
mismatchedFieldName varchar(100), 
mismatchedFieldvalue varchar(100) null)

truncate table srf_main.EODSnapshotCompareMismatch

declare abc_cursor cursor fast_forward for
select cobDate,publisher,reportingJurisdiction,tradeParty1TransactionId,tradeParty2TransactionId,mismatchedFields
from srf_main.EODSnapshotCompareResult
where linkFlag = 'Both'

open abc_cursor

while 1=1
begin

fetch abc_cursor into @cobDate,@publisher,@reportingJurisdiction,@tradeParty1TransactionId,@tradeParty2TransactionId,@mismatchedFields

if @@FETCH_STATUS <> 0
  break
  
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
'select '+
''''+cast(@cobDate as CHAR(10))+''','+
''''+@publisher+''','+
''''+@reportingJurisdiction+''','+
''''+@tradeParty1TransactionId+''','+
''''+@tradeParty2TransactionId+''','+
'unpvt.clmn, 
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

truncate table #MismatchBW

insert #MismatchBW
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
'select '+
''''+cast(@cobDate as CHAR(10))+''','+
''''+@publisher+''','+
''''+@reportingJurisdiction+''','+
''''+@tradeParty1TransactionId+''','+
''''+@tradeParty2TransactionId+''','+
'unpvt.clmn, 
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

truncate table #MismatchFAEOD

insert #MismatchFAEOD
exec (@sqlstr)

insert srf_main.EODSnapshotCompareMismatch
select a.cobDate,a.publisher,a.reportingJurisdiction,a.tradeParty1TransactionId,a.tradeParty2TransactionId,
a.mismatchedFieldName, a.mismatchedFieldvalue, b.mismatchedFieldvalue
from #MismatchBW as a
join #MismatchFAEOD as b
on a.mismatchedFieldName = b.mismatchedFieldName

end

close abc_cursor
deallocate abc_cursor