if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Student_Search]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Student_Search]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

 /*
<summary>
Used to find student records.
Students that match the first name, last name, school and grade, 
OR SSN(s) OR student ID(s) will be treated as a match.
</summary>
<param name="firstName">Compared to start of student's first name</param>
<param name="lastName">Compared to start of student's last name</param>
<param name="currentSchoolID">Compared to student's current school</param>
<param name="currentGradeLevelID">Compared to the student's current grade level</param>
<param name="ssnList">Comma delimited list of SSN's. Compared to student's ssn</param>
<param name="numberList">Comma delimited list of student numbers. Compared to student's number</param>
<param name="studentgroupID">Compared to student's student group</param>
<param name="orderBy">Order by clause. Can reference any field of the student table,
'CurrentSchool.Abbreviation' or 'CurrentGradeLevel.Name'</param>
<param name="limit">Maximum number of students to return</param>
<param name="userProfileID">The user who is executing the search</param>
<returns>List of matching students</returns>
<model returnType="System.Data.IDataReader" />
*/
CREATE  PROCEDURE dbo.Student_Search
	@firstName VARCHAR(50) = NULL,
	@lastName VARCHAR(50) = NULL,
	@currentSchoolID UNIQUEIDENTIFIER = NULL,
	@currentGradeLevelID UNIQUEIDENTIFIER = NULL,
	@ssnList VARCHAR(8000) = NULL,
	@numberList VARCHAR(8000) = NULL,
	@StudentGroupID UNIQUEIDENTIFIER = NULL,
	@orderBy VARCHAR(2000) = NULL,
	@limit INT,	
	@userProfileID UNIQUEIDENTIFIER
AS
	-- Use dynamic sql due to the orderBy and limit parameters
	DECLARE @select VARCHAR(8000)
	DECLARE @where VARCHAR(8000)
	DECLARE @crlf CHAR(1)
	
	SET @crlf = char(10)

	SET @select = 'SELECT TOP ' + CAST(@limit AS VARCHAR(10)) + ' s.*'
	SET @where = ''

	-- First/last name
	IF @firstName IS NOT NULL AND @lastName IS NOT NULL 
		SET @where = '(s.FirstName LIKE ''' + dbo.Clean(@firstName, '\') + '%'' ESCAPE ''\'' AND s.LastName LIKE ''' + dbo.Clean(@lastName, '\') + '%'' ESCAPE ''\'')' 
	ELSE IF @firstName IS NOT NULL
		SET @where = '(s.FirstName LIKE ''' + dbo.Clean(@firstName, '\') + '%'' ESCAPE ''\'')' 
	ELSE IF @lastName IS NOT NULL
		SET @where = '(s.LastName LIKE ''' + dbo.Clean(@lastName, '\') + '%'' ESCAPE ''\'')' 


	-- School
	IF @currentSchoolID IS NOT NULL
	BEGIN
		IF LEN(@where) > 0
			SET @where = @where + ' AND ' + @crlf

		SET @where = @where + '(CurrentSchoolID = ''' + dbo.Clean(CAST(@currentSchoolID AS VARCHAR(36)), NULL) + ''')'
	END


	-- Grade level
	IF @currentGradeLevelID IS NOT NULL
	BEGIN
		IF LEN(@where) > 0
			SET @where = @where + ' AND ' + @crlf

		SET @where = @where + '(CurrentGradeLevelID = ''' + dbo.Clean(CAST(@currentGradeLevelID AS VARCHAR(36)), NULL) + ''')'
	END

	-- Group together name, school and grade level predicates
	IF LEN(@where) > 0
		SET @where = '(' + @where + ')'

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

		SET @where = @where + '(Number IN (''' + REPLACE(dbo.Clean(@numberList, NULL),',',''',''') + '''))'
	END

	-- Student Group
	IF @StudentGroupID IS NOT NULL
	BEGIN
		IF LEN(@where) > 0
			SET @where = @where + ' AND ' + @crlf

		SET @where = @where + '(ID NOT IN (SELECT StudentID FROM StudentGroupStudent WHERE StudentGroupID = ''' + dbo.Clean(CAST(@StudentGroupID AS VARCHAR(36)), NULL) + '''))'
	END

	-- add the security filtering sql
	DECLARE @zonesql varchar(8000)
	SET @zonesql = dbo.GetSecurityZoneFilter('s', @UserProfileID, getdate())
	
	IF LEN(@zonesql) > 0
	BEGIN
		IF LEN(@where) > 0
			SET @where = @where + ' AND  ' + @crlf
			
			SET @where = @where + @zonesql
	END
	
	-- order by clause
	IF @orderBy IS NULL
	BEGIN
		SET @orderBy = 'LastName, FirstName'
	END
	ELSE
	BEGIN
		SET @orderBy = dbo.Clean(@orderBy, NULL)

		-- substitute subquries into the order by clause
		SET @orderBy = REPLACE( @orderBy,
			'CurrentSchool.Abbreviation', 
			'(SELECT Abbreviation FROM School WHERE School.ID = s.CurrentSchoolID)' )
		SET @orderBy = REPLACE( @orderBy, 
			'CurrentGradeLevel.Name', 
			'(SELECT Name FROM GradeLevel g WHERE g.ID = s.CurrentGradeLevelID)' )
	END

	-- Execute query
	IF LEN(@where) = 0
		EXEC( @select + @crlf + 'FROM Student s' )
	ELSE
		EXEC( @select + @crlf + 'FROM Student s' + @crlf + 'WHERE ' + @where + @crlf + 'ORDER BY ' + @orderBy )

	--PRINT @select + @crlf + 'FROM Student s' + @crlf + 'WHERE ' + @where + @crlf + 'ORDER BY ' + @orderBy
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

