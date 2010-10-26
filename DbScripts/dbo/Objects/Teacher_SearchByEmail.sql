IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'Teacher_SearchByEmail' 
	   AND 	  type = 'P')
    DROP PROCEDURE Teacher_SearchByEmail
GO

CREATE PROCEDURE Teacher_SearchByEmail 
	@emailAddress varchar(60)
AS
SELECT	*
FROM	Teacher
WHERE	EmailAddress = @emailAddress
GO
