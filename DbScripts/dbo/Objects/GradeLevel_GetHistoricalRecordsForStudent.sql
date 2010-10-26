
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'GradeLevel_GetHistoricalRecordsForStudent' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.GradeLevel_GetHistoricalRecordsForStudent
GO

/*
<summary>

</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.GradeLevel_GetHistoricalRecordsForStudent
	@studentId			uniqueidentifier,
	@date				datetime
AS
	select
		g.*
	from
		GradeLevel g join
		StudentGradeLevelHistory h on g.Id = h.GradeLevelID	
	where
		h.StudentID = @studentId and
		dbo.DateInRange(@date, h.StartDate, h.EndDate) = 1
GO
