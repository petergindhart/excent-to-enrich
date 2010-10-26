IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'Student_GetEnrollmentHistory' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.Student_GetEnrollmentHistory
GO

/*
<summary>
Get all the past enrollment information for the current student
</summary>
<param name="id">Id of the Student </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.Student_GetEnrollmentHistory 
	@id uniqueidentifier
AS

SELECT
	ry.ID AS RosterYearID,
	scrh.ClassRosterID,
	scrh.StartDate,
	scrh.EndDate
FROM
		(
			(
				SELECT
					* 
				FROM 
					StudentClassRosterHistory 
				WHERE 
					StudentID = @id
			) scrh JOIN ClassRoster cr ON scrh.ClassRosterID = cr.ID
		) JOIN 	RosterYear ry ON ry.ID = cr.RosterYearID

ORDER BY 
	cr.ClassName
GO
