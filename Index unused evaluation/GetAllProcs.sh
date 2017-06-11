#!/bin/ksh
#PS4='line $LINENO: '
#############################################################################
### Script Name: GetAllProcs.sh
### Author: Eli Baron
### Date: 03/31/2006
### Purpose: to generate proc's exec stmt and run showplan
#############################################################################
. ENV

allobj.sh

if [[ -d $RootDir/ProcDef ]];then
  rm -r $RootDir/ProcDef
fi
mkdir $RootDir/ProcDef

test -f $RootDir/execString.sql && rm $RootDir/execString.sql

for procnm in `cat $ProcList`
do
$SYBASE/bin/defncopy -S$SRV -U$UserName -P$PW out $RootDir/ProcDef/$procnm ${Db} $procnm

grep -h -w exec $RootDir/ProcDef/$procnm | sed '/@exec/d;/--/d;' | awk '{getline var; print var}' | sort -u >> $RootDir/execString.sql
done

echo ""
echo "Exec sql strings are in $RootDir/execString.sql"
echo ""

cd $RootDir/ProcDef

grep a2query_history *
