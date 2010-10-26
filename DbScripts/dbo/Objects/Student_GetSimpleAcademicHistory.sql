IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Student_GetSimpleAcademicHistory]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Student_GetSimpleAcademicHistory]
GO

 /*
<summary>
Retrieves the school(s) student attended for each of his/her grade
</summary>
<param name="studentID">Id of Student</param>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[Student_GetSimpleAcademicHistory]
	@studentID uniqueidentifier
AS

select distinct
	StudentID,
	SchoolID,	
	StartDate,
	EndDate,
	GradeLevelID AS GradeLevel
FROM
(
	SELECT		
		StudentID = Coalesce(shist.StudentID,gHist.StudentID),
		SchoolID,
		GradeLevelID,
		Coalesce(gHist.StartDate,shist.StartDate) AS StartDate,
		Coalesce(gHist.EndDate,shist.EndDate) AS EndDate
	FROM
		StudentSchoolHistory sHist FULL OUTER JOIN
		StudentGradeLevelHistory gHist on sHist.StudentID = gHist.StudentID AND 	
			dbo.DateRangesOverlap(shist.StartDate, sHist.EndDate, ghist.StartDate, gHist.EndDate, null) = 1
	WHERE
		sHist.StudentID = @studentID
			
	UNION ALL

	SELECT
		StudentID = Coalesce(shist.StudentID,gHist.StudentID),
		SchoolID,
		GradeLevelID,
		Coalesce(gHist.StartDate,shist.StartDate) AS StartDate,
		Coalesce(gHist.EndDate,shist.EndDate) AS EndDate			
	FROM
		StudentSchoolHistory sHist FULL OUTER JOIN
		StudentGradeLevelHistory gHist on sHist.StudentID = gHist.StudentID AND 	
			dbo.DateRangesOverlap(shist.StartDate, sHist.EndDate, ghist.StartDate, gHist.EndDate, null) = 1
	WHERE
		gHist.StudentID = @studentID
) T