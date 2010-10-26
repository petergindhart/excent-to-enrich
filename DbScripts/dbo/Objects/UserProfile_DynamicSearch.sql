if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserProfile_DynamicSearch]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UserProfile_DynamicSearch]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
<summary>
Used to find UserProfile records.
</summary>
<param name="userText">Compared to the user's name and username</param>
<param name="schoolIDs">Compared to the user's current school</param>
<param name="schoolText">Compared to the user's current school</param>
<param name="email">Compared to the user's email address</param>
<param name="userProfileID">The user who is executing the search</param>
<returns>List of matching user profiles</returns>
<model returnType="System.Data.IDataReader" />
*/
CREATE  PROCEDURE [dbo].[UserProfile_DynamicSearch]
	@userText VARCHAR(100) = NULL,
	@schoolIDs VARCHAR(4000) = NULL,
	@schoolText VARCHAR(100) = NULL,
	@email VARCHAR(100) = NULL,
	@userProfileID UNIQUEIDENTIFIER = NULL
AS
	DECLARE @userTextNormal VARCHAR(250)
	SET @userTextNormal = case when charindex(' ', @userText) > 0 then '' else '%' end + Replace(Replace(ltrim(rtrim(@userText)), ',', ''), '-', ' ')
	
	DECLARE @schoolTextNormal varchar(250)
	SET @schoolTextNormal = Replace(Replace(ltrim(rtrim(@schoolText)), ',', ' '), '-', ' ')
	
	SELECT 
		TOP 100 u.* 
	FROM 
		UserProfileView u LEFT JOIN 
		School sch on sch.ID = u.SchoolID 
	WHERE 
		Deleted IS NULL AND 
		-- Ensure that at least one search parameter is provided
		(
			(@userTextNormal IS NOT NULL AND @userTextNormal != '') OR 
			(@schoolIDs IS NOT NULL AND @schoolIDs != '') OR 
			(@schoolText IS NOT NULL AND @schoolTextNormal != '') OR 
			(@email IS NOT NULL AND @email != '')
		) AND 
		-- Do a simple pattern match against the name.  This is to avoid overly aggressive matching, which would probably require ranking.
		-- TODO: more sophisticated comparison against username?
		(@userTextNormal IS NULL OR @userTextNormal = '' OR 
			u.FirstName + ' ' + u.LastName LIKE REPLACE(@userTextNormal, ' ', '% ') + '%' OR 
			u.LastName + ' ' + u.FirstName LIKE REPLACE(@userTextNormal, ' ', '% ') + '%' OR 
			u.Username LIKE '%' + @userTextNormal + '%') AND 
		-- Match the specific school.
		(@schoolIDs IS NULL OR @schoolIDs = '' OR sch.ID IN (SELECT ID FROM [dbo].[GetIds](@schoolIDs))) AND 
		-- Match schools by name if a school ID was not provided.  Only match ending patterns of more than 2 tokens.  If the text is "Jones Hand Middle School", 
		-- we only match "Hand Middle School" and not "Jones High School".  If the text is "Mur Middle School" it will match "Murray Middle School" and not "Murrell Middleton 
		-- School of the Arts".  Also, we don't want to match only "High School", "Middle School", or "Elementary School".  TODO: other types of school names may need to be considered.
		(@schoolIDs IS NOT NULL OR @schoolIDs != '' OR @schoolText IS NULL OR @schoolTextNormal = '' OR 
			(SELECT COUNT(*) FROM [dbo].[GetSearchTerms](@schoolTextNormal) WHERE sch.Name LIKE '%' + Pattern AND DistanceFromEnd = 0 AND TokenCount > 2) > 0) AND 
		-- Match the specific grade level
		(@email IS NULL OR @email = '' OR u.EmailAddress LIKE @email + '%') 

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO