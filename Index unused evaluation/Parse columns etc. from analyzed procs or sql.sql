/*

 -- parse comma seperated string (of columns in where /group by /order by for index design/redesign/evaluation)
if exists (select * from tempdb..sysobjects where name='Unparsed')
  drop table tempdb..Unparsed
go
-- create file according to this table from analyzed procs, sql and bcp it into this:
create table tempdb..Unparsed  
(
procname    	varchar(30),
line#       	smallint,
keystring   	varchar(255),	-- like: acid, smsecid, lotid, tradedate, cancel_date,
note	    	varchar(255) default '',	-- if there are additional details to consider
forced_idx  	varchar(100) default ''	-- if there is a forced index
)  
go
if exists (select * from tempdb..sysobjects where name='Parsed')
  drop table tempdb..Parsed
go
-- Then parse keystring into:  
create table tempdb..Parsed  
(
procname        varchar(30),
line#           smallint,
candidate_key   varchar(255) -- like: acid, smsecid, lotid, tradedate, cancel_date
)  
go

*/

/* to get details if ones exists:





*/

declare parsing_crsr cursor for
select procname, line#, keystring from tempdb..Unparsed
go

declare @procname varchar(30), @line# smallint
declare @keystring varchar(2000), @start int, @end int
declare @key varchar(50)

set nocount on

--select @keystring = 'acid, smsecid, lotid, tradedate, cancel_date'

open parsing_crsr

fetch parsing_crsr into @procname, @line#, @keystring

while @@sqlstatus <> 2
begin  
    select @end = datalength(@keystring)

    while patindex("%,%", @keystring) > 0
    begin        
      select @key = ltrim(substring(@keystring, 1, patindex("%,%", @keystring)-1))
      
      --select @key

      insert tempdb..Parsed
      select ltrim(rtrim(@procname)), @line#, @key
         
      select @start = patindex("%,%", @keystring)

      select @keystring = substring(@keystring, @start+1,@end-@start)
      
    end

    --select ltrim(@keystring) -- for last word in a string

    insert tempdb..Parsed
    select ltrim(rtrim(@procname)), @line#, ltrim(@keystring)
    
    fetch parsing_crsr into @procname, @line#, @keystring
end

close parsing_crsr
deallocate cursor parsing_crsr