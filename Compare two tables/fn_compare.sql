if object_id('[srf_main].[fn_compare]') is not null
  drop function srf_main.fn_compare
go
create Function [srf_main].[fn_compare](@item1 varchar(2000), @item2 varchar(2000))
returns smallint
 
begin
declare @i int

select @i = 
case when ISNUMERIC(@item1) = 0
     then case when isnull(@item1, '') = isnull(@item2, '') then 0
			   else 1 end
	 else case when @item1 = @item2 then 0
			   else 1 end
end
			   
return @i

end	

go




