--#include ..\..\..\Objects\Transform_ServiceFrequency.sql

-- Colorado
-- Pikes Peak

-- note : data model for SystemSettings table has changed (v 19)
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
insert @OrgUnit values ('6531EF88-352D-4620-AF5D-CE34C54A9F53', 'PIKE PEAK BOCES', '9045')
insert @OrgUnit values ('0B4D6750-4D66-452F-93B0-1B587A109FF6', 'FLORENCE RE-2', '1150')
insert @OrgUnit values ('229045C7-3837-4787-B453-2C48C4DDF2FF', 'LEWIS-PALMER 38', '1080')
insert @OrgUnit values ('71D3C1A8-5052-4D34-A3E1-35ECA4D1DCF7', 'DOUGLAS COUNTY RE 1', '0900')
insert @OrgUnit values ('B209A10A-5627-4542-9B11-4CAF9CCA7F77', 'COLORADO SPRINGS 11', '1010')
insert @OrgUnit values ('BC133A20-B0FA-4335-8608-5E737B24C09A', 'SCHOOL OF EXCELLENCE', '0000')
insert @OrgUnit values ('6E431E0A-C329-46D2-9ACC-636ABD0A9DDF', 'FALCON 49', '1110')
insert @OrgUnit values ('18350A26-A146-429C-B79F-8BF7AD147344', 'HANOVER 28', '1070')
insert @OrgUnit values ('4DA5B992-A819-4772-AC1A-8C5299048AC6', 'ELIZABETH C-1', '0920')
insert @OrgUnit values ('D2076AE5-7EAB-46B1-931F-8F020F4A234F', 'PEYTON 23 JT', '1060')
insert @OrgUnit values ('E7CE420D-3B34-4930-8D47-945DBAF50A9D', 'CALHAN RJ-1', '0970')
insert @OrgUnit values ('437A3E39-F545-4756-8C39-95BD566A9C6A', 'ELLICOTT 22', '1050')
insert @OrgUnit values ('D0101DA2-7036-492F-8DD5-9F915CE0E82D', 'EDISON 54 JT', '1120')
insert @OrgUnit values ('C6B184E7-3E61-4ADA-8176-B8B4DB332098', 'ACADEMY 20', '1040')
insert @OrgUnit values ('A575CE8C-CA2F-4725-8077-BCE0906506B2', 'MIAMI YODER 60 JT', '1130')
insert @OrgUnit values ('6531EF88-352D-4620-AF5D-CE34C54A9F53', 'Pikes Peak BOCES', '9045')
insert @OrgUnit values ('E8238B2D-B4B7-431F-A979-DDEA7D1CDBCB', 'CANON CITY RE-1', '1140')
insert @OrgUnit values ('D2FA7E51-1BDB-4318-B85B-E8180F59296F', 'ELBERT 200', '0950')
insert @OrgUnit values ('08E31E43-A3CF-4F7D-BADF-F899702202B8', 'BIG SANDY 100J', '0940')

update ou set Number = t.Number
-- select * 
from @OrgUnit t join
OrgUnit ou on t.ID = ou.ID 


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.ImportPrgSections') AND type in (N'U'))
BEGIN
CREATE TABLE LEGACYSPED.ImportPrgSections (
Enabled bit not null,
SectionDefName varchar(100) not null,
SectionDefID uniqueidentifier not null
)

ALTER TABLE LEGACYSPED.ImportPrgSections
	ADD CONSTRAINT PK_ImportPrgSections PRIMARY KEY CLUSTERED
(
	SectionDefID
)
END
GO

set nocount on;
declare @importPrgSections table (Enabled bit not null, SectionDefName varchar(100) not null, SectionDefID uniqueidentifier not null)
-- update the Enabled column below to 0 if the section is not required for this district
insert @importPrgSections values (1, 'IEP Services', '9AC79680-7989-4CC9-8116-1CCDB1D0AE5F')
insert @importPrgSections values (1, 'IEP LRE', '0CBA436F-8043-4D22-8F3D-289E057F1AAB')
insert @importPrgSections values (1, 'IEP Dates', 'EE479921-3ECB-409A-96D7-61C8E7BA0E7B')
insert @importPrgSections values (1, 'IEP Demographics', '427AF47C-A2D2-47F0-8057-7040725E3D89')
insert @importPrgSections values (1, 'Sped Eligibility Determination', 'F050EF5E-3ED8-43D5-8FE7-B122502DE86A')
insert @importPrgSections values (1, 'IEP Goals', '84E5A67D-CC9A-4D5B-A7B8-C04E8C3B8E0A')
insert @importPrgSections values (1, 'Sped Consent Services', 'D83A4710-A69F-4310-91F8-CB5BFFB1FE4C')

insert LEGACYSPED.ImportPrgSections
select t.* 
from @importPrgSections t left join
LEGACYSPED.ImportPrgSections p on t.SectionDefID = p.SectionDefID
where p.SectionDefID is null
go



-- Map_ServiceFrequencyID is created in the Transform script.


/*
	ServiceFrequency is part of seed data in Enrich.  Thus it must be hard-mapped.  
	ServiceFrequency did not support hiding from UI at the time this code was written, so additional service frequencies are not supported.
		For additional frequencies it may be possible to calculate the frequency based on an existing value 
			i.e. 2 times Quarterly = 8 times yearly,  30 minutes per quarter = 2 hours per year or 120 minutes per year
*/

declare @map_servicefrequencyid table (servicefrequencycode varchar(30), servicefrequencyname varchar(50), destid uniqueidentifier)
set nocount on;
insert @map_servicefrequencyid values ('zzz', 'not specified', 'c42c50ed-863b-44b8-bf68-b377c8b0fa95')
insert @map_servicefrequencyid values ('03', 'monthly', '3d4b557b-0c2e-4a41-9410-ba331f1d20dd')
insert @map_servicefrequencyid values ('01', 'daily', '71590a00-2c40-40ff-abd9-e73b09af46a1')
insert @map_servicefrequencyid values ('02', 'weekly', 'a2080478-1a03-4928-905b-ed25dec259e6')
insert @map_servicefrequencyid values ('', 'yearly', '5f3a2822-56f3-49da-9592-f604b0f202c3')
insert @map_servicefrequencyid values('an', 'as needed', '69439d9d-b6c1-4b7a-9cac-c69810adfd31')
insert @map_servicefrequencyid values('esy', 'as needed for esy', '836d1e97-ce4d-4fd5-9d0a-148924ac007b')


-- select * from ServiceFrequency

if (select count(*) from @map_servicefrequencyid t join legacysped.map_servicefrequencyid m on t.destid = m.destid) <> 5
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
