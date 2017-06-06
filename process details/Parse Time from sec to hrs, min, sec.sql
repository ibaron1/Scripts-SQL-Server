declare @a int

select @a=701515

select 
convert(varchar(6), case when @a/3600 > 0 then @a/3600 else 0 end)+' hr '+
convert(varchar(2), case when (@a%3600)/60 > 0 then (@a%3600)/60 else 0 end)+' min '+
convert(varchar(2), case when @a%3600-((@a%3600)/60)*60 > 0 then @a%3600-((@a%3600)/60)*60 else 0 end)+' sec'