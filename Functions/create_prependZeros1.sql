-- ==================================================================
-- Author: Eli Baron
-- Create date: 2017-06-09
-- ==================================================================
create function dbo.prependZeros1(@input varchar(24), @nChars int) 
returns varchar(24)
as
begin
 return concat(replicate('0',@nChars-len(@input)),@input)
end 