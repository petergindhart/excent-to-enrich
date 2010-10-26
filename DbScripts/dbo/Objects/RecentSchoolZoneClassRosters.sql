if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RecentSchoolZoneClassRosters]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[RecentSchoolZoneClassRosters]
GO

CREATE FUNCTION [dbo].[RecentSchoolZoneClassRosters](@userProfileID UNIQUEIDENTIFIER, @now DATETIME)
	RETURNS TABLE
AS RETURN
(
	SELECT cr.ID AS ClassRosterID
	FROM	
		ClassRoster cr JOIN 
		UserProfile u ON cr.SchoolID = u.SchoolID JOIN 
		(
			SELECT curr.ID AS CurrentYear, prior.ID AS PriorYear
			FROM RosterYear curr JOIN 
				RosterYear prior ON curr.StartYear - 1 = prior.StartYear
			WHERE dbo.DateInRange(@now, curr.StartDate, curr.EndDate) = 1
		) ry ON cr.RosterYearID = ry.CurrentYear OR cr.RosterYearId = ry.PriorYear 
	WHERE 
		u.ID = @userProfileID
)
GO
