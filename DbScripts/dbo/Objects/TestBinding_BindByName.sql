
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'TestBinding_BindByName' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.TestBinding_BindByName
GO

/*
<summary>
Attempts to bind a test to a student in the system by using firstname and lastname. 
Student's last name can't be null. 
</summary>
<param name="last">lastname of testtaker</param>
<param name="first">firstname of testtaker</param>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/

CREATE PROCEDURE dbo.TestBinding_BindByName
	@last VARCHAR(50) 	= '',
	@first VARCHAR(50)	= ''
AS

declare @last_clean varchar(8000)
declare @first_clean varchar(8000)

SET @last			= RTRIM(@last)
SET @first			= RTRIM(@first)

IF len(@last) > 0 AND len(@first) > 0
BEGIN
	-- Remove special characters from names
	SET @last_clean		= dbo.TestBinding_CleanName(@last)
	SET @first_clean	= dbo.TestBinding_CleanName(@first)

	-- OPTIMIZATION: Do one of four different searches 
	DECLARE @exact_match TABLE
	(
		StudentID UNIQUEIDENTIFIER PRIMARY KEY
	)
	IF @last_clean = @last AND @first_clean = @first
	BEGIN
		INSERT INTO @exact_match (StudentID) (SELECT ID FROM Student WHERE LastName = @last_clean AND FirstName = @first_clean)
		IF EXISTS(SELECT * FROM @exact_match)
		BEGIN
		-- FASTEST SEARCH - Exact match
			SELECT *
			FROM Student 
			WHERE 
				ID in (SELECT StudentID FROM @exact_match)
		END
		ELSE
		BEGIN
		-- FASTER SEARCH - Near match
			SELECT *
			FROM Student 
			WHERE 
				(LastName LIKE @last_clean + '%') AND (FirstName LIKE @first_clean + '%')
		END
	END
	ELSE
	BEGIN
		INSERT INTO @exact_match (StudentID) (SELECT ID FROM Student WHERE dbo.TestBinding_CleanName(LastName) = @last_clean AND dbo.TestBinding_CleanName(FirstName) = @first_clean)
		IF EXISTS(SELECT * FROM @exact_match)
		BEGIN
		-- SLOWER SEARCH - Exact match - cleaned
			SELECT *
			FROM Student 
			WHERE 
				ID in (SELECT StudentID FROM @exact_match)
		END
		ELSE
		BEGIN
			-- SLOWEST SEARCH - Near match - cleaned
			SELECT *
			FROM Student 
			WHERE 
				(dbo.TestBinding_CleanName(LastName) LIKE @last_clean + '%') AND (dbo.TestBinding_CleanName(FirstName) LIKE @first_clean + '%')
		END
	END

END

GO


IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  name = N'TestBinding_CleanName')
	DROP FUNCTION dbo.TestBinding_CleanName
GO

CREATE FUNCTION dbo.TestBinding_CleanName (@name varchar(8000))
RETURNS varchar(8000)
AS
BEGIN
	set @name = Replace(@name, ' ', '')
	set @name = Replace(@name, '*', '')
	set @name = Replace(@name, '''', '')
	set @name = Replace(@name, '-', '')
	set @name = Replace(@name, '.', '')
	set @name = Replace(@name, ',', '')
	set @name = Replace(@name, '`', '')

	RETURN @name
END
GO