


--CREATE SCHEMA x_ADHOC
--GO

-- drop table x_ADHOC.Guardian

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_ADHOC.Guardian') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_ADHOC.Guardian
	(
	ID varchar(150) NOT NULL,
	FirstName varchar(50) NOT NULL,
	LastName varchar(50) NOT NULL,
	EmailAddress varchar(75) NULL,
	Street varchar(100) NULL,
	City varchar(50) NULL,
	State char(2) NULL,
	ZipCode varchar(10) NULL,
	HomePhoneNumber varchar(40) NULL,
	WorkPhoneNumber varchar(40) NULL,
	CellPhoneNumber varchar(40) NULL
	)
	END
	
--DROP TABLE x_ADHOC.Guardian
	
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_ADHOC.StudentGuardians') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE
	x_ADHOC.StudentGuardians(
	ID varchar(150) NOT NULL,
	StudentID varchar(150) NOT NULL,
	GuardianID varchar(150) NOT NULL,
	RelationshipID varchar(150) NOT NULL
	)
END

--DROP TABLE x_ADHOC.StudentGuardians
begin tran test

--drop table #Guardian

CREATE TABLE #Guardian (
ID varchar(150) NOT NULL,
FirstName varchar(50) NOT NULL,
LastName varchar(50) NOT NULL,
EmailAddress varchar(75) NULL,
Street varchar(100) NULL,
City varchar(50) NULL,
State char(2) NULL,
ZipCode varchar(10) NULL,
HomePhoneNumber varchar(40) NULL,
WorkPhoneNumber varchar(40) NULL,
CellPhoneNumber varchar(40) NULL
)
	
CREATE TABLE #StudentGuardians (
ID varchar(150) NOT NULL,
StudentID varchar(150) NOT NULL,
GuardianID varchar(150) NOT NULL,
RelationshipID varchar(150) NOT NULL
)


truncate table #Guardian
--INSERT Guardian file
BULK INSERT #Guardian
FROM 'E:\EnrichDataFiles\CO\NEBOCES\Guardian.csv'
WITH ( FIELDTERMINATOR ='|',ROWTERMINATOR ='\n', FIRSTROW = 2)

truncate table #StudentGuardians
--INSERET StudentGuardianFile
BULK INSERT #StudentGuardians
FROM 'E:\EnrichDataFiles\CO\NEBOCES\StudentGuardian.csv'
WITH ( FIELDTERMINATOR ='|',ROWTERMINATOR ='\n', FIRSTROW = 2)

-- select * from x_ADHOC.StudentGuardians
-- select * from LEGACYSPED.Transform_Student where StudentRefID = 'AE2FA207-6278-4369-9F29-5C22421D1A86'


truncate table x_ADHOC.StudentGuardians
Insert x_ADHOC.StudentGuardians
Select * from  #StudentGuardians s
Where NOT EXISTS (select * from x_ADHOC.StudentGuardians d where d.ID = s.ID) 
and exists (select 1 from LEGACYSPED.MAP_StudentRefIDAll sm where s.StudentID = sm.StudentRefID) -- 695

truncate table x_ADHOC.Guardian
Insert x_ADHOC.Guardian
Select s.* from  #Guardian s join x_ADHOC.StudentGuardians sg on s.ID = sg.ID
Where NOT EXISTS (select * from x_ADHOC.Guardian d where d.ID = s.ID) -- 571


--INSERT PERSON
--BEGIN TRAN Test
-- drop table x_ADHOC.MAP_GuardianPersonID 
create table x_ADHOC.MAP_GuardianPersonID (
GuardianID	varchar(150)	not null,
DestID		uniqueidentifier not null)

alter table x_ADHOC.MAP_GuardianPersonID add constraint PK_x_ADHOC_MAP_GuardianID primary key (GuardianID)

insert x_ADHOC.MAP_GuardianPersonID (GuardianID, DestID)
select ID, newID() from x_ADHOC.Guardian g left join x_ADHOC.MAP_GuardianPersonID m on g.ID = m.GuardianID where m.DestID is null


-- note :  we are going to import these people whether or not there exists in the database osomeone with the same name.  These can be merged later.  For now we need the association with students.
-- this is an unfortunate circumstance caused by the way data was stored in the legacy application.


INSERT Person (ID, TypeID, FirstName, LastName, EmailAddress, Street, City, Zip, State, HomePhone, WorkPhone, CellPhone, ManuallyEntered)
SELECT 
	m.DestID,
	TypeID = 'P',
	NULL,
	g.FirstName,
	g.LastName,
	g.EmailAddress,
	left(g.Street, 50),
	g.City,
	g.ZipCode,
	g.State,
	g.HomePhoneNumber,
	g.WorkPhoneNumber,
	g.CellPhoneNumber,
	0
FROM x_ADHOC.MAP_GuardianPersonID m 
join x_ADHOC.Guardian g on m.GuardianID = g.ID
left join dbo.Person p on m.DestID = p.ID
where p.id is null

insert StudentGuardianRelationship (ID, Name, Description)
select newID(), RelationshipID, RelationshipID from (select distinct g.RelationshipID from x_ADHOC.StudentGuardians g where g.RelationshipID not in (select distinct Name from StudentGuardianRelationship) and g.RelationshipID <> ''  ) g

create table x_ADHOC.MAP_StudentGuardianRelationshipID (
LegacyRelationshipID	varchar(150) not null,
DestID	uniqueidentifier not null
)

alter table x_ADHOC.MAP_StudentGuardianRelationshipID add constraint PK_x_ADHOC_MAP_StudentGuardianRelationshipID_LegacyRelationshipID primary key (LegacyRelationshipID)

-- Specific to NE BOCES
if not exists (select 1 from x_ADHOC.MAP_StudentGuardianRelationshipID where LegacyRelationshipID = 'Mother')
insert x_ADHOC.MAP_StudentGuardianRelationshipID values ('Mother', 'C613714B-D56F-48EB-8ED5-6624CC665FE9')
if not exists (select 1 from x_ADHOC.MAP_StudentGuardianRelationshipID where LegacyRelationshipID = 'Father')
insert x_ADHOC.MAP_StudentGuardianRelationshipID values ('Father', '5995C589-10E7-47FD-85A2-C61A2670B7B8')
if not exists (select 1 from x_ADHOC.MAP_StudentGuardianRelationshipID where LegacyRelationshipID = 'Parent')
insert x_ADHOC.MAP_StudentGuardianRelationshipID values ('Parent', '1BAE9149-0529-41A0-BF5B-1658F2181851')

insert x_ADHOC.MAP_StudentGuardianRelationshipID 
select RelationshipID, newid()
from (select distinct x.RelationshipID from x_ADHOC.StudentGuardians x where x.RelationshipID <> '') sg
left join x_ADHOC.MAP_StudentGuardianRelationshipID m on sg.RelationshipID = m.LegacyRelationshipID 
where m.LegacyRelationshipID is null

insert StudentGuardianRelationship (ID, Name, Description)
select m.DestID, m.LegacyRelationshipID, m.LegacyRelationshipID 
from x_ADHOC.MAP_StudentGuardianRelationshipID m
left join StudentGuardianRelationship r on m.DestID = r.ID
where r.id is null


-- new strategy for importing to Person:  Since there is no unique key to match Legacy with Enrich data, import only where there is no match.  Do not import and do not match with current data.  Use MAP table.


insert StudentGuardian (ID, StudentID, PersonID, RelationshipID, Sequence)
select ID = newid(), StudentID = s.DestID, PersonID = mg.DestID, RelationshipID = r.DestID, Sequence = 0
from x_ADHOC.MAP_GuardianPersonID mg 
join x_ADHOC.StudentGuardians sg on mg.GuardianID = sg.GuardianID
join LEGACYSPED.Transform_Student s on sg.StudentID = s.StudentRefID -- DestID = StudentID -- 571
join x_ADHOC.MAP_StudentGuardianRelationshipID r on sg.RelationshipID = r.LegacyRelationshipID -- 548
left join StudentGuardian x on 
	x.StudentID = s.DestID and 
	x.PersonID = mg.DestID 
where x.id is null


--INSERT STUDENTGUARDIAN
INSERT StudentGuardian (ID,StudentID,PersonID,RelationshipID,Sequence,DeletedDate)

SELECT 
	NEWID(),
	StudentID= lst.DestID,
	PersonID = p.ID,
	-- RelationshipID = case when asg.RelationshipID = 'P' then 'B16DBEC8-525F-423D-888B-3F4672E9E977' else '805A762F-2ED3-46C2-B1BB-2A511E4783A0' end ,
	RelationshipID = '',
	Sequence = 0,
	DeletedDate = NULL
FROM 
x_ADHOC.StudentGuardians asg JOIN
#StudentGuardians s ON asg.ID = s.ID join 
Legacysped.Transform_Student lst ON asg.StudentID = lst.StudentRefID join 
x_ADHOC.Guardian ag ON ag.ID = asg.GuardianID join 
Person p ON ag.FirstName = p.FirstName and ag.LastName = p.LastName and p.TypeID = 'P'

--Student address populate

UPDATE st
SET City = ag.City,
	Street = ag.Street,
	State = ag.State,
	ZipCode = ag.ZipCode,
	PhoneNumber  = ag.HomePhoneNumber
--select asg.*,ag.*
FROM 
x_ADHOC.StudentGuardians asg JOIN
#StudentGuardians tsg on asg.ID = tsg.ID join 
Legacysped.Transform_Student lst ON asg.StudentID = lst.StudentRefID join 
Student st on st.ID  = lst.DestID  join 
x_ADHOC.Guardian ag ON ag.ID = asg.GuardianID join 
#Guardian tg ON  ag.ID = tg.ID join 
(select * from Person Where TypeID = 'P') p ON ag.FirstName = p.FirstName and ag.LastName = p.LastName
Where asg.RelationshipID = 'P' 
--rollback tran test


DROP TABLE #StudentGuardians
GO
DROP TABLE #Guardian
GO


rollback tran test

-- commit tran test

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
left join x_ADHOC.Guardian g on g.FirstName =p.FirstName and g.LastName = p.LastName
where g.City = 'Challis')
commit tran
*/

x_datateam.findguid 'B16DBEC8-525F-423D-888B-3F4672E9E977' -- 0


x_datateam.findguid '805A762F-2ED3-46C2-B1BB-2A511E4783A0' -- 0


x_datateam.findguid '0E98D780-72A1-4A0A-A670-8C4DD4C7762E'

select * from ENRICH.MAP_StudentGuardianRelationshipID where DestID = '0E98D780-72A1-4A0A-A670-8C4DD4C7762E'
select * from ENRICH.MAP_StudentGuardianRelationshipID where ID = '0E98D780-72A1-4A0A-A670-8C4DD4C7762E'
select * from ENRICH.StudentGuardian_LOCAL where RelationshipID = '0E98D780-72A1-4A0A-A670-8C4DD4C7762E'
select * from ENRICH.StudentGuardianRelationship_LOCAL where ID = '0E98D780-72A1-4A0A-A670-8C4DD4C7762E'

select * from dbo.StudentGuardian where RelationshipID = '0E98D780-72A1-4A0A-A670-8C4DD4C7762E'
select * from dbo.StudentGuardianRelationship where ID = '0E98D780-72A1-4A0A-A670-8C4DD4C7762E'


select * from Student where ManuallyEntered = 1

select ID, Name, Description from dbo.StudentGuardianRelationship 








select * 
from StudentGuardian

select * 
from GradeLevel 

select * from LEGACYSPED.SelectLists where Type = 'Grade' order by LegacySpedCode






select District = case ou.name when 'WRAY RD-2' then 'Wray' else ou.Name end, s.Number, s.Name, s.ID, s.Abbreviation
from school s
join OrgUnit ou on s.OrgUnitID = ou.ID
order by s.number, ou.Name














