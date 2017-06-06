#!/bin/ksh

export RootDir="/ms/user/b/baroneli/monitor"

if [ -d $RootDir/top ]; then
  rm -r $RootDir/top
fi
mkdir $RootDir/top

if [ -d $RootDir/iostat ]; then
  rm -r $RootDir/iostat
fi
mkdir $RootDir/iostat

if [ -d $RootDir/vmstat ]; then
  rm -r $RootDir/vmstat
fi
mkdir $RootDir/vmstat

while (( 1 ))
do

date > $RootDir/top/top.`date +%b%d`.`date +%T`
top -b -n1 >> $RootDir/top/top.`date +%b%d`.`date +%T`

iostat -k -t >> $RootDir/iostat/iostat.`date +%b%d`.`date +%T`

date > $RootDir/vmstat/vmstat.`date +%b%d`.`date +%T`
vmstat 5 5 >> $RootDir/vmstat/vmstat.`date +%b%d`.`date +%T`

sleep 1800

done
