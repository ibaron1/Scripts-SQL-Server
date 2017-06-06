#!/bin/ksh
#PS4='line $LINENO: '
##################################################################################################################
### Script Name: CopyMissedProcsViews.sh								       ###
### Author: Eli Baron											       ###
### Date: 4/7/2006											       ###
### Purpose: Imports procs/views from the source to target server, Run_Showplan_All.sh will drop them          ###
### Parameters:												       ###
### SourceServer SourceServerLoginID SourceServerPasswd TestServer TestServerLoginID TestServerPasswd  Db      ###
##################################################################################################################

########## Get Procs & Views from SOURCE SERVER DB
echo "set nocount on" > $LogDir/tmpobj
echo "select object_name(d.id)" >> $LogDir/tmpobj
echo "from sysdepends d join sysobjects o" >> $LogDir/tmpobj
echo "on d.id=o.id and o.type='P' and d.depid=object_id('$Table') and object_name(d.id) not like 'rs_%'" >> $LogDir/tmpobj
echo "go" >> $LogDir/tmpobj
$SYB/isql -b -D$Db -S$SrcSrv -U$Usr -P$PW -i$LogDir/tmpobj -o$ProcSrcList 

echo "set nocount on" > $LogDir/tmpobj
echo "select object_name(d.id)" >> $LogDir/tmpobj
echo "from sysdepends d join sysobjects o" >> $LogDir/tmpobj
echo "on d.id=o.id and o.type='V' and d.depid=object_id('$Table')" >> $LogDir/tmpobj
echo "go" >> $LogDir/tmpobj
$SYB/isql -b -D$Db -S$SrcSrv -U$Usr -P$PW -i$LogDir/tmpobj -o$ViewSrcList 

########## Get Procs & Views from TEST SERVER DB ###
echo "set nocount on" > $LogDir/tmpobj
echo "select object_name(d.id)" >> $LogDir/tmpobj
echo "from sysdepends d join sysobjects o" >> $LogDir/tmpobj
echo "on d.id=o.id and o.type='P' and d.depid=object_id('$Table') and object_name(d.id) not like 'rs_%'" >> $LogDir/tmpobj
echo "go" >> $LogDir/tmpobj
$SYB/isql -b -D$Db -S$SRV -U$UserName -P$PW1 -i$LogDir/tmpobj -o$ProcList 

echo "set nocount on" > $LogDir/tmpobj
echo "select object_name(d.id)" >> $LogDir/tmpobj
echo "from sysdepends d join sysobjects o" >> $LogDir/tmpobj
echo "on d.id=o.id and o.type='P' and d.depid=object_id('$Table') and object_name(d.id) not like 'rs_%'" >> $LogDir/tmpobj
echo "go" >> $LogDir/tmpobj
$SYB/isql -b -D$Db -S$SRV -U$UserName -P$PW1 -i$LogDir/tmpobj -o$ViewList 

if [[ `grep -v -f $ProcList $ProcSrcList > $LogDir/copiedprocs` ]];then
  continue
else
  echo "`cat $LogDir/copiedprocs|wc -l|tr -s ' '` PROCS from $SrcSrv..$Db  NOT FOUND in $SRV..$Db, WILL BE COPIED, DROPPED AT THE END in" >> $LogDir/tmp
  echo "--------------------------------------------------------------------------------------------------------------------------------">> $LogDir/tmp
  echo "$LogDir/exportedprocs" >> $LogDir/tmp
  echo "" >> $LogDir/tmp
fi

test -f $LogDir/exportedprocs && rm $LogDir/exportedprocs

for procnm in `cat $LogDir/copiedprocs`
do
echo $procnm >> $LogDir/exportedprocs

$SYBASE/bin/defncopy -S$SrcSrv -U$Usr -P$PW out $LogDir/proctmp ${Db} $procnm > $LogDir/exportedprocs

test -s $LogDir/proctmp
if [[ $? -eq 1 ]];then
echo "NO PROC TEXT IN SYSCOMMENTS FOR $procnm" >> $LogDir/tmp
continue
fi

awk '/#define temp table/,/#enddef/' $LogDir/proctmp|sed '/#define temp table/d;/#enddef/d' > $CreaTmpTbl/$procnm
echo "go" >> $CreaTmpTbl/$procnm
cat $LogDir/proctmp >> $CreaTmpTbl/$procnm
echo "go" >> $CreaTmpTbl/$procnm

$SYB/isql -D$Db -S$SRV -U$UserName -P$PW1 <<! >> $LogDir/tmp
`cat $CreaTmpTbl/$procnm`
!
done

test -f $LogDir/exportedviews && rm $LogDir/exportedviews

if [[ `grep -v -f $ViewList $ViewSrcList > $LogDir/copiedviews` ]];then
  continue
else
  echo "`cat $LogDir/copiedviews|wc -l|tr -s ' '` VIEWS from $SrcSrv..$Db  NOT FOUND in $SRV..$Db, WILL BE COPIED, DROPPED AT THE END in" >> $LogDir/tmp
  echo "--------------------------------------------------------------------------------------------------------------------------------" >> $LogDir/tmp
  echo "$LogDir/exportedviews" >> $LogDir/tmp
fi

for view in `cat $LogDir/copiedviews`
do
echo $view >> $LogDir/exportedviews

$SYBASE/bin/defncopy -S$SrcSrv -U$Usr -P$PW out $LogDir/viewtmp ${Db} $view >> $LogDir/exportedviews

test -s $LogDir/viewtmp
if [[ $? -eq 1 ]];then
echo "NO VIEW TEXT IN SYSCOMMENTS FOR $view" >> $LogDir/tmp
continue
fi

$SYBASE/bin/defncopy -S$SRV -U$UserName -P$PW1 in $LogDir/viewtmp ${Db} >> $LogDir/exportedviews

done
echo "" >> $LogDir/tmp
