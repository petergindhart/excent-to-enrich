--create schema x_DATATEAM 
IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATATEAM' and o.name = 'SISStudentProfileData')
DROP PROC x_DATATEAM.SISStudentProfileData
GO

CREATE PROC x_DATATEAM.SISStudentProfileData
(@studentid uniqueidentifier ) AS 
BEGIN
--declare @studentid uniqueidentifier 
--set @studentid = '2B304C6D-80C1-4B8A-887C-9FD3D28F656A'

--Student
select ID
,Number as DistrictNumber
,FirstName,MiddleName,LastName
,DOB 
,GPA
,(select Name from School where ID = st.currentschoolID) as SchoolName
,(select Name from GradeLevel where ID = st.currentGradelevelID) as GradeName
,(select top 1 ev.DisplayValue from studentrace sr join EnumValue ev on sr.RaceID =ev.ID where sr.StudentID = st.ID) as EthnicityName
,(case when IsHispanic =0 then 'No' when IsHispanic =1 then 'Yes' else '' end) as IsHispanic
, stuff((select '; '+ (p.FirstName + ' '+ p.LastName )
 from Person p join StudentGuardian  sg On p.ID = sg.PersonID where sg.StudentID = st.ID for xml path('')),1,1,'')as GuardianName
,PhoneNumber
,(select top 1 p.EmailAddress from Person p join StudentGuardian  sg On p.ID = sg.PersonID where sg.StudentID = st.ID order by (case when p.EmailAddress IS null then 0 when p.EmailAddress Is not  null then 1 end) desc)as EmailAddress
,Street,City,STATE,ZipCode 
,(select DisplayValue from EnumValue where ID =  x_HomeLanguage) as LanguageSpokeninHome
from Student st where ID = @studentid

--Student Enronrollment
select (select ID from student where ID = sgh.StudentID) as StudentID,(select Name from GradeLevel where ID = sgh.GradeLevelID)as Gradelevel,sgh.StartDate,sgh.EndDate
from StudentGradeLevelHistory sgh where sgh.StudentID = @studentid

select (select ID from student where ID = ssh.StudentID) as StudentID,(select Name from School where ID = ssh.SchoolID)as SchoolEnrolled,ssh.StartDate,ssh.EndDate
from StudentSchoolHistory ssh  where ssh.StudentID = @studentid

--Extended properties
declare @xtend_columns varchar(max)
declare @sql varchar(max)
set @xtend_columns = (select stuff ((select ','+COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'student' and COLUMN_NAME like 'x_%' for xml path('')),1,1,''))
set @sql = 'SELECT ID, Number, '+ @xtend_columns +' FROM STUDENT WHERE ID = '''+CONVERT(VARCHAR(max),@studentid)+ ''''
--print @sql
exec (@sql)

--Guardian details 
select st.ID,st.Number,(select FirstName+' '+LastName from Person where ID = sg.PersonID) as GuardianName
,(select Name from StudentGuardianRelationship where ID = sg.RelationshipID) as Relationship
,(select ISNULL(Street,'')+', '+ISNULL(City,'')+', ' + ISNULL(STATE,'') + ', '+ ISNULL(EmailAddress,'')+ ', ' from Person where ID = sg.PersonID) as Address
from StudentGuardian sg join  Student st on st.ID = sg.StudentID where st.ID = @studentid

--select * from StudentGuardianRelationship

--select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'student' and COLUMN_NAME like 'x_%' 

--select Number,* from Student where x_HomeLanguage is not null
--select ev.DisplayValue from studentrace sr join EnumValue ev on sr.RaceID =ev.ID 
--select p.* from Person p join StudentGuardian  sg On p.ID = sg.PersonID
-- where sg.StudentID  = '63EC6584-95E6-4A48-8358-0D069DBCA82E'

--School
/*
select ID,Name,Abbreviation,Number,Street,City,STATE,ZipCode,PhoneNumber,(select Name from OrgUnit where ID = school.OrgUnitID) as OrgUnitName from School Where DeletedDate is null
--Teacher
select ID,(select Name from School where ID = Teacher.CurrentSchoolID) as schoolName,FirstName,LastName,EmailAddress
,(select top 1 ev.DisplayValue from TeacherRace tr join Teacher t on t.ID = tr.TeacherID join EnumValue ev on ev.ID = tr.RaceID) as Ethnicity
,(select StateCode from EnumValue where ID = GenderID) as Gender,Street,City,STATE,ZipCode,PhoneNumber 
from Teacher
*/
--select * from SchoolCalendar
END