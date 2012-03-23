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
  DestID = isnull(isnull(s.ID, t.id), m.DestID), -- below this line may not require coalesce.  only legacy data will be updated, not SIS data.  Think about AU.
  TypeID = '420A9663-FFE8-4FF1-B405-1DB1D42B6F8A',
  Name = coalesce(s.Name, t.Name, k.DistrictName),
  ParentID = isnull(s.ParentID, t.ParentID),
  Street = isnull(s.Street, t.Street),
  City = isnull(s.City, t.City),
  State = isnull(s.State, t.State),
  ZipCode = isnull(s.ZipCode, t.ZipCode),
  PhoneNumber = isnull(s.PhoneNumber, t.PhoneNumber),
  Number = coalesce(s.Number, t.Number, k.DistrictCode),
  Sequence = isnull(s.Sequence, t.Sequence)
from LEGACYSPED.District k left join 
	dbo.OrgUnit s on k.DistrictCode = s.Number left join -- DistrictCode and Number are synonymous with StateCode
	LEGACYSPED.MAP_OrgUnitID m on k.DistrictCode = m.DistrictCode left join 
	dbo.OrgUnit t on m.DestID = t.ID
GO
-- 


/*

ETL strategy:
	Never delete
	Request soft-delete mechanism to hide values from UI if necessary
	Update only records that are not the SystemSettings.LocalOrgRootID org

select * from OrgUnit


AAD80F07-6023-4753-AF26-309FF6BF845C	0	0	LEGACYSPED.Transform_OrgUnit	OrgUnit	1	LEGACYSPED.MAP_OrgUnitID	DistrictRefID	NULL	0	0	1	NULL	NULL	NULL	2011-08-31 08:18:16.360	NULL	29D14961-928D-4BEE-9025-238496D144C6	1	0	0

GEO.ShowLoadTables OrgUnit



set nocount on;
declare @n varchar(100) ; select @n = 'OrgUnit'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	HasMapTable = 1, 
	MapTable = 'LEGACYSPED.MAP_'+@n+'ID'   -- use this update for looksups only
	, KeyField = 'DistrictRefID'
	, DeleteKey = NULL
	, DeleteTrans = 0
	, UpdateTrans = 1
	, DestTableFilter = 'ID not in (select LocalOrgRootID from SystemSettings union select ID from OrgUnit where ParentID = (select LocalOrgRootID from SystemSettings))'
	, Enabled = 1
	from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n


select d.* 
-- UPDATE OrgUnit SET Sequence=s.Sequence, PhoneNumber=s.PhoneNumber, ZipCode=s.ZipCode, State=s.State, City=s.City, TypeID=s.TypeID, ParentID=s.ParentID, Street=s.Street, Name=s.Name, Number=s.Number
FROM  OrgUnit d JOIN 
	LEGACYSPED.Transform_OrgUnit  s ON s.DestID=d.ID
	AND ID not in (select LocalOrgRootID from SystemSettings union select ID from OrgUnit where ParentID = (select LocalOrgRootID from SystemSettings))

-- INSERT LEGACYSPED.MAP_OrgUnitID
SELECT DistrictRefID, NEWID()
FROM LEGACYSPED.Transform_OrgUnit s
WHERE NOT EXISTS (SELECT * FROM OrgUnit d WHERE s.DestID=d.ID)

-- INSERT OrgUnit (ID, Sequence, PhoneNumber, ZipCode, State, City, TypeID, ParentID, Street, Name, Number)
SELECT s.DestID, s.Sequence, s.PhoneNumber, s.ZipCode, s.State, s.City, s.TypeID, s.ParentID, s.Street, s.Name, s.Number
FROM LEGACYSPED.Transform_OrgUnit s
WHERE NOT EXISTS (SELECT * FROM OrgUnit d WHERE s.DestID=d.ID)

select * from OrgUnit







*/

