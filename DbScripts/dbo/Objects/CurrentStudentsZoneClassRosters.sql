if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CurrentStudentsZoneClassRosters]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[CurrentStudentsZoneClassRosters]
GO

CREATE FUNCTION [dbo].[CurrentStudentsZoneClassRosters](@userProfileId UNIQUEIDENTIFIER, @now DATETIME)
	RETURNS TABLE
AS RETURN
(
	-- search class/teacher assocation for the current roster year
	SELECT 
		h.ClassRosterID
	FROM
		ClassRosterTeacherHistory h JOIN 
		Teacher t ON t.ID = h.TeacherID CROSS JOIN
		(
			SELECT curr.StartDate, curr.EndDate
			FROM RosterYear curr 
			WHERE dbo.DateInRange(@now, curr.StartDate, curr.EndDate) = 1
		) r -- roster year date range
	WHERE
		dbo.DateRangesOverlap(r.StartDate, r.EndDate, h.startDate, h.endDate, @now) = 1 AND
		t.UserProfileID = @userProfileId
)
GO
