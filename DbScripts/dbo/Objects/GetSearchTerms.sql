IF EXISTS (SELECT *  FROM sysobjects WHERE  name = N'GetSearchTerms')
DROP FUNCTION [dbo].[GetSearchTerms]
GO

CREATE FUNCTION [dbo].[GetSearchTerms](@text VARCHAR(100))  
RETURNS @terms table(Cleaned varchar(250), Raw varchar(250), Pattern varchar(250), FirstToken int, FirstTokenLen int, TokenCount int, DistanceFromStart int, DistanceFromEnd int)
AS 
BEGIN 
	-- Tokenize string
	declare @tokens table (Sequence int identity primary key, Raw varchar(100), Cleaned varchar(100))
	insert into @tokens select Item, dbo.Clean(Item, '\') from dbo.Split(@text, ' ')

	DECLARE @numTokens INT
	SELECT @numTokens = COUNT(*) FROM @tokens
	
	-- build all comibinations of search terms
	insert into @terms select Cleaned, Raw, Cleaned, Sequence, len(Raw), 1, Sequence - 1, @numTokens - Sequence from @tokens

	declare @tokenCount int
	while @@ROWCOUNT > 0
	begin
		set @tokenCount = isnull(@tokenCount + 1, 1)

		insert into @terms
		select st.Cleaned + ' ' + next.Cleaned, st.Raw + ' ' + next.Raw, st.Pattern + '% ' + next.Cleaned, st.FirstToken, st.FirstTokenLen, st.TokenCount + 1, st.FirstToken - 1, @numTokens - (st.TokenCount + st.FirstToken)
		from @tokens next join @terms st on st.FirstToken + st.TokenCount = next.Sequence 
		where st.TokenCount = @tokenCount
	end

	RETURN
END
GO
