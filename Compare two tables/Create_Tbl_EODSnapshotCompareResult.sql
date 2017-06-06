if OBJECT_ID('srf_main.EODSnapshotCompareResult') is not null
  drop table srf_main.EODSnapshotCompareResult
go
create table srf_main.EODSnapshotCompareResult
(cobDate date, 
publisher varchar(100) null,
reportingJurisdiction varchar(100),
tradeParty1TransactionId varchar(100),
tradeParty2TransactionId varchar(100),  
linkFlag varchar(100) null, 
misMatchFlag varchar(100) null, 
mismatchedFieldsCount varchar(100) null,
mismatchedFields varchar(max))

create clustered index i on srf_main.EODSnapshotCompareResult(cobDate,publisher,tradeParty1TransactionId,tradeParty2TransactionId)

go
