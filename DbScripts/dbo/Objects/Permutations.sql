if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Permutations]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[Permutations]
GO

CREATE FUNCTION [dbo].[Permutations] (@text VARCHAR(8000))
RETURNS @result TABLE (Value VARCHAR(8000))
AS
BEGIN
	IF CHARINDEX(' ', @text) = 0
		INSERT INTO @result SELECT @text
	ELSE
	BEGIN
		declare @tokens table (Sequence int identity primary key, Raw varchar(100), Cleaned varchar(100))
		insert into @tokens select Item, dbo.Clean(Item, '\') from dbo.Split(@text, ' ') WHERE RTRIM(LTRIM(Item)) != ''
		DECLARE @numTokens INT
		SELECT @numTokens = COUNT(*) FROM @tokens

		IF @numTokens = 2
			INSERT INTO @result 
				SELECT SUBSTRING(@text, 0, CHARINDEX(' ', @text)) + ' ' + SUBSTRING(@text, CHARINDEX(' ', @text) + 1, LEN(@text)) UNION 
				SELECT SUBSTRING(@text, CHARINDEX(' ', @text) + 1, LEN(@text)) + ' ' + SUBSTRING(@text, 0, CHARINDEX(' ', @text))
		ELSE
		BEGIN
			DECLARE @index INT
			SET @index = 1

			WHILE @index <= @numTokens
			BEGIN
				DECLARE @token VARCHAR(200)
				SELECT @token = Cleaned FROM @tokens WHERE Sequence = @index
	
				DECLARE @remainder VARCHAR(200)
				SET @remainder = NULL
				SELECT @remainder = ISNULL(@remainder + ' ', '') + Cleaned FROM @tokens WHERE Sequence != @index
				
				INSERT INTO @result 
				SELECT @token + ' ' + Value 
				FROM dbo.[Permutations](@remainder)

				SET @index = @index + 1
			END
		END
	END		

	RETURN
END
GO
