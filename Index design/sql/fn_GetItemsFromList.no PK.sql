SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- ==================================================================
-- Author Eli Baron
-- Create date 2013-11-08
-- Description Get items from list
-- JIRA SRF-3414 to get jurisdiction per row 
-- from a list of jurisdictions in TradeMessage.ReportingJuridictions
-- Modified by
-- Eli Baron   due to exception in SFreportEOD_pending
-- datatype for @Pos was changed from tinyint to int, JIRA SRF-5663
-- ==================================================================
ALTER Function [srf_main].[fn_GetItemsFromList]
	(@List Varchar(max), @Delimiter char(1))
Returns @Items 
Table (Item varchar(max))
As
Begin
 Declare @Item Varchar(max), @Pos int
 While Len(@List)  0 
 Begin
 Set @Pos = CharIndex(@Delimiter, @List)
 If @Pos = 0 Set @Pos = Len(@List) + 1 
 Set @Item = Left(@List, @Pos - 1)
 Insert @Items 
 Select Ltrim(Rtrim(@Item))
 Set @List = 
     SubString(@List, @Pos + case when @Delimiter=' ' then 1 else Len(@Delimiter) end, Len(@List))

 End
 Return
End