if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CurrentSchoolZoneClassRosters]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[CurrentSchoolZoneClassRosters]
GO

CREATE FUNCTION [dbo].[CurrentSchoolZoneClassRosters](@userProfileID UNIQUEIDENTIFIER, @now DATETIME)
	RETURNS TABLE
AS RETURN
(
	SELECT cr.ID AS ClassRosterID
	FROM	
		ClassRoster cr JOIN 
		UserProfile u ON cr.SchoolID = u.SchoolID JOIN 
		(
			SELECT curr.ID AS CurrentYear
			FROM RosterYear curr 
			WHERE dbo.DateInRange(@now, curr.StartDate, curr.EndDate) = 1
		) ry ON cr.RosterYearID = ry.CurrentYear
	WHERE 
		u.ID = @userProfileID
)
GO
