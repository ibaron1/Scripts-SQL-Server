SET nocount on

INSERT queryplan1(line)
SELECT line FROM queryplan
WHERE line IS NOT NULL

/***** MAIN *****/

/**************************************************************** 
GET IF EXISTS "INDEX AS A HINT TO OPTIMIZER NOT FOUND" EXCEPTIONS
****************************************************************/
DECLARE @linenumMIN int, @linenumMAX int

SELECT @linenumMIN =  MIN(linenum) FROM queryplan1 
WHERE line like '%specified as optimizer hint in the FROM%'

SELECT @linenumMAX = MAX(linenum) FROM queryplan1 
WHERE line like '%Optimizer will choose another index instead%'

INSERT tblscan
SELECT line FROM queryplan1
WHERE linenum BETWEEN @linenumMIN AND @linenumMAX
go

declare queryplan_crsr cursor for
select linenum from queryplan1
where line like '%QUERY PLAN FOR STATEMENT%'
go

/******************************************** 
GET ALL TABLES SCANS FOR A STATEMENT IF EXIST
********************************************/
 
declare @MaxLineNum int, @i int
declare @linenum int, @CurrLineStmtNum int, @NextLineStmtNum int

select @MaxLineNum = max(linenum) FROM queryplan1

open queryplan_crsr 

fetch queryplan_crsr into @CurrLineStmtNum  

while @i=@i
begin

  fetch queryplan_crsr into @NextLineStmtNum  
  if @@sqlstatus = 2
    break

  if exists (select '1' from queryplan1
             where linenum >= @CurrLineStmtNum and linenum < @NextLineStmtNum and line like '%Table Scan%')
    insert tblscan
    select line from queryplan1 
    where linenum >= @CurrLineStmtNum and linenum < @NextLineStmtNum

  set @CurrLineStmtNum = @NextLineStmtNum

end

close queryplan_crsr 
deallocate cursor queryplan_crsr 

if exists (select '1' from queryplan1
           where linenum >= @CurrLineStmtNum and linenum < @MaxLineNum and line like '%Table Scan%')
  insert tblscan
  select line from queryplan1 
  where linenum >= @CurrLineStmtNum and linenum < @MaxLineNum

go

select * from tblscan

