
if OBJECT_ID('srf_main.EodSnapshotComparator') is not null
  drop proc srf_main.EodSnapshotComparator
go

-- ==============================================================================================
-- Author: Eli Baron
-- Create date: 2015-03-31
-- Description: EOD Snapshot Files Summary Report
-- ==============================================================================================
create proc srf_main.EodSnapshotComparator
@cobdate date = null
with execute as owner, recompile
as

set transaction isolation level read uncommitted 
set implicit_transactions off 
set nocount on 

select @cobDate = dateadd(dd,-1,coalesce(@cobDate, cast(getdate() as date)))

truncate table srf_main.EODSnapshotCompareResult

declare @sqlstr varchar(max)

if OBJECT_ID('tempdb.dbo.##EODSnapshotCompareTmp') is not null
  drop table ##EODSnapshotCompareTmp

select @sqlstr = 
'select a.cobDate,
a.publisher,a.reportingJurisdiction, 
a.tradeParty1TransactionId,a.tradeParty2TransactionId'

select @sqlstr += 
',(srf_main.fn_compare(a.'+name+',b.'+name+')) as ['+name+']'
from sys.columns
where Object_id = Object_id('srf_main.EODSnapshotBW')
and name not in ('cobDate','publisher','reportingJurisdiction','tradeParty1TransactionId','tradeParty2TransactionId')

select @sqlstr += 
' into ##EODSnapshotCompareTmp from srf_main.EODSnapshotBW as a
join srf_main.EODSnapshotFAEOD as b
on a.cobDate = b.cobDate
and a.publisher = b.publisher
and a.reportingJurisdiction = b.reportingJurisdiction
and a.tradeParty1TransactionId = b.tradeParty1TransactionId
and isnull(a.tradeParty2TransactionId,'''') = isnull(b.tradeParty2TransactionId,'''')
where a.cobDate = '''+cast(@cobdate as varchar(80))+''''

exec (@sqlstr)

if OBJECT_ID('tempdb.dbo.##EODSnapshotCompareSum') is not null
  drop table ##EODSnapshotCompareSum

select @sqlstr = 
'select unpvt.cobDate, 
unpvt.publisher,unpvt.reportingJurisdiction,
unpvt.tradeParty1TransactionId, unpvt.tradeParty2TransactionId, unpvt.clmn, 
unpvt.value
into ##EODSnapshotCompareSum
from ##EODSnapshotCompareTmp as a
unpivot (
 value for clmn in ('+stuff((
		select ','+ c.name from tempdb.sys.columns c join tempdb.sys.objects o
				on c.Object_id = o.Object_id
				where o.name = '##EODSnapshotCompareTmp'
				and c.name not in ('cobDate','publisher','reportingJurisdiction','tradeParty1TransactionId','tradeParty2TransactionId')
		for xml path('')
		)
		,1,1,'')+')
) unpvt'
from tempdb.sys.columns c join tempdb.sys.objects o
on c.Object_id = o.Object_id
where o.name = '##EODSnapshotCompareTmp'
and c.name not in ('cobDate','publisher','reportingJurisdiction','tradeParty1TransactionId','tradeParty2TransactionId')

exec (@sqlstr)

--create clustered index i on ##EODSnapshotCompareSum(cobDate,publisher,reportingJurisdiction,tradeParty1TransactionId,tradeParty2TransactionId)

;with match
as
(select cobDate,publisher,reportingJurisdiction,tradeParty1TransactionId,tradeParty2TransactionId, SUM(value) as mismatchedFieldsCount,
    (select stuff((
		select ';'+clmn from ##EODSnapshotCompareSum
				where cobDate = cs.cobDate
					and publisher = cs.publisher
					and reportingJurisdiction = cs.reportingJurisdiction
					and tradeParty1TransactionId = cs.tradeParty1TransactionId
					and isnull(tradeParty2TransactionId,'') = isnull(cs.tradeParty2TransactionId,'')
					and value = 1
					and cobDate = @cobdate
		for xml path('')
		)
		,1,1,'')) as mismatchedFields
from ##EODSnapshotCompareSum as cs
group by cobDate,publisher,reportingJurisdiction,tradeParty1TransactionId,tradeParty2TransactionId)
,getAll
as
(select distinct
@cobdate as cobdate,
coalesce(m.publisher, BW.publisher, FAEOD.publisher) as publisher,
coalesce(m.reportingJurisdiction,BW.reportingJurisdiction,FAEOD.reportingJurisdiction) as reportingJurisdiction, 
coalesce(m.tradeParty1TransactionId, BW.tradeParty1TransactionId, FAEOD.tradeParty1TransactionId) as tradeParty1TransactionId,
coalesce(m.tradeParty2TransactionId, BW.tradeParty2TransactionId, FAEOD.tradeParty2TransactionId) as tradeParty2TransactionId,
case when m.publisher is not null 
     then 'Both'
     when BW.publisher is not null and FAEOD.publisher is null
     then 'BW Only'
     when FAEOD.publisher is not null and BW.publisher is null
     then 'FAEOD Only' end linkFlag,
case when isnull(m.mismatchedFieldsCount,0) > 0 or m.mismatchedFieldsCount is null then 'Yes'
     else 'No' end as misMatchFlag, 
m.mismatchedFieldsCount,
m.mismatchedFields
from srf_main.EODSnapshotBW as BW
full outer join srf_main.EODSnapshotFAEOD as FAEOD
on BW.cobDate = FAEOD.cobDate
and BW.publisher = FAEOD.publisher
and BW.reportingJurisdiction = FAEOD.reportingJurisdiction
and BW.tradeParty1TransactionId = FAEOD.tradeParty1TransactionId
and BW.tradeParty2TransactionId = FAEOD.tradeParty2TransactionId
full outer join match as m
on m.cobDate = FAEOD.cobDate
and m.publisher = FAEOD.publisher
and m.reportingJurisdiction = FAEOD.reportingJurisdiction
and m.tradeParty1TransactionId = FAEOD.tradeParty1TransactionId
and isnull(m.tradeParty2TransactionId,'') = isnull(FAEOD.tradeParty2TransactionId,'')
and BW.cobDate = @cobdate and FAEOD.cobDate = @cobdate
and m.cobDate = @cobdate)
insert srf_main.EODSnapshotCompareResult
(cobDate, 
publisher,
reportingJurisdiction,
tradeParty1TransactionId, 
tradeParty2TransactionId, 
linkFlag, 
misMatchFlag, 
mismatchedFieldsCount,
mismatchedFields)
select * from getAll
where linkFlag is not null

go

