#!/bin/ksh
#PS4='line $LINENO: '
#############################################################################
### Script Name: GetAllProcs.sh
### Author: Eli Baron
### Date: 03/31/2006
### Purpose: to generate proc's exec stmt and run showplan
#############################################################################
SYB="/ms/dist/aurora/bin"
UserName=baroneli
PWDir="/ms/user/b/baroneli/a2query/scripts"
SRV=NYQ_A2_INT2
Db=a2query
LogDir="/ms/user/b/baroneli/IndexCorruption/TAPSGeneralAddress"
ProcList="$LogDir/${Db}_ProcsList"
Procs=$LogDir/${Db}_Procs

chmod 400 ${PWDir}/usr
PW=`cat ${PWDir}/usr`
chmod 000 ${PWDir}/usr

cd $LogDir

if [[ -d $Procs ]];then
  rm -r $Procs
fi
mkdir $Procs

$SYB/isql -S$SRV -U$UserName -P$PW <<!|sed '1,2d'> $ProcList
set nocount on
select name from $Db..sysobjects where type='P' and name not like 'rs_%'
go
!

for procnm in `cat $ProcList`
do

$SYBASE/bin/defncopy -S$SRV -U$UserName -P$PW out $Procs/$procnm ${Db} $procnm

done



