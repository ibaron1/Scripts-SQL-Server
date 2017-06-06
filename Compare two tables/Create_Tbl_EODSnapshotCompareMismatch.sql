if OBJECT_ID('srf_main.EODSnapshotCompareMismatch') is not null
  drop table srf_main.EODSnapshotCompareMismatch
go
create table srf_main.EODSnapshotCompareMismatch
(cobDate date, 
publisher varchar(100) null,
reportingJurisdiction varchar(100),
tradeParty1TransactionId varchar(100),
tradeParty2TransactionId varchar(100),  
mismatchedFieldName varchar(100), 
mismatchedFieldBWvalue varchar(100) null, 
mismatchedFieldFAEODvalue varchar(100) null,
)

create clustered index i on srf_main.EODSnapshotCompareMismatch(cobDate,publisher,tradeParty1TransactionId,tradeParty2TransactionId)

go

