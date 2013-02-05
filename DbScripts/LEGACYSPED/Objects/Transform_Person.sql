IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PersonID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PersonID
	(
	StaffEmail nvarchar(75) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)
ALTER TABLE LEGACYSPED.MAP_PersonID ADD CONSTRAINT
	PK_MAP_StaffEmail PRIMARY KEY CLUSTERED
	(
	StaffEmail
	)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_Person') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_Person
GO

CREATE VIEW LEGACYSPED.Transform_Person
as
SELECT DestID = ISNULL(p.ID, m.DestID),TypeID = 'U', Firstname = sm.Firstname, Lastname = sm.Lastname, StaffEmail = sm.StaffEmail, ManuallyEntered = cast (1 as bit) 
FROM LEGACYSPED.SPEDStaffMember sm left join 
	LEGACYSPED.MAP_PersonID m ON m.StaffEmail = sm.StaffEmail left join 
	Person p on sm.STAFFEMAIL = p.EmailAddress left join
	UserProfile u on p.ID = u.ID left join
	UserProfile upn on 'Enrich:'+sm.Firstname+ sm.Lastname = upn.Username
where u.ID is null
and upn.ID is null
go

