SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserProfile_Search]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[UserProfile_Search]
GO


/*
<summary>
Searches for user profiles
</summary>
<param name="username">Compared to start of users's username</param>
<param name="firstName">Compared to start of users's first name</param>
<param name="lastName">Compared to start of users's last name</param>
<param name="orderBy">Order by clause</param>
<param name="limit">Maximum number of users to return</param>
<returns>List of matching users</returns>
<model returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.UserProfile_Search 
	@username 	VARCHAR(200),
	@firstName 	VARCHAR(50),
	@lastName	VARCHAR(50),
	@school		UNIQUEIDENTIFIER,
	@orderBy	VARCHAR(128),
	@limit		INT
AS

	-- Use dynamic sql due to the orderBy and limit parameters
	DECLARE @select VARCHAR(8000)
	DECLARE @where VARCHAR(8000)
	DECLARE @crlf CHAR(1)
	
	SET @crlf = char(10)

	IF @limit IS NULL
		SET @select = 'SELECT u.*'
	ELSE
		SET @select = 'SELECT TOP ' + CAST(@limit AS VARCHAR(10)) + ' u.*'
	
	SET @where = ''

	-- Username
	IF @username IS NOT NULL
		SET @where = '(u.Username LIKE ''' + dbo.Clean(@username, '\') + '%'' ESCAPE ''\'' or u.Username LIKE ''cn=' + dbo.Clean(@username, '\') + '%'' ESCAPE ''\'')' 

	-- First name
	IF @firstName IS NOT NULL
	BEGIN
		IF LEN(@where) > 0
			SET @where = @where + ' AND ' + @crlf

		SET @where = @where + '(u.FirstName LIKE ''' + dbo.Clean(@firstName, '\') + '%'' ESCAPE ''\'')'
	END

	-- Last name
	IF @lastName IS NOT NULL
	BEGIN
		IF LEN(@where) > 0
			SET @where = @where + ' AND ' + @crlf

		SET @where = @where + '(u.LastName LIKE ''' +dbo.Clean(@lastName, '\') + '%'' ESCAPE ''\'')'
	END

	-- School
	IF @school IS NOT NULL
	BEGIN
		IF LEN(@where) > 0
			SET @where = @where + ' AND ' + @crlf

		SET @where = @where + '(u.SchoolID = ''' + cast(@school as varchar(36)) + ''')'
	END

	-- order by clause
	SET @orderBy = ISNULL(dbo.Clean(@orderBy, NULL), 'LastName, FirstName')


	-- Execute query
	IF LEN(@where) = 0
		EXEC( 'SELECT TOP 0 * FROM UserProfileView u' )
	ELSE
		EXEC( @select + @crlf + 'FROM UserProfileView u' + @crlf + 'WHERE (' + @where + @crlf + ') AND Deleted IS NULL ORDER BY ' + @orderBy )


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO