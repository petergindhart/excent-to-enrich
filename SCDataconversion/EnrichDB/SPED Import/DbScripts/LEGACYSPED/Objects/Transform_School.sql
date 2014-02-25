
-- ############################################################################# 
-- School

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_SchoolID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
begin
	IF NOT EXISTS (SELECT * FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id join sys.columns c on o.object_id = c.object_id WHERE s.name = 'LEGACYSPED' and o.name = 'MAP_SchoolID' and c.name = 'LegacyData') 
	drop table LEGACYSPED.MAP_SchoolID
end

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_SchoolID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE LEGACYSPED.MAP_SchoolID
BEGIN
CREATE TABLE LEGACYSPED.MAP_SchoolID
	(
	SchoolCode varchar(150) NOT NULL,
	DistrictCode varchar(150) NOT NULL,
	LegacyData bit NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  

ALTER TABLE LEGACYSPED.MAP_SchoolID ADD CONSTRAINT
	PK_MAP_SchoolID PRIMARY KEY CLUSTERED
	(
	SchoolCode,DistrictCode
	) 
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_School') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_School  
GO

CREATE VIEW LEGACYSPED.Transform_School
AS
-- Consider whether or not to exclude records where DeleteDate is not null.  If not, we need to chnage all queries that reference School 
select 
	k.SchoolCode,
	k.DistrictCode,
	DestID =  coalesce(s.ID, t.ID, m.DestID), -- ISNULL(isnull(s.ID, t.ID), m.DestID),
	LegacyData = ISNULL(m.LegacyData, case when s.ID IS NULL then 1 else 0 end), -- allows updating only legacy data by adding a DestFilter in LoadTable.  Leaves real ManuallyEntered schools untouched.,
	Abbreviation = NULL,
	--coalesce(s.Abbreviation, t.Abbreviation, k.SchoolAbbreviation),
	Name = coalesce(s.Name, t.Name, k.SchoolName), 
	Number = coalesce(s.Number, t.Number, k.SchoolCode),
	OrgUnitId = mo.DestID,
	--IsLocalOrg = coalesce(s.IsLocalOrg, t.IsLocalOrg, 0), 
	ManuallyEntered = coalesce(s.ManuallyEntered, t.ManuallyEntered, 1), 
	MinutesInstruction = coalesce(s.MinutesInstruction, t.MinutesInstruction, CASE WHEN k.MinutesPerWeek > 0 THEN k.MinutesPerWeek ELSE NULL END),
	Street = isnull(s.Street, t.Street),
	City = isnull(s.City, t.City),
	State = isnull(s.State, t.State),
	ZipCode = isnull(s.ZipCode, t.ZipCode),
	PhoneNumber = isnull(s.PhoneNumber, t.PhoneNumber),
	DeletedDate = 
		case 
			when s.id is not null then s.DeletedDate
			when t.ID is not null then t.DeletedDate 
			else NULL -- Question whether it is needed or advisable to soft-delete these schools
		end 
from LEGACYSPED.DistrictSchoolLeadingZeros dz cross join LEGACYSPED.DistrictSchoolLeadingZeros sz cross join
	LEGACYSPED.School k LEFT JOIN 
	dbo.School s on right(sz.Zeros+isnull(k.SchoolCode,''), len(sz.zeros)) = right(sz.Zeros+isnull(s.Number,''), len(sz.zeros)) and s.DeletedDate is null and -- assumes there is only one, and will insert new if any are soft-deleted
		-- AND s.IsLocalOrg = 1 
	convert(varchar(36), s.ID) = ( -- we're doing this in the ON clause as opposed to the WHERE clause to get schools that don't come from SIS (Poudre "Expelled School")
		select MIN(convert(varchar(36), smid.ID))
		from dbo.School smid 
		where right(sz.Zeros+isnull(s.Number,''), len(sz.zeros)) = right(sz.Zeros+isnull(smid.Number,''), len(sz.zeros)) -- could have left this along since we are comparing the table's data to itself
		and cast(smid.ManuallyEntered as int) = (
			select MIN(cast(smin.ManuallyEntered as int))
			from dbo.School smin 
			where right(sz.Zeros+isnull(smid.Number,''), len(sz.zeros)) = right(sz.Zeros+isnull(smin.Number,''), len(sz.zeros)) -- don't try to deal with null numbers.  how about real dups?
			)
		) LEFT JOIN
	LEGACYSPED.MAP_SchoolID m on right(sz.Zeros+isnull(k.SchoolCode,''), len(sz.zeros)) = right(sz.Zeros+isnull(m.SchoolCode,''), len(sz.zeros)) and right(dz.Zeros+isnull(k.DistrictCode,''), len(dz.zeros)) = right(dz.Zeros+isnull(m.DistrictCode,''), len(dz.zeros))  LEFT JOIN 
	dbo.School t on m.DestID = t.ID LEFT JOIN
	LEGACYSPED.Transform_OrgUnit mo on right(dz.Zeros+isnull(k.DistrictCode,''), len(dz.zeros)) = right(dz.Zeros+isnull(mo.DistrictCode,''), len(dz.zeros)) 
where dz.Entity = 'District' and sz.Entity = 'School'
GO
