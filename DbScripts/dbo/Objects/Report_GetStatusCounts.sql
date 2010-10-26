if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Report_GetStatusCounts]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Report_GetStatusCounts]
GO

/*
<summary>
Counts the number of students in each status currently.
</summary>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[Report_GetStatusCounts]
	@programId uniqueidentifier, 
	@schoolId uniqueidentifier = null
AS

DECLARE @totalStudents INT
SELECT @totalStudents = COUNT(*) 
FROM Student s WHERE (@schoolID is null OR @schoolID = s.CurrentSchoolID) and CurrentSchoolID is not null

SELECT 
	StatusID = stat.ID,
	Students = isnull(count(inv.MaxStatusSequence), -1),
	StudentsPrct = isnull(count(inv.MaxStatusSequence), -1) / CAST(dbo.IntMax(@totalStudents, 1) AS FLOAT)
FROM
	(
		SELECT ID, ProgramID, Sequence 
		FROM PrgStatus 
		WHERE ProgramID = @programId AND IsExit = 0 AND DeletedDate IS NULL
		UNION 
		SELECT NULL, @programID, -1
	) stat LEFT OUTER JOIN 
	(
		SELECT
			stu.ID, MaxStatusSequence = max(isnull(stat.Sequence, -1))
		FROM
			Student stu LEFT JOIN 
			(
				SELECT * FROM PrgInvolvement WHERE ProgramId = @programId
			) inv ON inv.StudentId = stu.Id LEFT JOIN 
			(
				SELECT * FROM PrgInvolvementStatus WHERE EndDate is null
			) inst ON inst.InvolvementID = inv.ID LEFT JOIN 
			PrgStatus stat on stat.ID = inst.StatusID 
		WHERE
			(@schoolID IS NULL OR @schoolID = stu.CurrentSchoolID) and CurrentSchoolID is not null
		GROUP BY
			stu.Id
	) inv ON inv.MaxStatusSequence = stat.Sequence
GROUP BY
	stat.ID