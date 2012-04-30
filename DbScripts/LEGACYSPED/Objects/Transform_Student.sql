

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
  DestID = coalesce(s.ID, t.ID, m.DestID),
  LegacyData = ISNULL(m.LegacyData, case when s.ID IS NULL then 1 else 0 end), -- allows updating only legacy data by adding a DestFilter in LoadTable.  Leaves real ManuallyEntered students untouched.
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
  ImportPausedDate = cast(NULL as datetime),
  ImportPausedByID = cast(NULL as uniqueidentifier),
  IsActive = isnull(s.IsActive, 1),
  ManuallyEntered = ISNULL(m.LegacyData, case when s.ID IS NULL then 1 else 0 end) -- cast(case when dest.ID is null then 1 else 0 end as bit),
 FROM
  LEGACYSPED.IEP iep join -- this file is to ensure a 1:1 relationship on imported students and IEPs (some IEPs may have failed vailidation, which would make the count less than students)
  LEGACYSPED.Student src on iep.StudentRefID = src.StudentRefID LEFT JOIN
  LEGACYSPED.Transform_GradeLevel g on src.GradeLevelCode = g.GradeLevelCode LEFT JOIN
  LEGACYSPED.Transform_School sch on src.ServiceSchoolCode = sch.SchoolCode LEFT JOIN
  dbo.Student s on src.StudentLocalID = s.Number and /* and s.IsActive = 1 -- removed 20111114 because this was adding a duplicate student.  We will leave them inactive, though */ 
	s.ID = (
		select top 1 a.ID 
		from dbo.Student a 
		where
			a.Number = s.Number 
		order by a.ManuallyEntered, a.IsActive desc, a.ID) LEFT JOIN -- identifies students in legacy data that match students in Enrich
  LEGACYSPED.MAP_StudentRefID m on src.StudentRefID = m.StudentRefID LEFT JOIN
  dbo.Student t on m.DestID = t.ID -- exists in map table
GO


