
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'TestBinding_BindByNo' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.TestBinding_BindByNo
GO

/*
<summary>
Attempts to bind a test to a student in the system by using student number 
</summary>
<param name="studentNo">student number of testtaker</param>
<param name="matchEnd">indicates whether the student number will match the ending pattern</param>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/


CREATE PROCEDURE dbo.TestBinding_BindByNo
	@studentNo 	VARCHAR(50) 	= NULL,
	@matchEnd 	bit 		= 0
AS
	
	IF @matchEnd = 0
	BEGIN
		SELECT *
		FROM Student 
		WHERE Number = @studentNo
	END
	ELSE
	BEGIN
		-- OPTIMIZATION: Always search for full ID first to make use of index
		--		Only Do loose search if needed
		IF exists(select * from Student where Number = @studentNo)
		BEGIN
			SELECT * 
			FROM Student
			WHERE Number = @studentNo
		END
		ELSE
		BEGIN
			SELECT *
			FROM Student 
			WHERE Number LIKE '%' + @studentNo
		END
	END



GO

