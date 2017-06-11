#!/bin/ksh
#############################################################
### Script Name: consolidate_indexusage.ksh
### Author: Ilya Baron 
### Date created: 03/21/2006 
### (Morgan Stanley, Sybase provided formula)
### Version 1.0
### Date modified: 05/14/2008
### (IFS)
### Version 2.0
### Modified detailed and summary consolidated tables
### Purpose: Index usage for a list of servers
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
    TableName        varchar(30) NOT NULL,
    IndexName        varchar(30) NOT NULL,
    Type             varchar(14) NOT NULL,
    ReportDate       char(8)     NOT NULL,
    CountersCleared  char(19)    NULL,
    Days 	     int	 NULL,
    QryPlanCount     int         NOT NULL,
    UsedCount        int         NOT NULL,
    indexSize_MB     numeric(24,4) NOT NULL
)
create unique clustered index i1 on monitordb..indexusage(SrvName,DB,TableName,IndexName,ReportDate)
create index i2 on monitordb..indexusage(TableName,IndexName)
go

if not exists (select '1' from monitordb..sysobjects where name='indexusage_summary')
CREATE TABLE monitordb..indexusage_summary
(
    SrvName        varchar(20) NOT NULL,
    DB             varchar(30) NOT NULL,
    TableName      varchar(30) NOT NULL,
    IndexName      varchar(30) NOT NULL,
    Type           varchar(14) NOT NULL,
    QryPlanCount   int         NOT NULL,
    UsedCount      int         NOT NULL,
    indexSize_MB     numeric(24,4) NOT NULL,
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
    TableName        varchar(30) NOT NULL,
    IndexName        varchar(30) NOT NULL,
    Type           varchar(14) NOT NULL,
    ReportDate       char(8)     NOT NULL,
    CountersCleared  char(19)    NULL,
    Days             int         NULL,
    QryPlanCount     int         NOT NULL,
    UsedCount        int         NOT NULL,
    indexSize_MB     numeric(24,4) NOT NULL,
    max_indexSize_MB numeric(24,4) NOT NULL
)
go
!

for Db in `cat ${RptDir}/Dbs`
do

${SYB}/isql -S$ReportSrvr -U$UserName1 -P$PW1 <<! > /dev/null
if exists (select '1' from tempdb..sysobjects where name='indexusage')
  drop table tempdb..mon_indexusage
go
CREATE TABLE tempdb..mon_indexusage
(
    SrvName          varchar(20) NOT NULL,
    DB               varchar(30) NOT NULL,
    TableName        varchar(30) NOT NULL,
    IndexName        varchar(30) NOT NULL,
    Type           varchar(14) NOT NULL,
    ReportDate       char(8)     NOT NULL,
    CountersCleared  char(19)    NULL,
    Days             int         NULL,
    QryPlanCount     int         NOT NULL,
    UsedCount        int         NOT NULL,
    indexSize_MB     numeric(24,4) NOT NULL,
    max_indexSize_MB numeric(24,4) NOT NULL
)
go
truncate table tempdb..mon_indexusage
go
!

${SYB}/isql -S$srv -D$Db -U$UserName -P$PW <<! > /dev/null

set nocount on

declare @StartDate        datetime,
        @CountersCleared  datetime
        
-- since when did we start counting
select @StartDate       = StartDate,
       @CountersCleared = isnull(CountersCleared, StartDate)
from   master..monState

declare @max_indexSize_MB           numeric(24,4),        
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
/*
if @obj_reused = 0 and @idx_reused = 0
and datediff(dd,@CountersCleared, getdate()) >= 3
  begin
    select @max_indexSize_MB = convert(numeric(24,4),max(reserved_pgs(id, ioampg))/512.0)
    from   sysindexes
    where  indid > 1
  end
*/

select @max_indexSize_MB = convert(numeric(24,4),max(reserved_pgs(id, ioampg))/512.0)
from   sysindexes
where  ((indid  > 0 and lockscheme(id, db_id()) = 'allpages') or
        (indid  > 1 and lockscheme(id, db_id()) <> 'allpages'))
        
truncate table tempdb..indexusage

-- show index usage for current database

insert tempdb..indexusage
	(SrvName,DB,
	TableName,IndexName,
	Type,
	ReportDate,
        CountersCleared,
	Days,
	QryPlanCount,
	UsedCount,
        indexSize_MB,
        max_indexSize_MB)
select 	@@servername,db_name(),
	object_name(i.id),i.name,
	case when i.status&2=2 and i.status&16=16 then 'unique CI' 
           when i.status&2=2 and i.status&16!=16 then 'unique NCI'
           when i.status&2!=2 and i.status&16=16 then 'nonunique CI' 
           when i.status&2!=2 and i.status&16!=16 then 'nonunique NCI'
           else '' end,
	convert(char(8),getdate(),112),
        convert(char(19),@CountersCleared,100),
	datediff(hh,@CountersCleared,getdate())/24,
	m.OptSelectCount,  --selected for query plan
	m.UsedCount,        --used in query plan
	convert(numeric(24,4),reserved_pgs(i.id, i.ioampg)/512.0),
	@max_indexSize_MB
from master..monOpenObjectActivity m,
     sysindexes i
where  m.DBID     = db_id()
and    m.ObjectID = i.id
and    m.IndexID  = i.indid
and object_name(i.id) <> i.name
and object_name(i.id) not like 'rs[_]%'
and    ((indid  > 0 and lockscheme(id, db_id()) = 'allpages') or
        (indid  > 1 and lockscheme(id, db_id()) <> 'allpages'))

go
!

$SYB/bcp tempdb..indexusage out ${RptDir}/${srv}.${Db}.bcp -S$srv -U$UserName -P$PW -c -t'|' -r\\n > /dev/null

#### Consolidate index usage
$SYB/bcp tempdb..mon_indexusage in ${RptDir}/${srv}.${Db}.bcp -S$ReportSrvr -U$UserName1 -P$PW1 -c -t'|' -r\\n > /dev/null

#### Index usage summary
${SYB}/isql -S$ReportSrvr -U$UserName1 -P$PW1 <<! > /dev/null

-- Save details from server/db in detailed table

insert monitordb..indexusage
(SrvName,
DB,
TableName,
IndexName,
Type,
ReportDate,
CountersCleared,
Days,
QryPlanCount,
UsedCount,
indexSize_MB)
select
    SrvName ,
    DB,
    TableName,
    IndexName,
    Type,
    ReportDate,
    CountersCleared,
    Days,
    QryPlanCount,
    UsedCount,
    indexSize_MB
from tempdb..mon_indexusage

-- show index usage for current database
-- Formula in 'Note' is just an initial stab

IF EXISTS 
	(select '1' from monitordb..indexusage_summary s, tempdb..mon_indexusage i
  		WHERE s.SrvName   = i.SrvName
    		and   s.DB 	  = i.DB
    		and   s.TableName = i.TableName
    		and   s.IndexName = i.IndexName)
BEGIN
/**** update indexusage_summary if server.db.tbl.idx in there ****/

  UPDATE monitordb..indexusage_summary
  SET QryPlanCount = case when s.QryPlanCount < i.QryPlanCount then i.QryPlanCount else s.QryPlanCount end,
    UsedCount 	 = case when s.UsedCount < i.UsedCount then i.UsedCount else s.UsedCount end,
    indexSize_MB = i.indexSize_MB
  FROM monitordb..indexusage_summary s,
     tempdb..mon_indexusage i
  WHERE s.SrvName   = i.SrvName
    and s.DB 	    = i.DB
    and s.TableName = i.TableName
    and s.IndexName = i.IndexName

END
ELSE
BEGIN
/**** insert into indexusage_summary if server.db.tbl.idx not in there ****/

  INSERT monitordb..indexusage_summary
  SELECT SrvName, DB, TableName, IndexName,
         Type,
	 QryPlanCount,
	 UsedCount,
	 indexSize_MB,
	 CASE  WHEN UsedCount=0 and QryPlanCount=0 and max_indexSize_MB<indexSize_MB*100
                 THEN 'drop?'
                 WHEN (UsedCount>0 or QryPlanCount>0)
                      and  (power(convert(float,UsedCount),2)+QryPlanCount)*max_indexSize_MB<indexSize_MB*200
                 THEN 'investigate'
                 ELSE ' ' END --Note
  FROM tempdb..mon_indexusage 

END

UPDATE monitordb..indexusage_summary
SET Note = CASE  WHEN i.UsedCount=0 and i.QryPlanCount=0 and i.max_indexSize_MB<i.indexSize_MB*100
                 THEN 'drop?'
                 WHEN (i.UsedCount>0 or i.QryPlanCount>0)
                      and  (power(convert(float,i.UsedCount),2)+i.QryPlanCount)*i.max_indexSize_MB<i.indexSize_MB*200
                 THEN 'investigate'
                 ELSE ' ' END --Note
FROM monitordb..indexusage_summary s, tempdb..mon_indexusage i
WHERE s.SrvName   = i.SrvName
and   s.DB 	  = i.DB
and   s.TableName = i.TableName
and   s.IndexName = i.IndexName

go
!

if [[ -s "${RptDir}/${srv}.${Db}.bcp" ]];then
  echo >> $LogName
else
  echo "File for server $srv, database $Db is empty; report failed" >> $LogName
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