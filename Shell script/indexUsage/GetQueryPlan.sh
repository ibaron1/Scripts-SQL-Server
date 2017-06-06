#!/bin/ksh

. ENV

procnm=$1
grep -w $procnm $RootDir/execString.sql > a
$SYB/isql -D$Db -S$SRV -U$UserName -P$PW <<! >> a
go
use $Db
go
select "Query plan for $procnm"
go
set showplan on
go
set fmtonly on
go
`grep -w $procnm $RootDir/execString.sql`
go
!

vi a
