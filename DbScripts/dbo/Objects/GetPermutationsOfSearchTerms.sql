if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetPermutationsOfSearchTerms]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetPermutationsOfSearchTerms]
GO

CREATE FUNCTION [dbo].[GetPermutationsOfSearchTerms](@text VARCHAR(100))  
RETURNS @terms table(Cleaned varchar(250), Raw varchar(250), Pattern varchar(250), FirstToken int, TokenCount int, NumWildcards int, PureTokens int, Confidence int)
AS 
BEGIN 
	declare @perms table (Sequence int identity primary key, Value VARCHAR(8000))
	insert into @perms select Value from dbo.Permutations(@text)
	DECLARE @numPerms INT
	SELECT @numPerms = COUNT(*) FROM @perms
		
	DECLARE @index INT
	SET @index = 0

	WHILE @index <= @numPerms
	BEGIN
		DECLARE @permText VARCHAR(100)
		SELECT @permText = Value FROM @perms WHERE Sequence = @index

		INSERT INTO @terms SELECT * FROM dbo.GetWeightedSearchTerms(@permText)
		SET @index = @index + 1

	END

	RETURN
END
