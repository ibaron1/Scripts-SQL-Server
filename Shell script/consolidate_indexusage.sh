#!/bin/ksh
#############################################################
### Script Name: indexusage_bcp.sh
### Author: Eli Baron
### Date: 03/10/2006
### Purpose: To run index usage reports for a list of servers
#############################################################

SYB="/ms/dist/aurora/bin"
UserName="RDGAudit"
PWDir="/ms/user/b/baroneli/a2query/scripts"
PWFile="rdgaudit"
Db=a2query
UserName1=baroneli
RptDir="/ms/user/b/baroneli/indexUsage"
LogDir="/ms/user/b/baroneli/indexUsage/log"
SrvLst="SrvList"
#MailList="Eli.Baron@morganstanley.com Ramesh.Allu@morganstanley.com"
MailList="Eli.Baron@morganstanley.com"

chmod 400 ${PWDir}/$PWFile
PW=`cat ${PWDir}/$PWFile`
chmod 000 ${PWDir}/$PWFile

CurrDir=`date +%m%d%Y`
LogName=${LogDir}/${CurrDir}.log

if [[ -d ${RptDir}/$CurrDir ]];then
  rm -r ${RptDir}/$CurrDir
fi

mkdir ${RptDir}/$CurrDir

CurRptDir=${RptDir}/$CurrDir

echo NYP_A2_U> ${CurRptDir}/${SrvLst}
echo NYP_A2_UT>> ${CurRptDir}/${SrvLst}
echo NYP_A2_UQ>> ${CurRptDir}/${SrvLst}
echo NYP_A2_UQ_2>> ${CurRptDir}/${SrvLst}
echo NYP_A2_UT_2>> ${CurRptDir}/${SrvLst}
echo NYP_A2_UT_FID>> ${CurRptDir}/${SrvLst}
echo NYP_A2_AUDIT>> ${CurRptDir}/${SrvLst}
echo NYP_A2_UT_2L>> ${CurRptDir}/${SrvLst}
echo NYP_A2_UT_IED>> ${CurRptDir}/${SrvLst}
echo LNP_A2_UT>> ${CurRptDir}/${SrvLst}
echo LNP_A2_UQ>> ${CurRptDir}/${SrvLst}
echo LNP_A2_UT_2>> ${CurRptDir}/${SrvLst}
echo TKP_A2_UT>> ${CurRptDir}/${SrvLst}
echo TKP_A2_UQ>> ${CurRptDir}/${SrvLst}
echo HKP_A2_UT>> ${CurRptDir}/${SrvLst}
echo HKP_A2_UQ>> ${CurRptDir}/${SrvLst}

echo "Reports directory: ${CurRptDir}" > ${LogName}
echo "Log name: ${LogName}" >> ${LogName}
echo "" >>  ${LogName}
echo "Dataservers:"  >> ${LogName} 
echo "------------" >> ${LogName}

chmod 400 ${PWDir}/usr
PW1=`cat ${PWDir}/usr`
chmod 000 ${PWDir}/usr

${SYB}/isql -SNYQ_A2_INT2 -U$UserName1 -P$PW1 <<! >> ${LogName}

if exists (select '1' from tempdb..sysobjects where name='indexusage')
  drop table tempdb..indexusage
go

CREATE TABLE tempdb..indexusage
(
    SrvName        varchar(20) NOT NULL,
    ReportDate     char(8)     NOT NULL,
    ObjectName     varchar(30) NULL,
    UpdStatLastRun datetime    NOT NULL,
    IndexName      sysname     NOT NULL,
    Type           varchar(4)  NOT NULL,
    Resv_Mb        varchar(7)  NULL,
    QryPlanCount   int         NOT NULL,
    UsedCount      int         NOT NULL,
    Note           varchar(22) NULL
)
go
!

for srv in `cat ${CurRptDir}/${SrvLst}`
do

${SYB}/isql -S$srv -U$UserName -P$PW <<! >> ${LogName}
--added by EB
if exists (select '1' from tempdb..sysobjects where name='indexusage')
  drop table tempdb..indexusage
go

use a2query
go

/**************************************************************
 Sql written by Keith Seaman
 Reports index usage
 Modified by Eli Baron to consolidate data for further analysis
**************************************************************/ 

set nocount on

declare @max_Mb           float,
        @StartDate        datetime,
        @CountersCleared  datetime,
        @obj_reused       int,
        @idx_reused       int

-- since when did we start counting
select @StartDate       = StartDate,
       @CountersCleared = CountersCleared
from   master..monState

-- check Num_reuse=0 to see that counters have not been scavenged
-- exec sp_monitorconfig 'number of open indexes'
-- exec sp_monitorconfig 'number of open objects'
select @obj_reused = config_admin(22, 107, 4, 0, 'open_object_reuse_requests', NULL)
select @idx_reused = config_admin(22, 263, 4, 0, 'open_index_reuse_requests', NULL)

-- display relevant heading information
select 'Server'        = "$srv",
       'Database'      = db_name(),
       rptDate         = convert(char(19),getdate(),100),
       CountersCleared = convert(char(19),@CountersCleared,100),
       Days            = str(convert(float,datediff(hh,@CountersCleared,getdate()))/24,4,1),
       obj_scavenged   = @obj_reused,
       idx_scavenged   = @idx_reused

-- show index usage for current database
select ObjectName   = object_name(i.id),
       IndexName    = i.name,
       i.indid,
       IdxType      = case when i.status & 2 = 2 then 'uniq' else '' end,
       Resv_Mb      = convert(float,reserved_pgs(i.id, i.ioampg))/512,
       QryPlanCount = m.OptSelectCount,  --selected for query plan
       m.UsedCount,                      --used in query plan
       i.crdate
into   #index
from   master..monOpenObjectActivity m,
       --sysobjects o,
       sysindexes i
where  m.DBID     = db_id()
--and    m.ObjectID = o.id
and    m.ObjectID = i.id
and    m.IndexID  = i.indid
and    ((m.IndexID  > 0 and lockscheme(i.id, db_id()) = 'allpages') or (m.IndexID  > 1 and lockscheme(i.id, db_id()) <> 'allpages'))
 --added by EB, originally was: IndexID  > 1, valid only for datapages or datarows

-- find max space used by an index
-- if system state insufficient for rpting notes then set to null
-- i.e. 3 days data accumulated and nothing scavenged
if @obj_reused = 0 and @idx_reused = 0
and datediff(dd,@CountersCleared, getdate()) > 3
begin
    select  @max_Mb = convert(float,max(reserved_pgs(id, ioampg)))/512
    from   sysindexes
    where  indid > 1
end

-- show index usage for current database
-- Formula in 'Note' is just an initial stab
select SrvName = convert(varchar(20), "$srv"),  --added by EB
       'ReportDate'     = convert(char(8),getdate(),112),
       ObjectName,
       UpdStatLastRun = stat.moddate, --added by EB
       IndexName,
       'Type'       = IdxType,
       Resv_Mb      = str(Resv_Mb,7,1),
       QryPlanCount,
       i.UsedCount,
       Note         = case when crdate>@CountersCleared
                           then 'crdate ' + convert(char(3),crdate,109)
                                + substring(convert(char(7),crdate,109),5,3) + convert(char(5),crdate,108)
                           when IdxType='uniq' then ''
                           when i.UsedCount=0 and QryPlanCount=0 and @max_Mb<Resv_Mb*100
                           then 'drop?'
                           when (i.UsedCount>0 or QryPlanCount>0)
                           and  (power(convert(float,i.UsedCount),2)+QryPlanCount)*@max_Mb<Resv_Mb*200
                           then 'investigate'
                           else ' ' end
into tempdb..indexusage
from   #index i join (select distinct id, convert(char(8),moddate,112) from  sysstatistics) stat(id,moddate)
on object_id(ObjectName)=stat.id
order by ObjectName, indid

drop table #index
go
!

$SYB/bcp tempdb..indexusage out ${CurRptDir}/${srv}.bcp -S$srv -U$UserName -P$PW -c -t'|' -r\\n > /dev/null

$SYB/bcp tempdb..indexusage in ${CurRptDir}/${srv}.bcp -SNYQ_A2_INT2 -U$UserName1 -P$PW1 -c -t'|' -r\\n >> ${LogName}

if [[ -s "${CurRptDir}/${srv}.bcp" ]];then
  echo >> ${LogName}
else
  echo 'File is empty; report failed' >> ${LogName}
  echo >> ${LogName}
fi

echo '***************************************************************' >> ${LogName}
echo >> ${LogName}

done

$SYB/bcp tempdb..indexusage out ${CurRptDir}/consolidated_indexusage.bcp -SNYQ_A2_INT2 -U$UserName1 -P$PW1 -c -t'|' -r\\n >> /dev/null

echo "THE CONSOLIDATED INDEX USAGE REPORT FOR THE ABOVE LISTED SERVERS IS IN NYQ_A2_INT2.tempdb..indexusage" >> ${LogName}
echo "AND WAS BCPed OUT TO ${CurRptDir}/consolidated_indexusage.bcp" >> ${LogName}

mailx -s "Index usage Report for dataservers as of `date`" $MailList < ${LogName}
