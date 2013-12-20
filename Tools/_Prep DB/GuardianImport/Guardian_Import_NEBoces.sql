
--CREATE SCHEMA x_ADHOCIMPORT
--GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_ADHOCIMPORT.Guardian') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_ADHOCIMPORT.Guardian
	(
	[ID] [varchar](150) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[EmailAddress] [varchar](75) NULL,
	[Street] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[State] [char](2) NULL,
	[ZipCode] [varchar](10) NULL,
	[HomePhoneNumber] [varchar](40) NULL,
	[WorkPhoneNumber] [varchar](40) NULL,
	[CellPhoneNumber] [varchar](40) NULL
	)
	END
	
--DROP TABLE x_ADHOCIMPORT.Guardian
	
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_ADHOCIMPORT.StudentGuardians') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_ADHOCIMPORT.StudentGuardians(
	[ID] [varchar](150) NOT NULL,
	[StudentID] [varchar](150) NOT NULL,
	[GuardianID] [varchar](150) NOT NULL,
	[RelationshipID] [varchar](150) NOT NULL
	)
END


IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_ADHOCIMPORT.Map_Person') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE
	x_ADHOCIMPORT.Map_Person(
	DESTID [varchar](150) NOT NULL,
	[GuardianID] [varchar](150) NOT NULL
	)
END

--DROP TABLE x_ADHOCIMPORT.StudentGuardians
begin tran test

CREATE TABLE #Guardian
	(
	[ID] [varchar](150) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[EmailAddress] [varchar](75) NULL,
	[Street] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[State] [char](2) NULL,
	[ZipCode] [varchar](10) NULL,
	[HomePhoneNumber] [varchar](40) NULL,
	[WorkPhoneNumber] [varchar](40) NULL,
	[CellPhoneNumber] [varchar](40) NULL
	)
	
	CREATE TABLE
	#StudentGuardians(
	[ID] [varchar](150) NOT NULL,
	[StudentID] [varchar](150) NOT NULL,
	[GuardianID] [varchar](150) NOT NULL,
	[RelationshipID] [varchar](150) NOT NULL
	)
	
--INSERT Guardian file
BULK INSERT #Guardian
FROM 'E:\EnrichDataFiles\CO\NEBOCES\Profile\Guardians.csv'
WITH ( FIELDTERMINATOR ='|',ROWTERMINATOR ='\n', FIRSTROW = 2)

--INSERET StudentGuardianFile
BULK INSERT #StudentGuardians
FROM 'E:\EnrichDataFiles\CO\NEBOCES\Profile\StudentGuardians.csv'
WITH ( FIELDTERMINATOR ='|',ROWTERMINATOR ='\n', FIRSTROW = 2)

--select FirstName,LastName,COUNT(*) from #Guardian group by FirstName,LastName having COUNT(*)>1

Insert x_ADHOCIMPORT.Guardian
Select * from  #Guardian s
Where NOT EXISTS (select * from x_ADHOCIMPORT.Guardian d where d.ID = s.ID)

Insert x_ADHOCIMPORT.StudentGuardians
Select * from  #StudentGuardians s
Where NOT EXISTS (select * from x_ADHOCIMPORT.StudentGuardians d where d.ID = s.ID) --47



select RelationshipID, count(*) tot
from x_ADHOCIMPORT.StudentGuardians
group by RelationshipID
order by RelationshipID

select * from dbo.StudentGuardianRelationship



-- select * from Person where ManuallyEntered = 0 order by FirstName --66 --72

--INSERT PERSON
--BEGIN TRAN Test

--INSERT PERSON (map)
INSERT x_ADHOCIMPORT.Map_person (destid,GuardianID)
SELECT NEWID(),g.ID FROM x_ADHOCIMPORT.Guardian g


INSERT Person (ID,TypeID,Deleted,FirstName,LastName,EmailAddress,Street,City,Zip,State,HomePhone,WorkPhone,CellPhone,ManuallyEntered,Agency,Title,ImportPausedDate,ImportPausedByID)
SELECT 
	m.DestID,
	TypeID = 'P',
	NULL,
	g.FirstName,
	g.LastName,
	g.EmailAddress,
	g.Street,
	g.City,
	g.ZipCode,
	g.State,
	g.HomePhoneNumber,
	g.WorkPhoneNumber,
	g.CellPhoneNumber,
	0,
	NULL,
	NULL,
	NULL,
	NULL	
FROM x_ADHOCIMPORT.Guardian g 
JOIN x_ADHOCIMPORT.Map_Person m on m.GuardianID = g.ID
	order by g.FirstNAme

--select * from StudentGuardian  --66  --74



--INSERT STUDENTGUARDIAN
INSERT StudentGuardian (ID,StudentID,PersonID,RelationshipID,Sequence,DeletedDate)
SELECT 
NEWID(),
StudentID= st.DestID,
PersonID = m.DestID,
RelationshipID = case when asg.RelationshipID = 'Father' then '77FD70D3-9A29-4748-8DAF-04A379CEC03F' 
when asg.RelationshipID = 'Mother' then 'D49B09A6-5425-43B9-A1AB-35AF202C9E46' 
else '1BAE9149-0529-41A0-BF5B-1658F2181851' end ,
Sequence = 0,
DeletedDate = NULL
FROM 
x_ADHOCIMPORT.StudentGuardians asg JOIN
LEGACYSPED.Transform_Student st ON asg.StudentID = st.StudentRefID join 
x_ADHOCIMPORT.Guardian ag ON ag.ID = asg.GuardianID join 
x_ADHOCIMPORT.Map_Person m on m.guardianID = ag.ID LEFT JOIN
StudentGuardian stg on stg.PersonID = m.DestID and stg.StudentID = st.StudentRefID and DeletedDate IS NULL AND stg.RelationshipID = (case when asg.RelationshipID = 'Father' then '77FD70D3-9A29-4748-8DAF-04A379CEC03F' 
when asg.RelationshipID = 'Mother' then 'D49B09A6-5425-43B9-A1AB-35AF202C9E46' 
else '1BAE9149-0529-41A0-BF5B-1658F2181851' end )
where stg.StudentID is null and stg.RelationshipID is null and stg.DeletedDate is null and stg.RelationshipID is null  --579
--Student address populate

UPDATE st
SET City = ag.City,
	Street = ag.Street,
	State = ag.State,
	ZipCode = ag.ZipCode,
	PhoneNumber  = ag.HomePhoneNumber
--select asg.*,p.*
FROM 
x_ADHOCIMPORT.StudentGuardians asg JOIN
Legacysped.Transform_Student lst ON asg.StudentID = lst.StudentRefID join 
Student st on st.ID  = lst.DestID  join 
x_ADHOCIMPORT.Guardian ag ON ag.ID = asg.GuardianID join 
x_ADHOCIMPORT.Map_Person m on m.guardianID  = ag.ID join
Person p on m.destid = p.ID
Where p.TypeID = 'P'  
--rollback tran test


DROP TABLE #StudentGuardians
GO
DROP TABLE #Guardian
GO

/*
(3335 row(s) affected)

(3708 row(s) affected)

(3335 row(s) affected)

(3708 row(s) affected)

(3335 row(s) affected)

(3335 row(s) affected)

(579 row(s) affected)

(494 row(s) affected)

*/
--rollback tran test
commit tran test

--rollback tran test

/*
select * from Person

select * from x_ADHOCIMPORT.guardian
select * from x_ADHOCIMPORT.StudentGuardians
select * from StudentGuardianRelationship

sp_help person
sp_help studentguardian

select * FROM x_ADHOCIMPORT.Guardian

select * from 



select asg.*
FROM 
x_ADHOCIMPORT.StudentGuardians asg JOIN
LEGACYSPED.Transform_Student st ON asg.StudentID = st.StudentRefID join 
x_ADHOCIMPORT.Guardian ag ON ag.ID = asg.GuardianID join 
x_ADHOCIMPORT.Map_Person m on m.guardianID = ag.ID LEFT JOIN
StudentGuardian stg on stg.PersonID = m.DestID and stg.StudentID = st.StudentRefID and DeletedDate IS NULL AND stg.RelationshipID = (case when asg.RelationshipID = 'Father' then '77FD70D3-9A29-4748-8DAF-04A379CEC03F' 
when asg.RelationshipID = 'Mother' then 'D49B09A6-5425-43B9-A1AB-35AF202C9E46' 
else '1BAE9149-0529-41A0-BF5B-1658F2181851' end )
where stg.StudentID is null and stg.RelationshipID is null and stg.DeletedDate is null and stg.RelationshipID is null


select asg.*,p.*
FROM 
x_ADHOCIMPORT.StudentGuardians asg JOIN
Legacysped.Transform_Student lst ON asg.StudentID = lst.StudentRefID join 
Student st on st.ID  = lst.DestID  join 
x_ADHOCIMPORT.Guardian ag ON ag.ID = asg.GuardianID join 
x_ADHOCIMPORT.Map_Person m on m.guardianID  = ag.ID join
Person p on m.destid = p.ID
Where p.TypeID = 'P' 

select * from student where id = '649FEE8E-349D-4835-BD4A-8A7B69EC29C6'
select * from LEGACYSPED.Transform_Student

select * from studentguardian where studentid = '31EE59D4-1DD7-409F-BCF9-FE8F35137D03'

select * from Enrich.Transform_Student
select * from vc3etl.loadtable where desttable = 'student'
select * from ENRICH.MAP_StudentID where ID in (select studentid from x_ADHOCIMPORT.studentguardians)

select * from ENRICH.MAP_StudentID where DestID in (select id from student)
*/