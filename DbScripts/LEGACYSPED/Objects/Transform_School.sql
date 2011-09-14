--#include Transform_OrgUnit.sql
-- #############################################################################
-- School
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_SchoolID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_SchoolID
	(
	SchoolRefID varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  

ALTER TABLE LEGACYSPED.MAP_SchoolID ADD CONSTRAINT
	PK_MAP_SchoolID PRIMARY KEY CLUSTERED
	(
	SchoolRefID
	) 
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_School') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_School  
GO

CREATE VIEW LEGACYSPED.Transform_School
AS
select 
	k.SchoolRefID,
	k.SchoolCode,
	DestID =  coalesce(s.ID, t.ID, m.DestID), -- ISNULL(isnull(s.ID, t.ID), m.DestID),
	Abbreviation = coalesce(s.Abbreviation, t.Abbreviation, k.SchoolAbbreviation),
	Name = coalesce(s.Name, t.Name, k.SchoolName), 
	Number = coalesce(s.Number, t.Number, k.SchoolCode),
	OrgUnitId = mo.DestID,
	IsLocalOrg = coalesce(s.IsLocalOrg, t.IsLocalOrg, 0), 
	ManuallyEntered = coalesce(s.ManuallyEntered, t.ManuallyEntered, 1), 
	MinutesInstruction = coalesce(s.MinutesInstruction, t.MinutesInstruction, CASE WHEN k.MinutesPerWeek > 0 THEN k.MinutesPerWeek ELSE NULL END),
	Street = isnull(s.Street, t.Street),
	City = isnull(s.City, t.City),
	State = isnull(s.State, t.State),
	ZipCode = isnull(s.ZipCode, t.ZipCode),
	PhoneNumber = isnull(s.PhoneNumber, t.PhoneNumber),
	DeletedDate = isnull(s.DeletedDate, t.DeletedDate) 
from 
	LEGACYSPED.School k LEFT JOIN 
	dbo.School s on 
		k.SchoolCode = s.Number AND
		s.IsLocalOrg = 1 AND
		s.ManuallyEntered = 0 LEFT JOIN 
	LEGACYSPED.MAP_SchoolID m on k.SchoolRefID = m.SchoolRefID LEFT JOIN 
	dbo.School t on m.DestID = t.ID LEFT JOIN
	LEGACYSPED.Transform_OrgUnit mo on k.DistrictRefID = mo.DistrictRefID
GO


/*
	This view is designed in conjunction with VC3ETL.LoadTable_Run to add only Schools that are not already in the School table.
	View matches first on k.SchoolCode = t.Number (synonymous with StateCode in both cases), then on k.SchoolRefID = m.SchoolRefID

*/

/*

	Only add schools not already in the school table.
	Must match on StateCode (LEGACYSPED.School.SchoolCode = dbo.School.Number)
	School.Number should be set in the SIS import.  If the school exists without the Number, a duplicate record will be added.


6BB2A9AD-FA9B-47EF-93FA-E4A9E99E0005	1	0	LEGACYSPED.Transform_School	School	1	LEGACYSPED.MAP_SchoolID	SchoolRefID	NULL	0	0	1	NULL	NULL	NULL	2011-08-31 08:18:16.360	NULL	29D14961-928D-4BEE-9025-238496D144C6	1	0	0

GEO.ShowLoadTables School


set nocount on;
declare @n varchar(100) ; select @n = 'School'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	HasMapTable = 1, 
	MapTable = 'LEGACYSPED.MAP_'+@n+'ID'   -- use this update for looksups only
	, KeyField = 'SchoolRefID'
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 1
	, DestTableFilter = 's.DestID in (select DestID from LEGACYSPED.MAP_SchoolID)'
	, Enabled = 1
	from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n


select d.*
-- UPDATE School SET Abbreviation=s.Abbreviation, DeletedDate=s.DeletedDate, Number=s.Number, MinutesInstruction=s.MinutesInstruction, Name=s.Name, ManuallyEntered=s.ManuallyEntered, OrgUnitID=s.OrgUnitID, IsLocalOrg=s.IsLocalOrg
FROM  School d JOIN 
	LEGACYSPED.Transform_School  s ON s.DestID=d.ID
	AND s.DestID in (select DestID from LEGACYSPED.MAP_SchoolID)

-- INSERT LEGACYSPED.MAP_SchoolID
SELECT SchoolRefID, NEWID()
FROM LEGACYSPED.Transform_School s
WHERE NOT EXISTS (SELECT * FROM School d WHERE s.DestID=d.ID)

-- INSERT School (ID, Abbreviation, DeletedDate, Number, MinutesInstruction, Name, ManuallyEntered, OrgUnitID, IsLocalOrg)
SELECT s.DestID, s.Abbreviation, s.DeletedDate, s.Number, s.MinutesInstruction, s.Name, s.ManuallyEntered, s.OrgUnitID, s.IsLocalOrg
FROM LEGACYSPED.Transform_School s
WHERE NOT EXISTS (SELECT * FROM School d WHERE s.DestID=d.ID)

select * from School



*/

