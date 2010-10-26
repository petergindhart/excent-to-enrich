if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Student_GetRecordsByIdentifiers]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Student_GetRecordsByIdentifiers]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

 /*
<summary>
Used to find student records by identifiers.
</summary>
<param name="searchText"></param>
<param name="limit">Maximum number of students to return</param>
<param name="userProfileID">The user who is executing the search</param>
<returns>List of matching students</returns>
<model returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[Student_GetRecordsByIdentifiers]
	@searchText VARCHAR(200), @limit INT, @canViewSsn BIT, @userProfileID UNIQUEIDENTIFIER
AS
	-- Use dynamic sql due to the orderBy and limit parameters
	DECLARE @select VARCHAR(8000)
	DECLARE @where VARCHAR(8000)
	DECLARE @crlf CHAR(1)
	
	SET @crlf = char(10)

	SET @select = 'SELECT TOP ' + CAST(@limit AS VARCHAR(10)) + ' s.*'
	SET @where = ''

	DECLARE @searchTextPattern VARCHAR(200)
	SET @searchTextPattern = '''%' + dbo.Clean(@searchText, NULL) + ''''

	IF @searchTextPattern IS NOT NULL
	BEGIN
		SET @where = '(' + @crlf

		IF @canViewSsn = 1 
		BEGIN
			SET @where = @where + '(SSN LIKE ' + @searchTextPattern + ') OR ' + @crlf
		END

		SET @where = @where + '(Number LIKE ' + @searchTextPattern + ')'
		
		DECLARE @ids TABLE(Number INT IDENTITY(1,1), ColumnName VARCHAR(50))
		INSERT INTO @ids
		SELECT ColumnName 
		FROM ExtendedPropertyDefinition 
		WHERE ExtendedPropertyTypeDefinitionID = 'B1BA406A-80C4-44D0-8E36-9EC34094C553' AND IsIdentifier = 1
		
		DECLARE @count INT, @index INT
		SELECT @index = 1, @count = COUNT(*) FROM @ids

		WHILE @index <= @count
		BEGIN
			SET @where = @where + ' OR ' + @crlf
			SELECT @where = @where + '(' + ColumnName + ' LIKE ' + @searchTextPattern + ')' FROM @ids WHERE Number = @index

			SET @index = @index + 1		
		END

		SET @where = @where + ')'
	END

	-- add the security filtering sql
	DECLARE @zonesql varchar(8000)
	SET @zonesql = dbo.GetSecurityZoneFilter('s', @userProfileID, getdate())
	
	IF LEN(@zonesql) > 0
	BEGIN
		IF LEN(@where) > 0
			SET @where = @where + ' AND  ' + @crlf
			
			SET @where = @where + @zonesql
	END
	
	-- Execute query
	IF LEN(@where) = 0
		SET @where = '1 = 0'
	
	EXEC( @select + @crlf + 'FROM Student s' + @crlf + 'WHERE ' + @where + @crlf + 'ORDER BY FirstName, LastName' )

	--SELECT @select + @crlf + 'FROM Student s' + @crlf + 'WHERE ' + @where + @crlf + 'ORDER BY FirstName, LastName'

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

