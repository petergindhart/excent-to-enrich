IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'Student_GetSchoolForGrade' 
	   AND 	  type = 'P')
    DROP PROCEDURE Student_GetSchoolForGrade
GO


/*
<summary>
Gets student's school related grade history info
</summary>
<param name="studentID">Student guid</param>
<param name="gradeID">GradeLevel guid</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/

CREATE PROCEDURE dbo.Student_GetSchoolForGrade
	@studentID	uniqueidentifier, 
	@gradeID	uniqueidentifier
AS

DECLARE @start		DateTime
DECLARE @end		DateTime
DECLARE @startSchool 	UniqueIdentifier
DECLARE @endSchool		UniqueIdentifier

SELECT @start = StartDate, @end = EndDate
FROM StudentGradeLevelHistory 
WHERE GradeLevelID = @gradeID
AND StudentID = @studentID


Select  @startSchool = SchoolID
FROM	StudentSchoolHistory 
WHERE StudentID = @studentID AND dbo.DateInRange(@start, StartDate, EndDate) = 1


Select  @endSchool = SchoolID
FROM	StudentSchoolHistory 
WHERE StudentID = @studentID AND dbo.DateInRange(@end, StartDate, EndDate) = 1

SELECT 
	 @gradeID AS Grade, 
	  @start  AS StartDay, 
	  @startSchool AS StartSchool, 
	  @end	AS EndDay, 
	  @endSchool AS EndSchool
GO

