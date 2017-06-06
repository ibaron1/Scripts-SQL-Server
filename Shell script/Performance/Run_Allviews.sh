#!/bin/ksh
#set -x
#PS4='line $LINENO: '
#############################################################################
### Script Name: Run_Allviews.sh                                          ###
### Author: Eli Baron                                                     ###
### Date: 05/23/2006                                                      ###
### Purpose: Log exec time for all views                                  ###
#############################################################################
. RUN_ENV
. RUN_INIT

execView=execView_w_indDropped

$SYB/isql -b -D$Db -S$SRV -U$UserName -P$PW <<! >$ViewList
if exists (select * from sysobjects where name="$execView")
  drop table $execView 
go
create table a2query..${execView} (viewname varchar(50), RunTime_ms int)
go
set nocount on
select name from sysobjects where type='V'
go
!

for view in `cat $ViewList`
do

$SYB/isql -b -D$Db -S$SRV -U$UserName -P$PW <<! > $RunViewDir/$view
declare @t datetime
select @t = getdate()

set rowcount 1000
select * from $view

insert a2query..${execView}
select "$view", datediff(ms, @t, getdate())
go
!

done
