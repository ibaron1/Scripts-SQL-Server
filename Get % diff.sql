declare @a dec(20,4) = 1388,
@b dec(20,4) = 209

select 
case when @a > @b
	then cast(round(1.0*(@a-@b)/@b*100, 0) as int)
else cast(round(1.0*(@b-@a)/@a*100, 0) as int)
end 