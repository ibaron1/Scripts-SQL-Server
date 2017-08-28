USE TFM_Archive
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
if object_id('tfm.fn_GetItemsFromList') is not null
  drop function tfm.fn_GetItemsFromList
go

/************************************************
Author. Eli Baron
Date created. 8-10-17
Purpose. Jira WMTRACAPGO-336, Get items from list
************************************************/
create function tfm.fn_GetItemsFromList
	(@List Varchar(max), @Delimiter char(1))
Returns @Items table(Item varchar(896), id int identity, primary key nonclustered(Item, id)) --added identity column to guarantee unqueness for PK; otherwise will cause an exception
As
Begin
 Declare @Item Varchar(max), @Position int
 While Len(@List) > 0 
 Begin
 Set @Position = CharIndex(@Delimiter, @List)
 If @Position = 0 Set @Position = Len(@List) + 1 
 Set @Item = Left(@List, @Position - 1)
 Insert @Items 
 Select Ltrim(Rtrim(@Item))
 Set @List = 
     SubString(@List, @Position + case when @Delimiter=' ' then 1 else Len(@Delimiter) end, Len(@List))

 End
 Return
End

GO