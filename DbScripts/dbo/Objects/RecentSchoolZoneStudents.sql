if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RecentSchoolZoneStudents]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[RecentSchoolZoneStudents]
GO

CREATE FUNCTION [dbo].[RecentSchoolZoneStudents](@userProfileID UNIQUEIDENTIFIER, @now DATETIME)
	RETURNS TABLE
AS RETURN
(
	SELECT sc.StudentID
	FROM	
		StudentSchool sc JOIN 
		UserProfile u ON sc.SchoolID = u.SchoolID JOIN 
		(
			SELECT curr.ID AS CurrentYear, prior.ID AS PriorYear
			FROM RosterYear curr JOIN 
				RosterYear prior ON curr.StartYear - 1 = prior.StartYear
			WHERE dbo.DateInRange(@now, curr.StartDate, curr.EndDate) = 1
		) ry ON sc.RosterYearID = ry.CurrentYear OR sc.RosterYearId = ry.PriorYear 
	WHERE 
		u.ID = @userProfileID
)
GO
