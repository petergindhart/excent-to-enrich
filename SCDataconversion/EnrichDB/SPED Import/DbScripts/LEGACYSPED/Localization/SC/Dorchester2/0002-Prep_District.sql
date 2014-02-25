
-- SC
-- Dorchester2						copied from Boulder

if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'MAP_AdminUnitID')
drop table LEGACYSPED.MAP_AdminUnitID
go

create table LEGACYSPED.MAP_AdminUnitID (
DestID uniqueidentifier not null
)

-- select * from OrgUnit where ParentID is null
--this line may be different for every district!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
insert LEGACYSPED.MAP_AdminUnitID values ('476E7334-FE5A-4E14-BAEC-4409CFE148AE') -- INSERT ONLY ONE RECORD INTO THIS TABLE!!!!!!!!!!!!!!!!!!!!!!
-- INSERT ONLY ONE RECORD INTO THIS TABLE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
go


-- to consider:  in case these get deleted, have code that will insert them if they are not here.  Not necessary at this point.
declare @OrgUnit table (ID uniqueidentifier, Name varchar(200), Number varchar(10))
 insert @OrgUnit values ('476E7334-FE5A-4E14-BAEC-4409CFE148AE', 'Dorchester School District 2','1802')


select newID(), t.Name, t.Number, '420A9663-FFE8-4FF1-B405-1DB1D42B6F8A'
from @OrgUnit t 
left join OrgUnit ou on t.Number = ou.Number
where ou.ID is null

update ou set Number = t.Number
-- select * 
from @OrgUnit t join
OrgUnit ou on t.ID = ou.ID 

--insert OrgUnit (ID, Name, Number, TypeID)
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
insert PrgSectionDef (ID, TypeID, ItemDefID, Sequence, IsVersioned, DisplayPrevious, CanCopy, HeaderFormTemplateID) values ('F60392DA-8EB3-49D0-822D-77A1618C1DAA', '9B10DCDE-15CC-4AA3-808A-DFD51CE91079', '1984F017-51CB-4E3C-9B3A-338A9D409EC6', 6, 0, 0, 0, NULL)
set nocount on;

declare @importPrgSections table (Enabled bit not null, SectionDefName varchar(100) not null, SectionDefID uniqueidentifier not null)
-- update the Enabled column below to 0 if the section is not required for this district
insert @importPrgSections values (1, 'IEP Services', 'F8261D6C-2528-4461-8E28-E70C40C417B2') -- boulder has opted not to import converted data services
insert @importPrgSections values (1, 'IEP LRE', '3727E5F0-762F-44D8-B303-068B99A90475')
insert @importPrgSections values (1, 'IEP Dates', 'D32860C0-9F4A-44B8-9925-A2E34241B5A0')
insert @importPrgSections values (1, 'IEP Demographics', '3BD3B039-2805-4983-948A-F3BFA86A72C9')
insert @importPrgSections values (1, 'Sped Eligibility Determination', 'DC3BE88C-7BA4-4041-A8FB-BCC96D2D4C29')
insert @importPrgSections values (1, 'IEP Goals', 'A9DF977C-088E-47E8-9CEF-550D8A42AF58')
insert @importPrgSections values (1, 'Sped Consent Services', '91D56FAB-554E-4F5C-9E84-55A85DAD30F0')
--insert @importPrgSections values (1, 'Sped Consent Evaluation', '31A1AE20-5F63-47FD-852A-4801595033ED') -- BOULDER DID NOT PROVIDE THIS DATE!
insert @importPrgSections values (1, 'IEP ESY', 'F60392DA-8EB3-49D0-822D-77A1618C1DAA' )

insert LEGACYSPED.ImportPrgSections
select * from @importPrgSections where SectionDefID not in (select SectionDefID from LEGACYSPED.ImportPrgSections)
go


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
join VC3ETL.LoadTable t on c.LoadTable = t.DestTable and t.ExtractDatabase = 'E664C745-7397-4F7E-80FE-5D19B7B56EEE'





if not exists (select * from PrgItemOutcome where Text = 'IEP Ended' and CurrentDefID = '1984F017-51CB-4E3C-9B3A-338A9D409EC6')
begin
	insert PrgItemOutcome (ID, CurrentDefID, Text, Sequence) values (newid(), '1984F017-51CB-4E3C-9B3A-338A9D409EC6', 'IEP Ended', 0)
end
declare @PrgItemOutcomeID uniqueidentifier
select @PrgItemOutcomeID = ID from PrgItemOutcome where Text = 'IEP Ended' and CurrentDefID = '1984F017-51CB-4E3C-9B3A-338A9D409EC6'

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

