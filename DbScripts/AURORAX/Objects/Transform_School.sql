IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_School]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_School]  
GO  

CREATE VIEW [AURORAX].[Transform_School]
AS
/*
  Note:  we are not using a map and we will not be deleting any existing records.
  Using ManuallyEntered = 1 filter to ensure we don't touch any records maintained by SIS imports

*/
select
	src.SchoolRefID,
	src.SchoolCode,
	DestID = ISNULL(m.DestID, NEWID()),
	Abbreviation = src.SchoolAbbreviation,
	Name = src.SchoolName,
	Number = src.SchoolCode,
	OrgUnitId = mo.DestID,
	IsLocalOrg = 0, 
	ManuallyEntered = cast(1 as bit),
	MinutesInstruction = CASE WHEN src.MinutesPerWeek > 0 THEN src.MinutesPerWeek ELSE NULL END,
	Street = cast(null as varchar),
	City = cast(null as varchar),
	State = cast(null as varchar),
	ZipCode = cast(null as varchar),
	PhoneNumber = cast(null as varchar),
	DeletedDate = GETDATE()
from 
	AURORAX.School src JOIN
	AURORAX.MAP_OrgUnit mo on src.DistrictRefID = mo.DistrictRefID LEFT JOIN
	AURORAX.MAP_SchoolRefID m on src.SchoolRefID = m.SchoolRefID

GO


IF  EXISTS (SELECT 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'AURORAX' and o.name = 'MAP_SchoolView')
	DROP VIEW AURORAX.MAP_SchoolView
GO
