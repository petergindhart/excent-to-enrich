-- =============================================
-- Create procedure basic template
-- =============================================
-- creating the store procedure
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'UserProfile_Search2' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.UserProfile_Search2
GO

/*
<summary>
Searchs for users by a portion of their username.
</summary>
<param name="username">Compared to end of user's username. Wildcards are allowed</param>

<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.UserProfile_Search2 @username varchar(8000)
AS

	SELECT *
	FROM UserProfileView
	WHERE UserName LIKE @username and Deleted IS NULL
GO

/*
-- =============================================
-- example to execute the store procedure
-- =============================================
EXECUTE UserProfile_Search2 '%COM'
*/
GO

