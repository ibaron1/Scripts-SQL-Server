

select procname, line#, forced_idx 	-- get procs statements with forced index	
from tempdb..Unparsed 
where forced_idx like '%[0-Z]%' 

select p.procname, p.line#, candidate_key, -- get key details
isnull((select substring(note, charindex(p.candidate_key,note),patindex("%;%", substring(note, charindex(p.candidate_key,note),datalength(note)))-1) 
        from tempdb..Unparsed 
        where ltrim(rtrim(procname)) = p.procname and line# = p.line# and note like '%'+p.candidate_key+'%'),'join') note
from tempdb..Parsed p, tempdb..Unparsed u
where p.procname = ltrim(rtrim(u.procname)) and
      p.line# = u.line#

/***********************************************************
		Digest keys info 
***********************************************************/

set nocount on
declare @topkeys# int

set @topkeys# = 7

create table #key_weight (num numeric(3) identity, candidate_key varchar(30),Weight smallint)

set rowcount @topkeys#

insert #key_weight(candidate_key,Weight)
select candidate_key, count(*) Cnt
from tempdb..Parsed
group by candidate_key
order by 2 desc

set rowcount 0

select * from #key_weight where num <= @topkeys#

select distinct procname, line#, keystring
from tempdb..Unparsed
where  keystring like '%'+(select candidate_key from #key_weight where num=1)+'%'
and keystring like '%'+(select candidate_key from #key_weight where num=2)+'%'
and keystring like '%'+(select candidate_key from #key_weight where num=3)+'%'
and keystring like '%'+(select candidate_key from #key_weight where num=4)+'%'
and keystring like '%'+(select candidate_key from #key_weight where num=5)+'%'
and keystring like '%'+(select candidate_key from #key_weight where num=6)+'%'
and keystring like '%'+(select candidate_key from #key_weight where num=7)+'%'
and keystring like '%'+(select candidate_key from #key_weight where num=8)+'%'
and keystring like '%'+(select candidate_key from #key_weight where num=9)+'%'
and keystring like '%'+(select candidate_key from #key_weight where num=10)+'%'

drop table #key_weight
