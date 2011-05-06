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
	DestID = isnull(tgt.ID, newid()),
	Abbreviation = src.SchoolAbbreviation,
	Name = src.SchoolName,
	Number = src.SchoolCode,
	OrgUnitId = mo.DestID,
	IsLocalOrg = case when r.ID is null then 0 else 1 end, 
	ManuallyEntered = cast(1 as bit),
	MinutesInstruction = cast(1800 as int), -- Defaulted for now. Should consider getting this from the customers.  Would need to be added to the data specification
	Street = cast(null as varchar),
	City = cast(null as varchar),
	State = cast(null as varchar),
	ZipCode = cast(null as varchar),
	PhoneNumber = cast(null as varchar)
from AURORAX.School src JOIN
	AURORAX.MAP_OrgUnit mo on src.DistrictRefID = mo.DistrictRefID LEFT JOIN
	dbo.School tgt on src.SchoolCode = tgt.Number and mo.DestID = tgt.OrgUnitId LEFT JOIN
	dbo.SystemSettings r on mo.DestID = r.LocalOrgRootID
where isnull(tgt.ManuallyEntered,1) = 1
GO


IF  EXISTS (SELECT 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'AURORAX' and o.name = 'MAP_SchoolView')
	DROP VIEW AURORAX.MAP_SchoolView
GO

create view AURORAX.MAP_SchoolView
as
/*
	Using this view instead of a map table for simplicity of the ETL for school
*/
select xs.SchoolRefId, ss.DestID
from (
	select SchoolCode, DestID
	from AURORAX.Transform_School
	union
	select Number, ID
	from dbo.School
	) ss JOIN
	AURORAX.School xs on ss.SchoolCode = xs.SchoolCode
go
---