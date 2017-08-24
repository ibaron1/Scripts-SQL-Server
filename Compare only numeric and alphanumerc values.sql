declare @a varchar(20), @b varchar(20)

select @a = '     1234b6   ', @b = ' 1234b6 '

-- to compare alphanumeric values
if ltrim(rtrim(@a)) = ltrim(rtrim(@b)) 
  print 'y'
else
  print 'n'

-- to compare only numeric values 
if ISNUMERIC(@a) = 1 and ISNUMERIC(@b) = 1
begin
	if CAST(@a as int) = CAST(@b as int)
	  print 'y'
	else
	  print 'n'
end
