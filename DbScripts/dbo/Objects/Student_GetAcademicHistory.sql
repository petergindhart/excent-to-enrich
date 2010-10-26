IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'Student_GetAcademicHistory' 
	   AND 	  type = 'P')
    DROP PROCEDURE Student_GetAcademicHistory
GO

/*
<summary>
Retrieves the school(s) student attended for each of his/her grade
</summary>
<param name="studentID">Id of Student</param>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/

CREATE PROCEDURE dbo.Student_GetAcademicHistory
	@studentID uniqueidentifier
AS

DECLARE g_cursor CURSOR

FOR 
	SELECT GradeLevelID 
	FROM StudentGradeLevelHistory
	WHERE StudentID = @studentID
	ORDER BY StartDate
OPEN g_cursor

DECLARE @grade uniqueidentifier

FETCH NEXT FROM g_cursor INTO @grade
WHILE (@@FETCH_STATUS = 0)
BEGIN
	exec Student_GetSchoolForGrade @studentID, @grade
	FETCH NEXT FROM g_cursor INTO @grade
END
CLOSE g_cursor
DEALLOCATE g_cursor
GO

