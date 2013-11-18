IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_UserProfile') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_UserProfile
GO

CREATE VIEW LEGACYSPED.Transform_UserProfile
as
SELECT DestID = isnull(upn.ID, m.DestID), 
	RoleID = isnull(r.ID, 'A101B7EC-62CA-48C2-9562-DD511AB88534'),  --NoAccess
	UserName = 'Enrich:'+sm.Firstname+ sm.Lastname+cast(case when (select count(*)+1 from LEGACYSPED.SPEDStaffMember dt where sm.Firstname = dt.Firstname and sm.Lastname = dt.Lastname and sm.StaffEmail < dt.StaffEmail) > 1 then cast((select count(*)+1 from LEGACYSPED.SPEDStaffMember dt where sm.Firstname = dt.Firstname and sm.Lastname = dt.Lastname and sm.StaffEmail < dt.StaffEmail) as varchar(2)) else '' end as varchar(2)),
	CanPerformAllServices = cast(0 as bit), 
	CanSignAllServices = cast(0 as bit), 
	IsSchoolAutoSelected = cast(0 as bit), 
	CurrentFailedLoginAttempts = cast (0 as int), 
	RoleStatusID = 'M'
	-- select sm.*
FROM LEGACYSPED.SPEDStaffMember sm  join 
	LEGACYSPED.MAP_PersonID m ON m.StaffEmail = sm.StaffEmail left join
	UserProfile up ON up.ID = m.DestID left join 
	UserProfile upn on 'Enrich:'+sm.Firstname+ sm.Lastname = upn.Username left join
	SecurityRole r on sm.ENRICHROLE = r.Name 
WHERE up.ID is null


--insert UserProfile (ID, RoleID, Username, CanPerformAllServices, CanSignAllServices, IsSchoolAutoSelected, CurrentFailedLoginAttempts, RoleStatusID)
