--#include Transform_GradeLevel.sql
--#include Transform_School.sql

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
  CurrentSchoolID = sch.DestID,  
  CurrentGradeLevelID = g.DestID,  
  --EthnicityID = CAST(NULL as uniqueidentifier),
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
  -- select s.isactive, t.isactive, src.*
 FROM LEGACYSPED.Student src LEFT JOIN
  -- LEGACYSPED.Transform_Ethnicity te on src.EthnicityCode = te.Code LEFT JOIN
  LEGACYSPED.Transform_GradeLevel g on src.GradeLevelCode = g.GradeLevelCode LEFT JOIN
  LEGACYSPED.Transform_School sch on src.ServiceSchoolRefID = sch.SchoolRefID LEFT JOIN
  dbo.Student s on src.StudentLocalID = s.Number and s.IsActive = 1 LEFT JOIN -- identifies students in legacy data that match students in Enrich
  LEGACYSPED.MAP_StudentRefID m on src.StudentRefID = m.StudentRefID LEFT JOIN
  dbo.Student t on m.DestID = t.ID -- exists in map table
GO


/*



select * from LEGACYSPED.MAP_StudentRefID where StudentRefID = '86BB627C-0F35-4E1F-919D-39A4233AC24C'

select isactive, * from student where number =  '10400192'

select * from LEGACYSPED.Transform_Student where number =  '10400192'



select h.SchoolCode, COUNT(*) tot
from LEGACYSPED.School h
group by h.SchoolCode
having COUNT(*) > 1



select * from LEGACYSPED.Transform_School where DestID in ('FC1C9F0B-D2F8-46DC-BFCF-6808A4C87FBA', 'AD7F149B-9C91-4A58-8A7A-B2015C5C69B6')

select * from legacysped.school where schoolrefid = '0FB9716F-77CC-4456-8FE7-AFB834E9FFDE'
900



select * from VC3ETL.LoadTable where ID = '0650F23E-B249-4D90-8389-36B73375B506'



NOTES: 

Import strategy:  
	don't touch sis data (no updates or deletes)
	delete missing map records
		legacy student data remains in dbo.Student
	update only legacy student records
	insert legacy student records that don't exist in dbo.Student 

The mechanism to distinguish Legacy students from SIS students is the LEGACYSPED.MAP_StudentRefID.LegacyData.  Note how this is derived in the Transform query



GEO.ShowLoadTables Student

set nocount on;
declare @n varchar(100) ; select @n = 'Student'
declare @t uniqueidentifier ; select @t = id from VC3ETL.LoadTable where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6' and DestTable = @n
update t set 
	HasMapTable = 1
	, MapTable = 'LEGACYSPED.MAP_StudentRefID'
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
-- DELETE LEGACYSPED.MAP_StudentRefID
FROM LEGACYSPED.Transform_Student AS s RIGHT OUTER JOIN 
	LEGACYSPED.MAP_StudentRefID as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

select d.*
-- UPDATE Student SET CurrentGradeLevelID=s.CurrentGradeLevelID, CurrentSchoolID=s.CurrentSchoolID, Number=s.Number, MiddleName=s.MiddleName, GenderID=s.GenderID, LastName=s.LastName, ManuallyEntered=s.ManuallyEntered, DOB=s.DOB, IsActive=s.IsActive, FirstName=s.FirstName, IsHispanic=s.IsHispanic
FROM  Student d JOIN 
	LEGACYSPED.Transform_Student  s ON s.DestID=d.ID
	AND s.LegacyData = 1

-- INSERT LEGACYSPED.MAP_StudentRefID
SELECT StudentRefID, LegacyData, NEWID()
FROM LEGACYSPED.Transform_Student s
WHERE NOT EXISTS (SELECT * FROM Student d WHERE s.DestID=d.ID)

-- INSERT Student (ID, CurrentGradeLevelID, CurrentSchoolID, Number, MiddleName, GenderID, LastName, ManuallyEntered, DOB, IsActive, FirstName, IsHispanic)
SELECT s.DestID, s.CurrentGradeLevelID, s.CurrentSchoolID, s.Number, s.MiddleName, s.GenderID, s.LastName, s.ManuallyEntered, s.DOB, s.IsActive, s.FirstName, s.IsHispanic
FROM LEGACYSPED.Transform_Student s
WHERE NOT EXISTS (SELECT * FROM Student d WHERE s.DestID=d.ID)


select * from Student where ManuallyEntered = 1 -- students that really were manually entered plus students added by ETL


select * from LEGACYSPED.MAP_StudentRefID 





begin tran stu
INSERT LEGACYSPED.MAP_StudentRefID
SELECT StudentRefID, LegacyData, NEWID()
FROM LEGACYSPED.Transform_Student s
WHERE NOT EXISTS (SELECT * FROM Student d WHERE s.DestID=d.ID)

INSERT Student (ID, CurrentGradeLevelID, CurrentSchoolID, Number, MiddleName, GenderID, LastName, ManuallyEntered, DOB, IsActive, FirstName, IsHispanic)
SELECT s.DestID, s.CurrentGradeLevelID, s.CurrentSchoolID, s.Number, s.MiddleName, s.GenderID, s.LastName, s.ManuallyEntered, s.DOB, s.IsActive, s.FirstName, s.IsHispanic
FROM LEGACYSPED.Transform_Student s
WHERE NOT EXISTS (SELECT * FROM Student d WHERE s.DestID=d.ID)


SELECT StudentRefID, count(*) tot
FROM LEGACYSPED.Transform_Student s
WHERE NOT EXISTS (SELECT * FROM Student d WHERE s.DestID=d.ID)
group by StudentRefID
having count(*) > 1


select * from LEGACYSPED.Transform_Student where studentrefid = '0A217207-CD00-49BB-A662-C5992D4125E5'


select * from school where ID in ('FC1C9F0B-D2F8-46DC-BFCF-6808A4C87FBA', 'AD7F149B-9C91-4A58-8A7A-B2015C5C69B6')






rollback tran stu





*/


