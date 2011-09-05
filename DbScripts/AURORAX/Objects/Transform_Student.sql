--#include Transform_School.sql

-- #############################################################################
-- Student
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_StudentRefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE AURORAX.MAP_StudentRefID
	(
	StudentRefID varchar(150) NOT NULL,
	LegacyData bit not null,
	DestID uniqueidentifier NOT NULL
	)  

ALTER TABLE AURORAX.MAP_StudentRefID ADD CONSTRAINT
	PK_MAP_StudentRefID PRIMARY KEY CLUSTERED
	(
	StudentRefID
	) 
END
ELSE
BEGIN

	select m.StudentRefID, LegacyData = CAST(case when s.ManuallyEntered = 1 then 1 else 0 end as Bit), m.DestID
	into AURORAX.TEMP_MAP_StudentRefID
	from AURORAX.MAP_StudentRefID m join
		dbo.Student s on m.DestID = s.ID
	
	DROP TABLE AURORAX.MAP_StudentRefID 

	select StudentRefID, LegacyData, DestID
	into AURORAX.MAP_StudentRefID
	from AURORAX.TEMP_MAP_StudentRefID
	
END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_Student') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_Student
GO

CREATE VIEW AURORAX.Transform_Student
AS
-- NOTE:  DO NOT TOUCH THE RECORDS ADDED BY SIS IMPORT OR MANUALLY ENTERED STUDENTS.  SIS RECORDS DO NEED TO BE MAPPED.  NEW RECORDS FROM SPED NEED TO BE ADDED. 
 SELECT
  src.StudentRefID,
  DestID = coalesce(s.ID, t.ID, m.DestID),
  LegacyData = ISNULL(m.LegacyData, case when s.ID IS NULL then 1 else 0 end), -- allows updating only legacy data by adding a DestFilter in LoadTable.  Leaves real ManuallyEntered students untouched.
  CurrentSchoolID = sch.DestID,  
  CurrentGradeLevelID = g.DestID,  
  EthnicityID = CAST(NULL as uniqueidentifier),
  GenderID = (select ID from EnumValue where Type = 'D6194389-17AC-494C-9C37-FD911DA2DD4B' and Code = src.Sex), -- will error if more than one value
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
  x_SunsNumber = cast(null as varchar),  
  x_GradDate = cast(NULL as datetime),  
  x_ESOLExitDate = cast(NULL as datetime),  
  x_USSchoolEntryDate = cast(NULL as datetime),  
  x_CountryOfOrigin = cast(NULL as uniqueidentifier),  
  x_HomeLanguage = cast(NULL as uniqueidentifier),  
  x_Retain = cast(0 as bit),  
  LinkedToAEPSi = cast(0 as bit),  
  x_spedExitDate = cast(NULL as datetime),  
  x_section504 = cast(0 as bit),  
  x_language = cast(NULL as uniqueidentifier),  
  x_IEP = cast(0 as bit),
  x_giftedTalented = cast(NULL as uniqueidentifier),
  x_englishProficiency = cast(NULL as uniqueidentifier),  
  x_DisabilityType = cast(NULL as uniqueidentifier),  
  x_FreeLunchID = cast(NULL as uniqueidentifier),  
  x_CSAP_A = cast(0 as bit),  
  IsHispanic = case when src.IsHispanic = 'Y' then 1 else 0 end,  
  ImportPausedDate = cast(NULL as datetime),  
  ImportPausedByID = cast(NULL as uniqueidentifier),
  IsActive = cast(isnull(t.IsActive,1) as bit),  
  ManuallyEntered = cast(isnull(t.ManuallyEntered,1) as bit) -- cast(case when dest.ID is null then 1 else 0 end as bit),  
 FROM 
  AURORAX.Student src LEFT JOIN
  -- AURORAX.Transform_Ethnicity te on src.EthnicityCode = te.Code LEFT JOIN
  AURORAX.Transform_GradeLevel g on src.GradeLevelCode = g.GradeLevelCode LEFT JOIN
  AURORAX.Transform_School sch on src.ServiceSchoolRefID = sch.SchoolRefID LEFT JOIN
  dbo.Student s on src.StudentLocalID = s.Number and s.IsActive = 1 LEFT JOIN -- identifies students in legacy data that match students in Enrich
  AURORAX.MAP_StudentRefID m on src.StudentRefID = m.StudentRefID LEFT JOIN
  dbo.Student t on m.DestID = t.ID -- exists in map table
 --WHERE
 -- t.ID is null   -- not in Enrich yet.  Do not use this where clause.  we want to see students added by SIS and Legacy Sped students at the same time
GO


/*

select * from VC3ETL.LoadTable where ID = '0650F23E-B249-4D90-8389-36B73375B506'



NOTES: 

Import strategy:  
	don't touch sis data (no updates or deletes)
	delete missing map records
		legacy student data remains in dbo.Student
	update only legacy student records
	insert legacy student records that don't exist in dbo.Student 

The mechanism to distinguish Legacy students from SIS students is the AURORAX.MAP_StudentRefID.LegacyData.  Note how this is derived in the Transform query



GEO.ShowLoadTables Student

set nocount on;
declare @n varchar(100) ; select @n = 'Student'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	HasMapTable = 1
	, MapTable = 'AURORAX.MAP_StudentRefID'
	, KeyField = 'StudentRefID, LegacyData'
	, DeleteKey = 'DestID'
	, DeleteTrans = 1
	, UpdateTrans = 1
	, DestTableFilter = 's.LegacyData = 1'
	, Enabled = 1
	from VC3ETL.LoadTable t where t.ID = @t
exec VC3ETL.LoadTable_Run @t, '', 1, 0
print '

select * from '+@n

select d.*
-- DELETE AURORAX.MAP_StudentRefID
FROM AURORAX.Transform_Student AS s RIGHT OUTER JOIN 
	AURORAX.MAP_StudentRefID as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

select d.*
-- UPDATE Student SET CurrentGradeLevelID=s.CurrentGradeLevelID, CurrentSchoolID=s.CurrentSchoolID, Number=s.Number, MiddleName=s.MiddleName, GenderID=s.GenderID, LastName=s.LastName, ManuallyEntered=s.ManuallyEntered, DOB=s.DOB, IsActive=s.IsActive, FirstName=s.FirstName, IsHispanic=s.IsHispanic
FROM  Student d JOIN 
	AURORAX.Transform_Student  s ON s.DestID=d.ID
	AND s.LegacyData = 1

-- INSERT AURORAX.MAP_StudentRefID
SELECT StudentRefID, LegacyData, NEWID()
FROM AURORAX.Transform_Student s
WHERE NOT EXISTS (SELECT * FROM Student d WHERE s.DestID=d.ID)

-- INSERT Student (ID, CurrentGradeLevelID, CurrentSchoolID, Number, MiddleName, GenderID, LastName, ManuallyEntered, DOB, IsActive, FirstName, IsHispanic)
SELECT s.DestID, s.CurrentGradeLevelID, s.CurrentSchoolID, s.Number, s.MiddleName, s.GenderID, s.LastName, s.ManuallyEntered, s.DOB, s.IsActive, s.FirstName, s.IsHispanic
FROM AURORAX.Transform_Student s
WHERE NOT EXISTS (SELECT * FROM Student d WHERE s.DestID=d.ID)


select * from Student where ManuallyEntered = 1 -- students that really were manually entered plus students added by ETL


select * from AURORAX.MAP_StudentRefID 



*/


