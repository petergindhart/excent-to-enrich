if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetWeightedSearchTerms]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetWeightedSearchTerms]
GO

CREATE FUNCTION [dbo].[GetWeightedSearchTerms](@text VARCHAR(100))  
RETURNS @terms table(Cleaned varchar(250), Raw varchar(250), Pattern varchar(250), FirstToken int, TokenCount int, NumWildcards int, PureTokens int, Confidence int)
AS 
BEGIN 
	-- Tokenize string
	declare @tokens table (Sequence int identity primary key, Raw varchar(100), Cleaned varchar(100))
	insert into @tokens select Item, dbo.Clean(Item, '\') from dbo.Split(@text, ' ')
	DECLARE @numTokens INT
	SELECT @numTokens = COUNT(*) FROM @tokens
	
	-- build all comibinations of search terms
	INSERT INTO @terms SELECT Cleaned, Raw, Cleaned, Sequence, 1, 0, 1, 0 from @tokens WHERE Cleaned != 'De'
	insert into @terms select Cleaned, Raw, Cleaned + ' %', Sequence, 1, 1, 1, 0 from @tokens WHERE Cleaned != 'De'
	insert into @terms select Cleaned, Raw, Cleaned + '%', Sequence, 1, 1, 0, 0 from @tokens
	insert into @terms select Cleaned, Raw, '% ' + Cleaned, Sequence, 1, 1, 1, 0 from @tokens WHERE Cleaned != 'De'
	insert into @terms select Cleaned, Raw, '% ' + Cleaned + '%', Sequence, 1, 2, 0, 0 from @tokens
	
	--SELECT * FROM @terms

	declare @tokenCount int
	while @@ROWCOUNT > 0
	begin
		set @tokenCount = isnull(@tokenCount + 1, 1)

		insert into @terms
		select st.Cleaned + ' ' + next.Cleaned, st.Raw + ' ' + next.Raw, st.Pattern + ' ' + next.Cleaned, st.FirstToken, st.TokenCount + 1, st.NumWildcards, PureTokens + 1, 0
		from @tokens next join @terms st on st.FirstToken + st.TokenCount = next.Sequence 
		where st.TokenCount = @tokenCount
		UNION 
		select st.Cleaned + ' ' + next.Cleaned, st.Raw + ' ' + next.Raw, st.Pattern + ' ' + next.Cleaned + '%', st.FirstToken, st.TokenCount + 1, st.NumWildcards + 1, PureTokens, 0
		from @tokens next join @terms st on st.FirstToken + st.TokenCount = next.Sequence 
		where st.TokenCount = @tokenCount
		UNION 
		select st.Cleaned + ' ' + next.Cleaned, st.Raw + ' ' + next.Raw, st.Pattern + ' ' + next.Cleaned + ' %', st.FirstToken, st.TokenCount + 1, st.NumWildcards + 1, PureTokens + 1, 0
		from @tokens next join @terms st on st.FirstToken + st.TokenCount = next.Sequence 
		where st.TokenCount = @tokenCount
		UNION 
		select st.Cleaned + ' ' + next.Cleaned, st.Raw + ' ' + next.Raw, st.Pattern + '%' + next.Cleaned + ' ', st.FirstToken, st.TokenCount + 1, st.NumWildcards + 1, PureTokens, 0
		from @tokens next join @terms st on st.FirstToken + st.TokenCount = next.Sequence 
		where st.TokenCount = @tokenCount and SUBSTRING(st.Pattern, len(st.pattern), 1) = ' '
		UNION 
		select st.Cleaned + ' ' + next.Cleaned, st.Raw + ' ' + next.Raw, st.Pattern + '% ' + next.Cleaned + ' ', st.FirstToken, st.TokenCount + 1, st.NumWildcards + 1, PureTokens, 0
		from @tokens next join @terms st on st.FirstToken + st.TokenCount = next.Sequence 
		where st.TokenCount = @tokenCount and SUBSTRING(st.Pattern, len(st.pattern), 1) = ' '

	end

	DELETE FROM @terms WHERE TokenCount != @numTokens

	UPDATE @terms SET Confidence = PureTokens * 1000 - NumWildcards * 100 + charindex('%', Pattern)

	RETURN
END
