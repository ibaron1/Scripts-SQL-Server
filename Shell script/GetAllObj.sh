#!/bin/ksh
#PS4='line $LINENO: '
#############################################################################
### Script Name: GetAllProcs.sh
### Author: Eli Baron
### Date: 03/31/2006
### Purpose: to generate proc's exec stmt and run showplan
#############################################################################
export SYB="/ms/dist/aurora/bin"
export PWDir="/ms/user/b/baroneli/misc"
export UserName="baroneli"

chmod 400 $PWDir/usr
export PW=`cat $PWDir/usr`
chmod 000 $PWDir/usr

export SRV=NYP_RDG_HUB
#export SRV="NYQ_A2_INT2"
export Db="a2query"

export RootDir="/ms/user/b/baroneli/DQSprocs"
export ProcList="$RootDir/procs"
export ViewList="$RootDir/views"
export DQSprocs="$RootDir/DQSprocs"
export DQSviews="$RootDir/DQSviews"
export MailList="Eli.Baron@morganstanley.com"

if [[ -d $DQSprocs ]];then
  rm -r $DQSprocs
fi
mkdir $DQSprocs

if [[ -d $DQSviews ]];then
  rm -r $DQSviews
fi
mkdir $DQSviews

allobj.sh

$SYB/isql -b -S$SRV -U$UserName -P$PW <<! > $ProcList
set nocount on
select name from tempdb..DQSproc
go
!

for procnm in `cat $ProcList`
do
$SYBASE/bin/defncopy -S$SRV -U$UserName -P$PW out $DQSprocs/$procnm ${Db} $procnm
done

$SYB/isql -b -S$SRV -U$UserName -P$PW <<! > $ViewList
set nocount on
select name from tempdb..DQSview
go
!

for view in `cat $ViewList`
do
$SYBASE/bin/defncopy -S$SRV -U$UserName -P$PW out $DQSviews/$view ${Db} $view
done

cd $DQSprocs

grep a2query_history *
