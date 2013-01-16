IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgInvolvementTeamMemberID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PrgInvolvementTeamMemberID
(
	StaffEmail	varchar(150) NOT NULL,
	StudentRefId  varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_PrgInvolvementTeamMemberID ADD CONSTRAINT
PK_MAP_PrgInvolvementTeamMemberID PRIMARY KEY CLUSTERED
(
	StaffEmail,StudentRefId
)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgInvolvementTeamMember') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgInvolvementTeamMember
GO

CREATE VIEW LEGACYSPED.Transform_PrgInvolvementTeamMember
AS
SELECT
      mp.DestID,
      StaffEmail = team.StaffEmail,
      StudentRefId = team.StudentRefId,
      PersonID = u.ID,
      InvolvementID = i.ExistingInvolvementID,
      ResponsibilityID = u.PrgResponsibilityID,
      IsPrimary = CASE WHEN team.IsCaseManager = 'Y' THEN 1 ELSE 0 END
FROM
      LEGACYSPED.EvaluateIncomingItems i JOIN
      LEGACYSPED.TeamMember team on team.StudentRefId = i.StudentRefID  JOIN
      LEGACYSPED.MAP_SpedStaffMemberView staff on staff.StaffEmail = team.StaffEmail  JOIN
      UserProfile u on u.ID = staff.UserProfileID left join 
	  LEGACYSPED.MAP_PrgInvolvementTeamMemberID mp ON mp.StudentRefId =team.StudentRefId and mp.StaffEmail = team.StaffEmail
	  
	  