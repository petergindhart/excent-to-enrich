IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_PrgItemTeamMember') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_PrgItemTeamMember
GO

CREATE VIEW AURORAX.Transform_PrgItemTeamMember
AS
	SELECT
		ItemID = iep.DestID,
		ResponsibilityID = u.PrgResponsibilityID,
		IsPrimary = CASE WHEN team.CaseManager = 'Y' THEN 1 ELSE 0 END,
		MtgAbsent = CAST(0 AS BIT),
		PersonID = u.ID,
		Agency = NULL,
		ExcusalFormId = CAST(NULL as uniqueidentifier)
	FROM
		AURORAX.Transform_Iep iep JOIN
		AURORAX.TeamMember team on team.StudentRefId = iep.StudentRefID JOIN
		AURORAX.MAP_SpedStaffMemberView staff on staff.SpedStaffRefID = team.SpedStaffRefId JOIN
		UserProfile u on u.ID = staff.UserProfileID
GO
--