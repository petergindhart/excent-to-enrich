IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[CamelCase]') AND xtype in (N'FN', N'IF', N'TF'))
DROP FUNCTION [dbo].[CamelCase]
GO

CREATE  Function [dbo].[CamelCase](@Str varchar(8000))
RETURNS varchar(8000) As
Begin
	if @Str is null
		return null
		
	Declare @Result varchar(2000)
	SET @Str = LOWER(@Str) + ' '
	SET @Result = ''

	While 1=1
	Begin
	        IF PATINDEX('% %',@Str) = 0 BREAK
		SET @Result = @Result+UPPER(Left(@Str,1))+SubString(@Str,2,CharIndex(' ',@Str)-1)
		SET @Str = SubString(@Str,CharIndex(' ',@Str)+1,Len(@Str))
	End
	SET @Result = Left(@Result,Len(@Result))
	Return @Result
End


