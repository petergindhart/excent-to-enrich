-- All states, all districts
-- #############################################################################
-- OrgUnit
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_OrgUnitID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_OrgUnitID
	(
	DistrictCode nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)

ALTER TABLE LEGACYSPED.MAP_OrgUnitID ADD CONSTRAINT
	PK_MAP_OrgUnitID PRIMARY KEY CLUSTERED
	(
	DistrictCode
	)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_OrgUnit') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_OrgUnit
GO

CREATE VIEW LEGACYSPED.Transform_OrgUnit  
AS
/*
	This view depends on OrgUnit.Number (the state reporting code) being populated in the target table.  
		Depends on an update in the District Specific file 0002c-ETLPrep_District_DistrictName.sql
	Table Aliases:  k for Source, s for StateCode, m for Map, t for Target

	Caution:  If the Legacy District data and / or the Enrich OrgUnit data do not have the same StateCode, the a duplicate record for the OrgUnit will be inserted. (StateNumber is duplicated).

To Do:

How to handle hierarchical OrgUnits, like AUs or Coops?

*/

select 
  k.DistrictCode,
  -- DestID = isnull(isnull(s.ID, t.id), m.DestID), -- below this line may not require coalesce.  only legacy data will be updated, not SIS data.  Think about AU.
  DestID = coalesce(s.ID, t.ID, m.DestID),
  TypeID = '420A9663-FFE8-4FF1-B405-1DB1D42B6F8A',
  Name = coalesce(k.DistrictName, s.Name, t.Name),
  ParentID = isnull(s.ParentID, t.ParentID),
  Street = isnull(s.Street, t.Street),
  City = isnull(s.City, t.City),
  State = isnull(s.State, t.State),
  ZipCode = isnull(s.ZipCode, t.ZipCode),
  PhoneNumber = isnull(s.PhoneNumber, t.PhoneNumber),
  Number = coalesce(s.Number, t.Number, k.DistrictCode),
  Sequence = isnull(s.Sequence, t.Sequence) -- select * 
from 	LEGACYSPED.DistrictSchoolLeadingZeros dz cross join
	LEGACYSPED.District k left join 
	dbo.OrgUnit s on right(dz.Zeros+k.DistrictCode, len(dz.zeros)) = right(dz.Zeros+isnull(s.Number,''), len(dz.zeros)) left join -- DistrictCode and Number are synonymous with StateCode
	LEGACYSPED.MAP_OrgUnitID m on k.DistrictCode = m.DistrictCode left join 
	dbo.OrgUnit t on m.DestID = t.ID
where dz.Entity = 'District' 
GO
-- 
