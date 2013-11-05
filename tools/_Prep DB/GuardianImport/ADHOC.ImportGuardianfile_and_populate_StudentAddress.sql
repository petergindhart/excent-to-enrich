
--CREATE SCHEMA ADHOC
--GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'ADHOC.Guardian') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE ADHOC.Guardian
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
	
--DROP TABLE ADHOC.Guardian
	
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'ADHOC.StudentGuardians') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE
	ADHOC.StudentGuardians(
	[ID] [varchar](150) NOT NULL,
	[StudentID] [varchar](150) NOT NULL,
	[GuardianID] [varchar](150) NOT NULL,
	[RelationshipID] [varchar](150) NOT NULL
	)
END

--DROP TABLE ADHOC.StudentGuardians
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
FROM 'E:\McCallDonn\Profile\Guardians.csv'
WITH ( FIELDTERMINATOR ='|',ROWTERMINATOR ='\n', FIRSTROW = 2)

--INSERET StudentGuardianFile
BULK INSERT #StudentGuardians
FROM 'E:\McCallDonn\Profile\StudentGuardians.csv'
WITH ( FIELDTERMINATOR ='|',ROWTERMINATOR ='\n', FIRSTROW = 2)

--select FirstName,LastName,COUNT(*) from #Guardian group by FirstName,LastName having COUNT(*)>1

Insert ADHOC.Guardian
Select * from  #Guardian s
Where NOT EXISTS (select * from ADHOC.Guardian d where d.ID = s.ID)

Insert ADHOC.StudentGuardians
Select * from  #StudentGuardians s
Where NOT EXISTS (select * from ADHOC.StudentGuardians d where d.ID = s.ID) --47


--select* from Person where ManuallyEntered = 0 order by FirstName --66 --72

--INSERT PERSON
--BEGIN TRAN Test
INSERT Person (ID,TypeID,Deleted,FirstName,LastName,EmailAddress,Street,City,Zip,State,HomePhone,WorkPhone,CellPhone,ManuallyEntered,Agency,Title,ImportPausedDate,ImportPausedByID)
SELECT 
	NEWID(),
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
FROM #Guardian s join 
	ADHOC.Guardian g ON s.ID = g.ID
	order by g.FirstNAme

--select * from StudentGuardian  --66  --74

--INSERT STUDENTGUARDIAN
INSERT StudentGuardian (ID,StudentID,PersonID,RelationshipID,Sequence,DeletedDate)
SELECT 
NEWID(),
StudentID= lst.DestID,
PersonID = p.ID,
RelationshipID = case when asg.RelationshipID = 'P' then 'B16DBEC8-525F-423D-888B-3F4672E9E977' else '805A762F-2ED3-46C2-B1BB-2A511E4783A0' end ,
Sequence = 0,
DeletedDate = NULL
FROM 
ADHOC.StudentGuardians asg JOIN
#StudentGuardians s ON asg.ID = s.ID join 
Legacysped.Transform_Student lst ON asg.StudentID = lst.StudentRefID join 
ADHOC.Guardian ag ON ag.ID = asg.GuardianID join 
(select * from Person Where TypeID = 'P') p ON ag.FirstName = p.FirstName and ag.LastName = p.LastName

--Student address populate

UPDATE st
SET City = ag.City,
	Street = ag.Street,
	State = ag.State,
	ZipCode = ag.ZipCode,
	PhoneNumber  = ag.HomePhoneNumber
--select asg.*,ag.*
FROM 
ADHOC.StudentGuardians asg JOIN
#StudentGuardians tsg on asg.ID = tsg.ID join 
Legacysped.Transform_Student lst ON asg.StudentID = lst.StudentRefID join 
Student st on st.ID  = lst.DestID  join 
ADHOC.Guardian ag ON ag.ID = asg.GuardianID join 
#Guardian tg ON  ag.ID = tg.ID join 
(select * from Person Where TypeID = 'P') p ON ag.FirstName = p.FirstName and ag.LastName = p.LastName
Where asg.RelationshipID = 'P' 
--rollback tran test


DROP TABLE #StudentGuardians
GO
DROP TABLE #Guardian
GO

--rollback tran test
commit tran test

/*
begin tran
update st
set Street = (select Street from Person where stg.PersonID = ID),
	City =(select City from Person where stg.PersonID = ID),
	State = (select State from Person where stg.PersonID = ID),
	ZipCode = (select ZipCode from Person where stg.PersonID = ID),
	PhoneNumber = (select PhoneNumber from Person where stg.PersonID = ID)
--select st.ID 
from StudentGuardian stg
join Student st on st.ID =stg.StudentID
where PersonID in (select p.ID from Person p
left join ADHOC.Guardian g on g.FirstName =p.FirstName and g.LastName = p.LastName
where g.City = 'Challis')
commit tran
*/

dbcc opentran()