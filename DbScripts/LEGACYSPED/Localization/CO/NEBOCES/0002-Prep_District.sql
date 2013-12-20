
-- Colorado
-- Eagle						copied from Boulder

if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'MAP_AdminUnitID')
drop table LEGACYSPED.MAP_AdminUnitID
go

create table LEGACYSPED.MAP_AdminUnitID (
DestID uniqueidentifier not null
)

-- select * from OrgUnit where ParentID is null
--this line may be different for every district!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
insert LEGACYSPED.MAP_AdminUnitID values ('6531EF88-352D-4620-AF5D-CE34C54A9F53') -- INSERT ONLY ONE RECORD INTO THIS TABLE!!!!!!!!!!!!!!!!!!!!!!
-- INSERT ONLY ONE RECORD INTO THIS TABLE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
go


-- to consider:  in case these get deleted, have code that will insert them if they are not here.  Not necessary at this point.
declare @OrgUnit table (ID uniqueidentifier, Name varchar(200), Number varchar(10))
insert @OrgUnit values ('6531EF88-352D-4620-AF5D-CE34C54A9F53', 'Northeast Colorado BOCES','1040')
insert @OrgUnit values ('DF3840AE-3BFF-407B-83EF-D2EAA0383530', 'Akron','3030')
insert @OrgUnit values ('E16721FA-A8BA-4EBA-A112-E8E64792F679', 'Buffalo','1860')
insert @OrgUnit values ('75A9F0C0-4FEA-46FA-AFEA-B186F5659CF2', 'Frenchman','1850')
insert @OrgUnit values ('BF0E2254-E779-4174-B19D-05F5A14417CB', 'Julesburg RE-1','2862')
insert @OrgUnit values ('CA0FC405-ACB1-4046-9C3B-1384F42E3FCA', 'Lone Star','3060')
insert @OrgUnit values ('4FB466A5-6780-40B0-BDE9-7B99846C5AB2', 'Wray','3210')
insert @OrgUnit values ('63A3333C-4CDB-49A0-A384-60EB41A2C909', 'Yuma','3200')
insert @OrgUnit values ('3DBB595B-C2FD-43F7-882E-9789605D0CB4', 'HAXTUN RE-2J', '2630')
insert @OrgUnit values ('8D4E138F-9EB0-40F1-BEA4-F7CF0688C244', 'HOLYOKE RE-1J', '2620')
insert @OrgUnit values ('AD5C9695-F9F1-4A0A-A18B-551750B9EC98', 'Insight of Colorado', '1000') -- was 2862??  That's julesburg
insert @OrgUnit values ('2D5C6812-658B-4460-A4B6-39BEE4D8AEE7', 'OTIS R-3', '3050')
insert @OrgUnit values ('D54B823B-8B92-4D75-BE68-9D1F40770471', 'PLATEAU SCHOOL DISTRICT RE-5', '1870')
insert @OrgUnit values ('0EA898FA-3AD5-45A0-AF94-E2DC4743D84A', 'PLATTE VALLEY RE-3', '2865')
-- insert @OrgUnit values ('402E5AB4-1AD3-4C5D-9D0E-4E1AB2B1A074', 'STERLING RE-1 VALLEY', 'ST R')
-- insert @OrgUnit values ('CA0FC405-ACB1-4046-9C3B-1384F42E3FCA', 'LONE STAR 101', '3060')


--HOLYOKE RE-1J
--HAXTUN RE-2J
--PLATTE VALLEY RE-3
----OTIS R-3
--insert @OrgUnit values ('3DBB595B-C2FD-43F7-882E-9789605D0CB4', 'HAXTUN RE-2J', '2630')
--insert @OrgUnit values ('8D4E138F-9EB0-40F1-BEA4-F7CF0688C244', 'HOLYOKE RE-1J', '2620')
--insert @OrgUnit values ('2D5C6812-658B-4460-A4B6-39BEE4D8AEE7', 'OTIS R-3', '3050')
--insert @OrgUnit values ('0EA898FA-3AD5-45A0-AF94-E2DC4743D84A', 'PLATTE VALLEY RE-3', '2865')


select newID(), t.Name, t.Number, '420A9663-FFE8-4FF1-B405-1DB1D42B6F8A'
from @OrgUnit t 
left join OrgUnit ou on t.Number = ou.Number
where ou.ID is null



-- insert @OrgUnit values ('', 'AKRON R-1', '3030')
-- insert @OrgUnit values ('', 'BUFFALO RE-4', '1860')
-- insert @OrgUnit values ('', 'FRENCHMAN RE-3', '1850')
-- insert @OrgUnit values ('', 'JULESBURG RE-1', '2862')
-- insert @OrgUnit values ('', 'WRAY RD-2', '3210')
-- insert @OrgUnit values ('', 'YUMA', '3200')

-- not yet imported
-- insert @OrgUnit values ('', 'HAXTUN RE-2J', '2630')
-- insert @OrgUnit values ('', 'HOLYOKE RE-1J', '2620')
-- insert @OrgUnit values ('', 'Insight of Colorado', '2862')
-- insert @OrgUnit values ('', 'LONE STAR 101', '3060')
-- insert @OrgUnit values ('', 'OTIS R-3', '3050')
-- insert @OrgUnit values ('', 'PLATEAU SCHOOL DISTRICT RE-5', '1870')
-- insert @OrgUnit values ('', 'PLATTE VALLEY RE-3', '2865')
-- insert @OrgUnit values ('', 'STERLING RE-1 VALLEY', 'ST R')


update ou set Number = t.Number
-- select * 
from @OrgUnit t join
OrgUnit ou on t.ID = ou.ID 

insert OrgUnit (ID, Name, Number, TypeID)
select newID(), t.Name, t.Number, '420A9663-FFE8-4FF1-B405-1DB1D42B6F8A'
from @OrgUnit t 
left join OrgUnit ou on t.Number = ou.Number
where ou.ID is null

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.ImportPrgSections') AND type in (N'U'))
DROP TABLE LEGACYSPED.ImportPrgSections
GO
CREATE TABLE LEGACYSPED.ImportPrgSections (
Enabled bit not null,
SectionDefName varchar(100) not null,
SectionDefID uniqueidentifier not null
)
GO

ALTER TABLE LEGACYSPED.ImportPrgSections
	ADD CONSTRAINT PK_ImportPrgSections PRIMARY KEY CLUSTERED
(
	SectionDefID
)
GO


if not exists (select 1 from PrgSectionDef where ID = 'F60392DA-8EB3-49D0-822D-77A1618C1DAA')
insert PrgSectionDef (ID, TypeID, ItemDefID, Sequence, IsVersioned, DisplayPrevious, CanCopy, HeaderFormTemplateID) values ('F60392DA-8EB3-49D0-822D-77A1618C1DAA', '9B10DCDE-15CC-4AA3-808A-DFD51CE91079', '8011D6A2-1014-454B-B83C-161CE678E3D3', 6, 0, 0, 0, 'B97E7849-36B4-4181-8D03-241FDCA5105C')
set nocount on;
declare @importPrgSections table (Enabled bit not null, SectionDefName varchar(100) not null, SectionDefID uniqueidentifier not null)
-- update the Enabled column below to 0 if the section is not required for this district
insert @importPrgSections values (1, 'IEP Services', '9AC79680-7989-4CC9-8116-1CCDB1D0AE5F') -- boulder has opted not to import converted data services
insert @importPrgSections values (1, 'IEP LRE', '0CBA436F-8043-4D22-8F3D-289E057F1AAB')
insert @importPrgSections values (1, 'IEP Dates', 'EE479921-3ECB-409A-96D7-61C8E7BA0E7B')
insert @importPrgSections values (1, 'IEP Demographics', '427AF47C-A2D2-47F0-8057-7040725E3D89')
insert @importPrgSections values (1, 'Sped Eligibility Determination', 'F050EF5E-3ED8-43D5-8FE7-B122502DE86A')
insert @importPrgSections values (1, 'IEP Goals', '84E5A67D-CC9A-4D5B-A7B8-C04E8C3B8E0A')
insert @importPrgSections values (1, 'Sped Consent Services', 'D83A4710-A69F-4310-91F8-CB5BFFB1FE4C')
insert @importPrgSections values (1, 'Sped Consent Evaluation', '0FEB4F39-9450-43A4-BF09-A98C4D296916') -- BOULDER DID NOT PROVIDE THIS DATE!
insert @importPrgSections values (1, 'IEP ESY', 'F60392DA-8EB3-49D0-822D-77A1618C1DAA')

insert LEGACYSPED.ImportPrgSections
select * from @importPrgSections where SectionDefID not in (select SectionDefID from LEGACYSPED.ImportPrgSections)
go
---- #############################################################################
----		SUB Goal Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepSubGoalAreaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepSubGoalAreaDefID 
(
	SubGoalAreaCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL,
	ParentID uniqueidentifier not null
)
ALTER TABLE LEGACYSPED.MAP_IepSubGoalAreaDefID ADD CONSTRAINT
PK_MAP_IepSubGoalAreaDefID PRIMARY KEY CLUSTERED
(
	SubGoalAreaCode
)
END
go








/*

select enabled, DestTable, * 
from VC3ETL.LoadTable t
where ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6'
and Sequence < 100
order by Sequence

*/



-- Map_ServiceFrequencyID is created in the Transform script.


/*
	ServiceFrequency is part of seed data in Enrich.  Thus it must be hard-mapped.  
	ServiceFrequency did not support hiding from UI at the time this code was written, so additional service frequencies are not supported.
		For additional frequencies it may be possible to calculate the frequency based on an existing value 
			i.e. 2 times Quarterly = 8 times yearly,  30 minutes per quarter = 2 hours per year or 120 minutes per year
*/

--		Service Frequency
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_ServiceFrequencyID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_ServiceFrequencyID
(
	ServiceFrequencyCode	varchar(150) NOT NULL,
	ServiceFrequencyName	varchar(50) not null,
	DestID uniqueidentifier NOT NULL
)
ALTER TABLE LEGACYSPED.MAP_ServiceFrequencyID ADD CONSTRAINT
PK_MAP_ServiceFrequencyID PRIMARY KEY CLUSTERED
(
	ServiceFrequencyName
)
CREATE INDEX IX_Map_ServiceFrequencyID_ServiceFrequencyName on LEGACYSPED.Map_ServiceFrequencyID (ServiceFrequencyName)
END
GO

declare @map_servicefrequencyid table (servicefrequencycode varchar(30), servicefrequencyname varchar(50), destid uniqueidentifier)
set nocount on;
--insert @map_servicefrequencyid values ('01', 'daily', '71590a00-2c40-40ff-abd9-e73b09af46a1')
--insert @map_servicefrequencyid values ('02', 'weekly', 'a2080478-1a03-4928-905b-ed25dec259e6')
--insert @map_servicefrequencyid values ('03', 'monthly', '3d4b557b-0c2e-4a41-9410-ba331f1d20dd')
--insert @map_servicefrequencyid values ('', 'yearly', '5f3a2822-56f3-49da-9592-f604b0f202c3')
--insert @map_servicefrequencyid values('an', 'as needed', '69439d9d-b6c1-4b7a-9cac-c69810adfd31')
--insert @map_servicefrequencyid values('esy', 'as needed for esy', '836d1e97-ce4d-4fd5-9d0a-148924ac007b')
--insert @map_servicefrequencyid values ('zzz', 'not specified', 'c42c50ed-863b-44b8-bf68-b377c8b0fa95')

if (select count(*) from @map_servicefrequencyid t join legacysped.map_servicefrequencyid m on t.destid = m.destid) <> 5 ------ what is the purpose of this?
	delete legacysped.map_servicefrequencyid

set nocount off;
insert legacysped.map_servicefrequencyid
select m.servicefrequencycode, m.servicefrequencyname, m.destid
from @map_servicefrequencyid m left join
	legacysped.map_servicefrequencyid t on m.destid = t.destid
where t.destid is null

-- this is seed data, but maybe this is not the best place for this code.....
insert servicefrequency (id, name, sequence, weekfactor)
select destid, m.servicefrequencyname, 99, 0
from legacysped.map_servicefrequencyid m left join
	servicefrequency t on m.destid = t.id
where t.id is null
go





-- custom setup
declare @customsetup table (
LoadTable	varchar(100),
Enabled	bit
)

insert @customsetup values ('Person', 0)
insert @customsetup values ('UserProfile', 0)
insert @customsetup values ('UserProfileOrgUnit', 0)
insert @customsetup values ('UserProfileSchool', 0)
insert @customsetup values ('FormInstance', 0)
insert @customsetup values ('PrgItemForm', 0)
insert @customsetup values ('FormInstanceInterval', 0)
insert @customsetup values ('FormInputValue', 0)
insert @customsetup values ('FormInputTextValue', 0)

if (select count(*) from LEGACYSPED.MAP_ServiceFrequencyID) = 0
insert @customsetup values ('ServiceFrequency', 0)


-- select t.*
update t set Enabled = c.Enabled
from @customsetup c
join VC3ETL.LoadTable t on c.LoadTable = t.DestTable and t.ExtractDatabase = '29D14961-928D-4BEE-9025-238496D144C6'





if not exists (select * from PrgItemOutcome where Text = 'IEP Ended' and CurrentDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3')
begin
	insert PrgItemOutcome (ID, CurrentDefID, Text, Sequence) values (newid(), '8011D6A2-1014-454B-B83C-161CE678E3D3', 'IEP Ended', 0)
end
declare @PrgItemOutcomeID uniqueidentifier
select @PrgItemOutcomeID = ID from PrgItemOutcome where Text = 'IEP Ended' and CurrentDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'

if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'PrgItemOutcome_EndIEP')
drop table LEGACYSPED.PrgItemOutcome_EndIEP

create table LEGACYSPED.PrgItemOutcome_EndIEP (
PrgItemOutcomeID uniqueidentifier not null
)

insert LEGACYSPED.PrgItemOutcome_EndIEP values (@PrgItemOutcomeID)
go

if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'SpedConversionWrapUp')
drop procedure LEGACYSPED.SpedConversionWrapUp
go

create procedure LEGACYSPED.SpedConversionWrapUp
as
-- this should run for all districts in all states
update d set IsReevaluationNeeded = 1, StartDate = dateadd(dd, -d.MaxDaysToComplete, dateadd(yy, -d.MaxYearsToComplete, getdate())) from PrgMilestoneDef d where d.ID in ('27C002AF-ED92-4152-8B8C-7CA1ADEA2C81', 'AC043E4C-55EC-4F10-BCED-7E9201D7D0E2')

GO

