IF  EXISTS (SELECT 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'MAP_SpedStaffMemberView')
	DROP VIEW LEGACYSPED.MAP_SpedStaffMemberView
GO

CREATE VIEW LEGACYSPED.MAP_SpedStaffMemberView
AS
	SELECT
		staff.StaffEmail, -- changed SpedStaffRefID to StaffEmail
		UserProfileID = u.ID 
FROM LEGACYSPED.SpedStaffMember staff JOIN
Person p on p.EmailAddress = staff.StaffEmail JOIN
UserProfile u on u.ID = p.ID 
where p.ID = (
	select max(convert(varchar(36), pd.ID))
	from Person pd
		where pd.EmailAddress = p.EmailAddress
		and pd.Deleted is null
		and pd.TypeID = 'U'
		group by pd.EmailAddress
		-- order by pd.ManuallyEntered
		)
and p.Deleted is null 
GO
--

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgItemTeamMember') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgItemTeamMember
GO

CREATE VIEW LEGACYSPED.Transform_PrgItemTeamMember
AS
	SELECT
		ItemID = i.ExistingConvertedItemID,
		ResponsibilityID = u.PrgResponsibilityID,
		IsPrimary = CASE WHEN team.IsCaseManager = 'Y' THEN 1 ELSE 0 END,
		MtgAbsent = CAST(0 AS BIT),
		PersonID = u.ID,
		Agency = NULL,
		ExcusalFormId = CAST(NULL as uniqueidentifier)
	FROM
		LEGACYSPED.EvaluateIncomingItems i JOIN
		LEGACYSPED.TeamMember team on team.StudentRefId = i.StudentRefID JOIN
		LEGACYSPED.MAP_SpedStaffMemberView staff on staff.StaffEmail = team.StaffEmail JOIN
		UserProfile u on u.ID = staff.UserProfileID
GO
--