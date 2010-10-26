if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RecentStudentsZoneStudents]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[RecentStudentsZoneStudents]
GO

CREATE FUNCTION [dbo].[RecentStudentsZoneStudents](@userProfileId UNIQUEIDENTIFIER, @now DATETIME)
	RETURNS TABLE
AS RETURN
(
	-- search student/teacher assocation for the current and previous roster year
	SELECT 
		StudentID
	FROM
		StudentTeacherClassRoster stcr JOIN 
		(
			SELECT curr.ID AS CurrentYear, prior.ID AS PriorYear
			FROM RosterYear curr JOIN 
				RosterYear prior ON curr.StartYear - 1 = prior.StartYear
			WHERE dbo.DateInRange(@now, curr.StartDate, curr.EndDate) = 1
		) ry ON stcr.RosterYearID = ry.CurrentYear OR stcr.RosterYearId = ry.PriorYear JOIN 
		Teacher t ON t.ID = stcr.TeacherID AND t.UserProfileID = @userProfileId
	GROUP BY 
		StudentID

		union 

	-- search active interventions
	SELECT i.StudentID
	FROM
		PrgItem i JOIN 
		PrgIntervention intv on intv.ID = i.ID JOIN
		PrgItemTeamMember t on t.ItemID = i.ID CROSS JOIN  
		(
			SELECT prior.StartDate, curr.EndDate
			FROM RosterYear curr JOIN 
				RosterYear prior ON curr.StartYear - 1 = prior.StartYear
			WHERE dbo.DateInRange(@now, curr.StartDate, curr.EndDate) = 1
		) ry
	WHERE
		@userProfileid = t.PersonID and
		dbo.DateRangesOverlap(ry.StartDate, ry.EndDate, i.StartDate, i.EndedDate, @now )  = 1
	GROUP BY i.StudentID
)
GO
