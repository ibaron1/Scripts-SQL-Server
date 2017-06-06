#!/bin/ksh
#PS4='line $LINENO: '
#set -x
##########################################
### Script Name: Get_sql_w_index_utilization.sh
### Author: Eli Baron
### Date: 03/27/2006
### Purpose: Scans query plans for index's table dependent procs/views to get procs/views utilizing this index
#################################################################################################################
if (( $# != 2 ));then
  print "Usage: $0 Table_name Index_name"
  exit
fi

Table=$1
Index=$2

. ENV $Table

cd $ShowplanDir

grep -H $Index *|grep -h 'Index :'|cut -d':' -f1|sort -u > $LogDir/tmp1
if [[ -s $LogDir/tmp1 ]]; then
  echo "PROCS USING INDEX ${Table}.${Index}" > $LogDir/tmpind
  echo "------------------" >> $LogDir/tmpind
  echo "" >> $LogDir/tmpind
  cat $LogDir/tmp1 >> $LogDir/tmpind
else
  echo "NO PROCS USE INDEX ${Table}.${Index}" >> $LogDir/tmpind
  echo "------------------" >> $LogDir/tmpind
fi

echo "" >> $LogDir/tmpind

cd $ShowplanViewDir
grep -H $Index *|grep -h 'Index :'|cut -d':' -f1|sort -u > $LogDir/tmp1

if [[ -s $LogDir/tmp1 ]]; then
  echo "VIEWS USING INDEX ${Table}.${Index}" >> $LogDir/tmpind
  echo "------------------" >> $LogDir/tmpind
  echo "" >> $LogDir/tmpind
  cat $LogDir/tmp1 >> $LogDir/tmpind
else
  echo "NO VIEWS USE INDEX ${Table}.${Index}" >> $LogDir/tmpind
  echo "------------------" >> $LogDir/tmpind
fi
######### DROP PROCS AND VIEWS FROM SOURCE SERVER'S DB BROUGHT INTO TEST SERVER #########
test -f $LogDir/tmp5 && rm $LogDir/tmp5
for procnm in `cat $LogDir/copiedprocs`
do
echo "if exists (select '1' from sysobjects where name='$procnm') drop proc $procnm" >> $LogDir/tmp5
done

for view in `cat $LogDir/copiedviews`
do
echo "if exists (select '1' from sysobjects where name='$view') drop view $view" >> $LogDir/tmp5
done

$SYB/isql -b -D$Db -S$SRV -U$UserName -P$PW1 <<!
`cat $LogDir/tmp5`
go
!

mail -s "${Table}.${Index} index utilization in procs/views" $MailList < $LogDir/tmpind
