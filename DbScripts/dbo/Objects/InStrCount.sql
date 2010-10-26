SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[InStrCount]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[InStrCount]
GO

CREATE FUNCTION dbo.InStrCount
	(@expression varchar(50), 
	 @search varchar(100))
RETURNS int
AS
BEGIN

DECLARE @code varchar(5)
DECLARE @count int
DECLARE @index int
DECLARE @temp varchar(50)

SET @count = 0
SET @index = DataLength(@expression) - 1
SET @temp = @expression

DECLARE tempCursor CURSOR
FOR SELECT  * from dbo.Split(@search, ',')

OPEN tempCursor

FETCH NEXT FROM tempCursor INTO @code
WHILE @@FETCH_STATUS = 0
BEGIN
	WHILE (DataLength(@expression) > 0)
	BEGIN
		SELECT @count = @count + CharIndex(@code, Left(@expression, 1))
		SELECT @expression = Right(@expression, @index)
		SELECT @index = @index - 1
	END
	SELECT @expression = @temp
	SET @index = DataLength(@expression) - 1
	FETCH NEXT FROM tempCursor INTO @code
	
END
CLOSE tempCursor
DEALLOCATE tempCursor

return @count

END







GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

