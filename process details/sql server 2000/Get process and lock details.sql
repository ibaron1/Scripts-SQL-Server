use riskbook
go
declare @dbname varchar(100)
set @dbname = 'riskbook'

select
spid, blocked, status, cmd, loginame,  
db_name(rsc_dbid) db, 
object_name(rsc_objid) tbl, --rsc_objid,
case rsc_type 
when 1 then 'NULL Resource (not used)'
when 2 then 'Database'
when 3 then 'File'
when 4 then 'Index'
when 5 then 'Table'
when 6 then 'Page'
when 7 then 'Key'
when 8 then 'Extent'
when 9 then 'RID (Row ID)'
when 10 then 'Application' 
end rsc_type, -- Resource type 
case req_mode 
	when 1 then 'Sch-S (Schema stability)'
	when 2 then 'Sch-M (Schema modification)'
	when 3 then 'S (Shared)'
	when 4 then 'U (Update)'
	when 5 then 'X (Exclusive)'
	when 6 then 'IS (Intent Shared)'
	when 7 then 'IU (Intent Update)'
	when 8 then 'IX (Intent Exclusive)'
	when 9 then 'SIU (Shared Intent Update)'
	when 10 then 'SIX (Shared Intent Exclusive)'
	when 11 then 'UIX (Update Intent Exclusive)'
	when 12 then 'BU. Used by bulk operations'
	when 13 then 'RangeS_S (Shared Key-Range and Shared Resource lock)'
	when 14 then 'RangeS_U (Shared Key-Range and Update Resource lock)'
	when 15 then 'RangeI_N (Insert Key-Range and Null Resource lock)'
	when 16 then 'RangeI_S. Key-Range Conversion lock, created by an overlap of RangeI_N and S locks'
	when 17 then 'RangeI_U. Key-Range Conversion lock, created by an overlap of RangeI_N and U locks'
	when 18 then 'RangeI_X. Key-Range Conversion lock, created by an overlap of RangeI_N and X locks'
	when 19 then 'RangeX_S. Key-Range Conversion lock, created by an overlap of RangeI_N and RangeS_S. locks'
	when 20 then 'RangeX_U. Key-Range Conversion lock, created by an overlap of RangeI_N and RangeS_U locks'
	when 21 then 'RangeX_X (Exclusive Key-Range and Exclusive Resource lock). This is a conversion lock used when updating a key in a range'
end as lock_type,
case req_status 
when 1 then 'Granted' 
when 2 then 'Converting'
when 3 then 'Waiting' end req_status,
req_refcnt, -- Lock reference count. Every time a transaction asks for a lock on a particular resource, a reference count is incremented. The lock cannot be released until the reference count equals 0.
login_time, waittime, cpu, physical_io, memusage, open_tran, program_name, hostname
from master..syslockinfo l
join master..sysprocesses p
on l.req_spid = p.spid
where db_name(rsc_dbid) = @dbname
and rsc_objid <> 0
order by tbl