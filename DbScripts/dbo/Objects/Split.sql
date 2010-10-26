SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Split]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[Split]
GO


CREATE FUNCTION dbo.Split(
	@s VARCHAR(8000), 
	@delimiter VARCHAR(1)
)  
RETURNS @item table(Item VARCHAR(255)) 
AS  
BEGIN 
	
	DECLARE @start INT
	DECLARE @end INT

	IF @s IS NOT NULL
	BEGIN
		SET @start = 1
		SET @end = CHARINDEX(@delimiter, @s, @start)
		
		WHILE @end <> 0
		BEGIN
			-- Insert item
			INSERT INTO @item VALUES (SUBSTRING(@s, @start, @end-@start))
		
			-- Find next item
			SET @start = @end + 1
			SET @end = CHARINDEX(@delimiter, @s, @start)
		END
		
		-- Insert last item
		INSERT INTO @item VALUES (SUBSTRING(@s, @start, LEN(@s)))
	END

	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
