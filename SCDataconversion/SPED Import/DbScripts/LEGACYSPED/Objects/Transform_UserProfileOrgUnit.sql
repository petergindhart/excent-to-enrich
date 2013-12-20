IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_UserProfileOrgUnit') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_UserProfileOrgUnit
GO

CREATE VIEW LEGACYSPED.Transform_UserProfileOrgUnit
AS
SELECT 
  Distinct UserProfileID = m.DestID
 ,OrgUnitID = h.OrgUnitID
FROM Legacysped.Transform_School h join 
LEGACYSPED.StaffSchool ss on h.Number = ss.SCHOOLCODE  join
LEGACYSPED.MAP_PersonID m ON m.StaffEmail = ss.StaffEmail left join 
dbo.Person up on ss.STAFFEMAIL = up.EmailAddress and up.TypeID = 'U' left join
dbo.UserProfileOrgUnit pou on h.OrgUnitID = pou.OrgUnitID and pou.UserProfileID = up.ID and m.DestID = pou.UserProfileID
WHERE h.DeletedDate is null and pou.UserProfileID is null




--UserProfileOrgUnit (UserProfileID, OrgUnitID) 
