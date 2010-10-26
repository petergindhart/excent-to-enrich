/****** Object:  StoredProcedure [dbo].[Student_SearchRandom]    Script Date: 01/22/2009 16:07:53 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Student_SearchRandom]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Student_SearchRandom]
GO

CREATE PROCEDURE [dbo].[Student_SearchRandom] 
	@criteria  VARCHAR(50) = NULL,
	@lowerBound VARCHAR(50) = NULL,
	@upperBound VARCHAR(50) = NULL,
	@testDefID UNIQUEIDENTIFIER =NULL,
	@limit INT,
	@userProfileID UNIQUEIDENTIFIER
AS
	DECLARE @orderBy VARCHAR(2000)
	DECLARE @select VARCHAR(8000)
	DECLARE @where VARCHAR(8000)
	DECLARE @crlf CHAR(1)
	DECLARE @sql VARCHAR(8000)
	
	SET @crlf = char(10)
	SET @orderBy = 'LastName, FirstName'
	SET @select = 'SELECT TOP ' + CAST(@limit AS VARCHAR(10)) + ' s.*'
	SET @where = ''

	IF (@criteria = 'test')
	BEGIN
		SELECT
			@sql = 'from ' + TableName + ' T join
				Student s on T.StudentID = s.ID
				WHERE 
					dbo.DateInRange(DateTaken, ' + IsNull('''' + @lowerBound + '''', 'NULL') + ' , ' + IsNull(  '''' + @upperBound + '''', 'NULL') + ') = 0
	'
		From 
			TestDefinition def join
			TestAdministration ta on ta.TestDefinitionID = def.ID
		WHERE
			def.ID = @testDefId
	END
	ELSE IF (@criteria = 'none')
	BEGIN
		SET @sql = 'from (select top ' + CAST(@limit AS VARCHAR(10)) + ' * from Student where IsActive = 1 order by newID() ) s
					where IsActive = 1'		
	END

	
	-- add the security filtering sql
	DECLARE @zonesql varchar(8000)
	SET @zonesql = dbo.GetSecurityZoneFilter('s', @userProfileID, getdate())
	
	IF LEN(@zonesql) > 0
	BEGIN
			SET @sql = @sql + ' AND ' + @zonesql
	END


	IF @sql is null OR LEN(@sql) = 0
		EXEC( 'SELECT TOP 0 * FROM Student s' )
	ELSE
		exec( @select + @crlf + @sql + @crlf + 'ORDER BY ' + @orderBy )

--exec Student_SearchRandom @limit=1, @userprofileId ='EEE133BD-C557-47E1-AB67-EE413DD3D1AB', @criteria='none'

