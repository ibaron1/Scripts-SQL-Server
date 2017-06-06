#!/bin/ksh
#set -x
#PS4='line $LINENO: '
#############################################################################
### Script Name: ManualSqlExec.sh                                         ###
### Author: Eli Baron                                                     ###
### Date: 04/18/2006                                                      ###
### Purpose: Prepare sql string for failed exec and re-run thru showplan  ###
#############################################################################
procnm=$1

. ENV

#### BEFORE RUNNING:
#### (1) create manually temp table(s) if it's the case in the file $crtempdbtbl/$procnm, directory
####                                       /ms/user/b/baroneli/IndexCorruption/TAPSGeneralAddress/crtempdbtbl
#### (2) create manually sql string execution if it's a case in the file $ProcDir/$procnm, directory
####                                       /ms/user/b/baroneli/IndexCorruption/TAPSGeneralAddress/execproc 
####       get sample params value from $getExecFromMDA dir

test -f $crtempdbtbl/$procnm || touch $crtempdbtbl/$procnm

$SYB/isql -D$Db -S$SRV -U$UserName -P$PW <<! > $RunDir/$procnm
`cat $crtempdbtbl/$procnm`
go
set showplan on
go
set fmtonly on
go
`cat $ProcDir/$procnm`
go
!

grep -H Msg $RunDir/$procnm|grep -h Level|grep -h State
