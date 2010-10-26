if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Teacher_Search]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Teacher_Search]
GO

/*
<summary>
Gets the teachers that taught a student during the specified date range
</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.Teacher_Search
	@firstname		VARCHAR(50),
	@lastname		VARCHAR(50),
	@currentSchoolID	UNIQUEIDENTIFIER,
	@ssnList 		VARCHAR(8000) = NULL,
	@numberList 		VARCHAR(8000) = NULL,	
	@orderBy 		VARCHAR(2000) = NULL,
	@userProfileID 		UNIQUEIDENTIFIER
AS

	-- Use dynamic sql due to the orderBy and limit parameters
	DECLARE @select VARCHAR(8000)
	DECLARE @where VARCHAR(8000)
	DECLARE @crlf CHAR(1)

	SET @crlf = char(10)

	SET @select = 'SELECT  T.*'
	SET @where = ''

	-- First/last name
	IF @firstname IS NOT NULL AND @lastname IS NOT NULL 
		SET @where = '(T.FirstName LIKE ''' + dbo.Clean(@firstname, '\') + '%'' ESCAPE ''\'' AND T.LastName LIKE ''' + dbo.Clean(@lastname, '\') + '%'' ESCAPE ''\'')' 
	ELSE IF @firstname IS NOT NULL
		SET @where = '(T.FirstName LIKE ''' + dbo.Clean(@firstname, '\') + '%'' ESCAPE ''\'')' 
	ELSE IF @lastname IS NOT NULL
		SET @where = '(T.LastName LIKE ''' + dbo.Clean(@lastname, '\') + '%'' ESCAPE ''\'')' 

	-- School
	IF @currentSchoolID IS NOT NULL
	BEGIN
		IF LEN(@where) > 0
			SET @where = @where + ' AND ' + @crlf

		SET @where = @where + '(CurrentSchoolID = ''' + dbo.Clean(CAST(@currentSchoolID AS VARCHAR(36)), NULL) + ''')'
	END

	-- SSN
	IF @ssnList IS NOT NULL
	BEGIN
		IF LEN(@where) > 0
			SET @where = @where + ' OR ' + @crlf

		SET @where = @where + '(SSN IN (''' + REPLACE(dbo.Clean(@ssnList, NULL),',',''',''') + '''))'
	END

	-- Number
	IF @numberList IS NOT NULL
	BEGIN
		IF LEN(@where) > 0
			SET @where = @where + ' OR ' + @crlf

		SET @where = @where + '(ID IN (SELECT TeacherID FROM TeacherCertificate TC WHERE TC.Number IN (''' + REPLACE(dbo.Clean(@numberList, NULL),',',''',''') + ''')))'
	END

	-- add the security filtering sql
	DECLARE @zonesql varchar(8000)
	SET @zonesql = dbo.GetTeacherSecurityZoneFilter('T', @UserProfileID, getdate())
	
	IF LEN(@zonesql) > 0
	BEGIN
		IF LEN(@where) > 0
			SET @where = @where + ' AND  ' + @crlf
			
			SET @where = @where + @zonesql
	END

	-- dont include 'deleted' teachers
	IF LEN(@where) > 0
		SET @where = @where + ' AND  ' + @crlf
		
		SET @where = @where + 'CurrentSchoolID is not null'
	
	-- Execute query
	IF LEN(@where) = 0
		EXEC( 'SELECT TOP 0 * FROM Teacher T' )
	ELSE
		EXEC( @select + @crlf + 'FROM Teacher T' + @crlf + 'WHERE ' + @where + @crlf + 'ORDER BY ' + @orderBy )


GO
