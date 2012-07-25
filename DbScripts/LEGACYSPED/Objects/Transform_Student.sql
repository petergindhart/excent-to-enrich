

-- #############################################################################
-- Student
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_StudentRefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_StudentRefID
	(
	StudentRefID varchar(150) NOT NULL,
	LegacyData bit not null,
	DestID uniqueidentifier NOT NULL
	)  

ALTER TABLE LEGACYSPED.MAP_StudentRefID ADD CONSTRAINT
	PK_MAP_StudentRefID PRIMARY KEY CLUSTERED
	(
	StudentRefID
	) 
END

GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_Student') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_Student
GO

CREATE VIEW LEGACYSPED.Transform_Student
AS 
-- NOTE:  DO NOT TOUCH THE RECORDS ADDED BY SIS IMPORT OR MANUALLY ENTERED STUDENTS.  SIS RECORDS DO NEED TO BE MAPPED.  NEW RECORDS FROM SPED NEED TO BE ADDED.
 SELECT
  src.StudentRefID,
  DestID = coalesce(sst.ID, sloc.ID, snam.ID, m.DestID),
  LegacyData = ISNULL(m.LegacyData, case when coalesce(sst.ID, sloc.ID, snam.ID) IS NULL then 1 else 0 end), -- allows updating only legacy data by adding a DestFilter in LoadTable.  Leaves real ManuallyEntered students untouched.
  src.SpecialEdStatus,
  CurrentSchoolID = sch.DestID,
  CurrentGradeLevelID = g.DestID,
  --EthnicityID = CAST(NULL as uniqueidentifier),
  GenderID = (select TOP 1 ID from EnumValue where Type = 'D6194389-17AC-494C-9C37-FD911DA2DD4B' and Code = src.Gender), -- will error if more than one value
  Number = src.StudentLocalID,
  src.FirstName,
  src.MiddleName,
  src.LastName,
  SSN = cast(null as varchar),
  DOB = src.Birthdate,
  Street = cast(null as varchar),
  City = cast(null as varchar),
  State = cast(null as char),
  ZipCode = cast(null as varchar),
  PhoneNumber = cast(null as varchar),
  GPA = cast(0 as float),
  x_Retain = cast(0 as bit),
  LinkedToAEPSi = cast(0 as bit),
  IsHispanic = case when src.IsHispanic = 'Y' then 1 else 0 end,
  MedicaidNumber = src.MedicaidNumber,
  OID = (select DestID from LEGACYSPED.MAP_AdminUnitID),
  ImportPausedDate = cast(NULL as datetime),
  ImportPausedByID = cast(NULL as uniqueidentifier),
  IsActive = coalesce(sst.IsActive, sloc.IsActive, 1),
  ManuallyEntered = ISNULL(m.LegacyData, case when coalesce(sst.ID, sloc.ID, snam.ID, m.DestID) IS NULL then 1 else 0 end), -- cast(case when dest.ID is null then 1 else 0 end as bit),
  Touched = isnull(cast(i.IsEnded as int)+i.Revision+ case when i.StudentID is not null then 1 else 0 end, 0) -- what is the purpose of this?  gg 20120618
 FROM
  LEGACYSPED.IEP iep join -- this is to ensure a 1:1 relationship on imported students and IEPs (some IEPs may have failed vailidation.  avoid importing Student without IEP).
  LEGACYSPED.Student src on iep.StudentRefID = src.StudentRefID LEFT JOIN
  LEGACYSPED.Transform_GradeLevel g on src.GradeLevelCode = g.GradeLevelCode LEFT JOIN
  LEGACYSPED.Transform_School sch on src.ServiceSchoolCode = sch.SchoolCode and src.ServiceDistrictCode = sch.DistrictCode LEFT JOIN

  -- match on StateID if possible
 LEGACYSPED.StudentView sst on src.StudentStateID = sst.StudentStateID and
 sst.ID = (
  select top 1 a.ID 
  from LEGACYSPED.StudentView a 
  where
   isnull(a.StudentStateID,'x') = isnull(sst.StudentStateID,'y')
  order by a.ManuallyEntered, a.IsActive desc, a.ID) LEFT JOIN -- identifies students in legacy data that match students in Enrich

  -- match on Local ID if State ID not available
  dbo.Student sloc on src.StudentLocalID = sloc.Number and 
	sloc.ID = (
		select top 1 a.ID 
		from dbo.Student a 
		where
			a.Number = sloc.Number 
		order by a.ManuallyEntered, a.IsActive desc, a.ID) LEFT JOIN -- identifies students in legacy data that match students in Enrich

  -- match on firstname, lastname, dob and Gender if Local ID not available
  dbo.Student snam on 
	src.Firstname = snam.FirstName and 
	src.LastName = snam.LastName and 
	src.Birthdate = snam.DOB and
	-- and src.Gender = snam.GenderID
	snam.ID = (
		select top 1 a.ID -- this may prevent duplicates, but may not prevent bad matches
		from dbo.Student a 
		where
			a.Firstname = snam.FirstName and 
			a.LastName = snam.LastName and 
			a.DOB = snam.DOB 
		order by a.ManuallyEntered, a.IsActive desc, a.ID) LEFT JOIN -- identifies students in legacy data that match students in Enrich

  -- verify that the student has not been previously imported as mnaually entered.
  LEGACYSPED.MAP_StudentRefID m on src.StudentRefID = m.StudentRefID LEFT JOIN
  dbo.Student t on m.DestID = t.ID left join 
  -- on subsequent imports, verify whether records associated with the manually entered student have been modified.  I don't remember why this was necessary.  the query below checks for existance of a non-converted iep.
  PrgItem i on coalesce(sst.ID, sloc.ID, snam.ID, m.DestID) = i.StudentID and i.DefID = '8011D6A2-1014-454B-B83C-161CE678E3D3' left join 
	( 
	select s.StudentRefID, i.StudentID, ItemID = i.ID, i.InvolvementID, i.IsEnded, i.Revision
	from PrgItem i join (select StudentID = b.ID, a.StudentRefID from LEGACYSPED.Student a join LEGACYSPED.StudentView b on (a.StudentLocalID = b.Number or a.StudentStateID = b.StudentStateID or a.Firstname = b.FirstName and a.LastName = b.LastName and a.Birthdate = b.DOB) and b.IsActive = 1) s on i.StudentID = s.StudentID -- if items are eliminated by join to Transform_Student not to worry, because we are not importing them anyway
	where i.ID = (
		select max(convert(varchar(36), i2.ID)) -- we are arbitrarily selecting only one of the non-converted items of type "IEP", because we just need to know if one exists
		from (select i3.ID, i3.StudentID from PrgItem i3 join PrgItemDef d3 on i3.DefID = d3.ID join PrgInvolvement v3 on i3.InvolvementID = v3.ID where d3.TypeID = 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870' and i3.DefID <> '8011D6A2-1014-454B-B83C-161CE678E3D3' and v3.EndDate is null) i2 -- TypeID = IEP, non-converted
			where i.StudentID = i2.StudentID) 
			) xni on src.StudentRefID = xni.StudentRefID
GO

