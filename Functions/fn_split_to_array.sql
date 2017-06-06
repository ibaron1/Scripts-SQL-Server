
USE tempdb 
GO
/****** object:	userDefinedFunction [dbo].[fn_split_to_array] Script Date
09/06/2011 11:20:58 ******/
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON 
GO
create	FUNCTION [dbo].[fn_split_to_array]
(@input AS varchar(max), @delimiter varchar(10))
returns @split_string table 
( line int,                                                                                                                                                                                                                                                                         outstr varchar(max) NULL)
AS
BEGIN
DECLARE @n_of_delimiters int, @i int, @lineno int
set @n_of_delimiters=DATALENGTH(replace(@input,@delimiter,@delimiter+'_')) - 
DATALENGTH(@input)

Select @i = 0,@lineno=0 

WHILE @i < @n_of_delimiters 
BEGIN
	SElect @i = @i + 1, @lineno=@lineno+1 

	INSERT INTO @split_string
	SELECT @lineno,LEFT(@input,charindex(@delimiter,@input)-1)
	SET @input=SUBSTRING(@input,CHARINDEX(@delimiter,@input)+1,20088000)
END

INSERT INTO @split_string VALUES(@lineno+1,@input)
RETURN
END
GO
