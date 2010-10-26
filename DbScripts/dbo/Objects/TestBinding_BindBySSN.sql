
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'TestBinding_BindBySSN' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.TestBinding_BindBySSN
GO

/*
<summary>
Attempts to bind a test to a student in the system by using student's SSN
</summary>
<param name="ssn">student's SSN of testtaker</param>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/

CREATE PROCEDURE dbo.TestBinding_BindBySSN
	@ssn VARCHAR(9) = NULL
AS

SELECT *
FROM Student 
WHERE SSN = @ssn
GO
