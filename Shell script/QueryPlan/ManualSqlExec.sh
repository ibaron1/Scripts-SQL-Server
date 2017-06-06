#!/bin/ksh
#set -x
#PS4='line $LINENO: '
#############################################################################
### Script Name: ManualSqlExec.sh                                         ###
### Author: Eli Baron                                                     ###
### Date: 04/12/2006                                                      ###
### Purpose: Prepare sql string for failed exec and re-run thru showplan  ###
#############################################################################
if (( $# != 2 ));then
  print "Usage: $0 Table_name proc_name"
  exit
fi

Table=$1
procnm=$2

. ENV $Table

#### BEFORE RUNNING:
#### (1) create manually temp table(s) if it's the case in the file $crtempdbtbl/$procnm, directory
####                                       /ms/user/b/baroneli/IndexCorruption/TAPSGeneralAddress/crtempdbtbl
#### (2) create manually sql string execution if it's the case in the file $ProcDir/$procnm, directory
####                                       /ms/user/b/baroneli/IndexCorruption/TAPSGeneralAddress/execproc 
####       get sample params value from $getExecFromMDA dir

test -f $crtempdbtbl/$procnm || touch $crtempdbtbl/$procnm

$SYB/isql -D$Db -S$SRV -U$UserName -P$PW1 <<! > $ShowplanDir/$procnm
`cat $crtempdbtbl/$procnm`
go
set showplan on
go
set fmtonly on
go
`cat $ProcDir/$procnm`
go
!

grep -H Msg $ShowplanDir/$procnm|grep -h Level|grep -h State
