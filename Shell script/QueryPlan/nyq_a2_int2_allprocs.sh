#!/bin/ksh
#set -x
#PS4='line $LINENO: '
#############################################################################
### Script Name: nyq_a2_int2_allprocs.sh
### Author: Eli Baron
### Date: 04/18/2006
### Purpose: to generate proc's exec stmt and run showplan
#############################################################################
SYB="/ms/dist/aurora/bin"
UserName=baroneli
PWDir="/ms/user/b/baroneli/a2query/scripts"
SRV=NYQ_A2_INT2
Db=a2query
LogDir="/ms/user/b/baroneli/QueryPlan"
ProcList="$LogDir/${Db}_ProcsList"
ProcsToSync=$LogDir/${Db}_ProcsToSync
ProcsToDrop=$LogDir/${Db}_ProcsToDrop

chmod 400 ${PWDir}/usr
PW=`cat ${PWDir}/usr`
chmod 000 ${PWDir}/usr

$SYB/isql -b -S$SRV -D$Db -U$UserName -P$PW <<!> $ProcList
set nocount on
select name from $Db..sysobjects where type='P' and name not like 'rs_%'
go
!

cat $ProcList|tr -d ' '>tmp
mv tmp $ProcList

ls $LogDir/a2query_Procs>tmp1

grep -v -f $ProcList tmp1 >$ProcsToSync

#grep -v -f tmp1 $ProcList >$ProcsToDrop

#for procnm in `cat $ProcsToDrop`
#do

#$SYB/isql -b -S$SRV -D$Db -U$UserName -P$PW <<!>/dev/null
#drop proc $procnm
#go
#!

#done

for procnm in `cat $ProcsToSync`
do

$SYBASE/bin/defncopy -S$SRV -U$UserName -P$PW in $LogDir/a2query_Procs/$procnm ${Db}

done


