IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_UserProfileSchool') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_UserProfileSchool
GO

CREATE VIEW LEGACYSPED.Transform_UserProfileSchool
AS
select 
	  ID = NEWID()
    , UserProfileID = m.DestID
    , SchoolID = h.DestID 
from Legacysped.Transform_School h join 
LEGACYSPED.StaffSchool ss on h.Number = ss.SCHOOLCODE  join
LEGACYSPED.MAP_PersonID m ON m.StaffEmail = ss.StaffEmail left join
UserProfileSchool us on h.DestID = us.SchoolID and us.UserProfileID = m.DestID
where h.DeletedDate is null and us.ID is null
