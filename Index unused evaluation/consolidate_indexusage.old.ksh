#!/bin/ksh
#############################################################
### Script Name: consolidate_indexusage.ksh
### Author: Ilya Baron 
### Date created: 03/21/2006 
### (Morgan Stanley in collaboration w Sybase)
### Version 1.0
### Date modified: 03/25/2008 (IFS;  executing from sunray-1)
### Version 2.0
### (IFS)
### Modified detailed and created summary consolidated tables
### Purpose: Index usage data warehouse for a list of servers
#############################################################

SYB="/usr/local/sybase/bin"
UserName=p489920
UserName1=monuser
ReportSrvr=GLSRD
PWDir="/var/tmp/p489920/IndexEval/EvalIndexUnused"
PWFile=pf
PWFile1=pf1
RptDir=$PWDir/indexUsage
LogDir="${RptDir}/log"

## Dataserver list 

echo GLSR  > ${RptDir}/SrvLst
echo GLSR2 >> ${RptDir}/SrvLst

## Databases list of which indexes activity to be imported

echo GPS   > ${RptDir}/Dbs
echo GPS3 >> ${RptDir}/Dbs
echo GPS4 >> ${RptDir}/Dbs
echo GPS5 >> ${RptDir}/Dbs

MailList="Ilya.Baron@imsi.com"

chmod 400 ${PWDir}/$PWFile
PW=`cat ${PWDir}/$PWFile`
chmod 000 ${PWDir}/$PWFile

chmod 400 ${PWDir}/$PWFile1
PW1=`cat ${PWDir}/$PWFile1`
chmod 000 ${PWDir}/$PWFile1

LogName=${LogDir}/`date +%m%d%Y`.log

echo "Log name: $LogName on $ReportSrvr" > $LogName
echo "" >>  $LogName
echo "Index usage from databases:" >> $LogName 
echo "--------------------------" >> $LogName
cat ${RptDir}/Dbs >> $LogName
echo "" >> $LogName
echo "On dataservers:" >> $LogName
echo "--------------" >> $LogName  
cat ${RptDir}/SrvLst >> $LogName

#### Server with MDA historical db
${SYB}/isql -S$ReportSrvr -U$UserName1 -P$PW1 <<! > /dev/null
if not exists (select '1' from monitordb..sysobjects where name='indexusage')
CREATE TABLE monitordb..indexusage
(
    SrvName          varchar(20) NOT NULL,
    DB		     varchar(30) NOT NULL,
    TableName        varchar(30) NULL,
    IndexName        sysname     NOT NULL,
    ReportDate       char(8)     NOT NULL,
    CountersCleared  char(19)    NULL,
    Days 	     int	 NULL,
    QryPlanCount     int         NOT NULL,
    UsedCount        int         NOT NULL
)
create unique clustered index i1 on monitordb..indexusage(SrvName,DB,TableName,IndexName,ReportDate)
create index i2 on monitordb..indexusage(TableName,IndexName)
go

if not exists (select '1' from monitordb..sysobjects where name='indexusage_summary')
CREATE TABLE monitordb..indexusage_summary
(
    SrvName        varchar(20) NOT NULL,
    DB             varchar(30) NOT NULL,
    TableName      varchar(30) NULL,
    IndexName      sysname     NOT NULL,
    Type           varchar(14)  NOT NULL,
    Resv_Mb        numeric(9,3) NULL,
    QryPlanCount   int         NOT NULL,
    UsedCount      int         NOT NULL,
    Note           varchar(22) NULL
)
create unique clustered index i1 on monitordb..indexusage_summary(SrvName,DB,TableName,IndexName)
create index i2 on monitordb..indexusage_summary(TableName,IndexName)
go
!

for srv in `cat ${RptDir}/SrvLst`
do

${SYB}/isql -S$srv -D$Db -U$UserName -P$PW <<! > /dev/null
if exists (select '1' from tempdb..sysobjects where name='indexusage')
  drop table tempdb..indexusage
go
CREATE TABLE tempdb..indexusage
(
    SrvName          varchar(20) NOT NULL,
    DB               varchar(30) NOT NULL,
    TableName        varchar(30) NULL,
    IndexName        sysname     NOT NULL,
    ReportDate       char(8)     NOT NULL,
    CountersCleared  char(19)    NULL,
    Days             int         NULL,
    QryPlanCount     int         NOT NULL,
    UsedCount        int         NOT NULL
)
go
!

for Db in `cat ${RptDir}/Dbs`
do

${SYB}/isql -S$ReportSrvr -U$UserName1 -P$PW1 <<! > /dev/null
if exists (select '1' from tempdb..sysobjects where name='mon_indexusage')
  drop table tempdb..mon_indexusage
go
CREATE TABLE tempdb..mon_indexusage
(
    SrvName          varchar(20) NOT NULL,
    DB               varchar(30) NOT NULL,
    TableName        varchar(30) NULL,
    IndexName        sysname     NOT NULL,
    ReportDate       char(8)     NOT NULL,
    CountersCleared  char(19)    NULL,
    Days             int         NULL,
    QryPlanCount     int         NOT NULL,
    UsedCount        int         NOT NULL
)
go
truncate table tempdb..mon_indexusage
go
!

${SYB}/isql -S$srv -D$Db -U$UserName -P$PW <<! > /dev/null

set nocount on

truncate table tempdb..indexusage

declare @StartDate        datetime,
        @CountersCleared  datetime
        
-- since when did we start counting
select @StartDate       = StartDate,
       @CountersCleared = isnull(CountersCleared, StartDate)
from   master..monState

-- show index usage for current database

insert tempdb..indexusage
	(SrvName,DB,
	TableName,IndexName,
	ReportDate,CountersCleared,
	Days,
	QryPlanCount,
	UsedCount)
select 	@@servername,db_name(),
	object_name(i.id),i.name,
	convert(char(8),getdate(),112),convert(char(19),@CountersCleared,100),
	datediff(hh,@CountersCleared,getdate())/24,
	m.OptSelectCount,  --selected for query plan
	m.UsedCount        --used in query plan
from master..monOpenObjectActivity m,
     sysindexes i
where  m.DBID     = db_id()
and    m.ObjectID = i.id
and    m.IndexID  = i.indid
and object_name(i.id) <> i.name
and object_name(i.id) not like 'rs[_]%'
/*and    ((m.IndexID  > 0 and lockscheme(i.id, db_id()) = 'allpages') or
        (m.IndexID  > 1 and lockscheme(i.id, db_id()) <> 'allpages'))*/

go
!

$SYB/bcp tempdb..indexusage out ${RptDir}/${srv}.${Db}.bcp -S$srv -U$UserName -P$PW -c -t'|' -r\\n > /dev/null

#### Consolidate index usage
$SYB/bcp tempdb..mon_indexusage in ${RptDir}/${srv}.${Db}.bcp -S$ReportSrvr -U$UserName1 -P$PW1 -c -t'|' -r\\n > /dev/null

#### Index usage summary
${SYB}/isql -D$Db -S$ReportSrvr -U$UserName1 -P$PW1 <<! > /dev/null

-- Save details from server/db in detailed table

insert monitordb..indexusage
select * from tempdb..mon_indexusage

declare @StartDate        datetime,
        @CountersCleared  datetime
        
-- since when did we start counting
select @StartDate       = StartDate,
       @CountersCleared = isnull(CountersCleared, StartDate)
from   master..monState

declare @max_Mb           numeric(9,3),        
        @obj_reused       int,
        @idx_reused       int

-- check Num_reuse=0 to see that counters have not been scavenged
-- exec sp_monitorconfig 'number of open indexes'
-- exec sp_monitorconfig 'number of open objects'
select @obj_reused = config_admin(22, 107, 4, 0, 'open_object_reuse_requests', NULL)
select @idx_reused = config_admin(22, 263, 4, 0, 'open_index_reuse_requests', NULL)

-- find max space used by an index
-- if system state insufficient for rpting notes then set to null
-- i.e. 3 days data accumulated and nothing scavenged
if @obj_reused = 0 and @idx_reused = 0
and datediff(dd,@CountersCleared, getdate()) >= 3
begin
    select @max_Mb = convert(float,max(reserved_pgs(id, ioampg)))/512
    from   sysindexes
    where  indid > 1
end

-- show index usage for current database
-- Formula in 'Note' is just an initial stab

/**** update indexusage_summary if server.db.tbl.idx in there ****/

update monitordb..indexusage_summary
set QryPlanCount = case when s.QryPlanCount < i.QryPlanCount then i.QryPlanCount else s.QryPlanCount end,
    UsedCount = case when s.UsedCount < i.UsedCount then i.UsedCount else s.UsedCount end
from monitordb..indexusage_summary s,
     tempdb..mon_indexusage i
where s.SrvName   = i.SrvName
  and s.DB 	  = i.DB
  and s.TableName = i.TableName
  and s.IndexName = i.IndexName

/**** insert into indexusage_summary if server.db.tbl.idx not in there ****/

insert monitordb..indexusage_summary
select SrvName, DB, TableName, IndexName,
	case when i.status&2=2 and i.status&16=16 then 'unique CI' 
         when i.status&2=2 and i.status&16!=16 then 'unique NCI'
         when i.status&2!=2 and i.status&16=16 then 'nonunique CI' 
         when i.status&2!=2 and i.status&16!=16 then 'nonunique NCI'
         else '' end, -- Type 
	round(convert(float,reserved_pgs(i.id, i.ioampg))/512, 3), --Resv_Mb
	QryPlanCount,
	UsedCount,
	case  when UsedCount=0 and QryPlanCount=0 and @max_Mb<(convert(float,reserved_pgs(i.id, i.ioampg))/512)*100
                 then 'drop?'
                 when (iu.UsedCount>0 or QryPlanCount>0)
                      and  (power(convert(float,iu.UsedCount),2)+QryPlanCount)*@max_Mb<(convert(float,reserved_pgs(i.id, i.ioampg))/512)*200
                 then 'investigate'
                 else ' ' end --Note
from tempdb..mon_indexusage iu, sysindexes i   
where not exists 
	(select '1' from monitordb..indexusage_summary
	 where SrvName   = iu.SrvName
  	   and DB 	  = iu.DB
  	   and TableName = iu.TableName
  	   and IndexName = iu.IndexName)
and iu.TableName = object_name(i.id) and iu.IndexName = i.name

update monitordb..indexusage_summary
set Note = case  when UsedCount=0 and QryPlanCount=0 and @max_Mb<Resv_Mb*100
                 then 'drop?'
                 when (UsedCount>0 or QryPlanCount>0)
                      and  (power(convert(float,UsedCount),2)+QryPlanCount)*@max_Mb<Resv_Mb*200
                 then 'investigate'
                 else ' ' end

go
!

if [[ -s "${RptDir}/${srv}.bcp" ]];then
  echo >> $LogName
else
  echo "File for server $srv , database $Db is empty; report failed" >> $LogName
  echo >> $LogName
fi

done ## for database
done ## for server

for srv in `cat ${RptDir}/SrvLst`
do

${SYB}/isql -S$srv -D$Db -U$UserName -P$PW <<! > /dev/null
if exists (select '1' from tempdb..sysobjects where name='indexusage')
  drop table tempdb..indexusage
go
!
done

$SYB/bcp monitordb..indexusage_summary out ${RptDir}/indexusage_summary.bcp -S$ReportSrvr -U$UserName1 -P$PW1 -c -t'|' -r\\n > /dev/null

echo "Detailed index usage is in $ReportSrvr.monitordb..indexusage" >> $LogName
echo "" >> $LogName
echo "Summary index usage is in $ReportSrvr.monitordb..indexusage_summary" >> $LogName
echo "and was exported to ${RptDir}/indexusage_summary.bcp on $ReportSrvr" >> $LogName

mailx -s "Index usage import status on `date`" $MailList < $LogName

