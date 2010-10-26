if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RecentStudentsZoneClassRosters]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[RecentStudentsZoneClassRosters]
GO

CREATE FUNCTION [dbo].[RecentStudentsZoneClassRosters](@userProfileId UNIQUEIDENTIFIER, @now DATETIME)
	RETURNS TABLE
AS RETURN
(
	-- search class/teacher assocation for the current and previous roster year
	SELECT 
		h.ClassRosterID
	FROM
		ClassRosterTeacherHistory h JOIN 
		Teacher t ON t.ID = h.TeacherID CROSS JOIN
		(
			SELECT prior.StartDate, curr.EndDate
			FROM RosterYear curr JOIN 
				RosterYear prior ON curr.StartYear - 1 = prior.StartYear
			WHERE dbo.DateInRange(@now, curr.StartDate, curr.EndDate) = 1
		) r -- roster year(s) date range
	WHERE
		dbo.DateRangesOverlap(r.StartDate, r.EndDate, h.startDate, h.endDate, @now) = 1 AND
		t.UserProfileID = @userProfileId
)
GO
