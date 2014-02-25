--#include ..\..\..\Objects\Transform_ServiceFrequency.sql

-- Colorado
-- San Luis Valley

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
insert @OrgUnit values ('6531EF88-352D-4620-AF5D-CE34C54A9F53', 'Uncompahgre BOCES',NULL)
insert @OrgUnit values ('28527E3C-5804-4CB9-8935-13B5ADB13358', 'Ridgeway', '2590')
insert @OrgUnit values ('EB2CCF7D-56E0-4375-9891-8B6E372FF788', 'Telluride', '2830')
insert @OrgUnit values ('33565FCA-5EF0-4BE1-8D4E-C5CAAC8ACD7B', 'West End', '2190')
insert @OrgUnit values ('ED63604F-4710-4C77-A545-D9E4A3485140', 'Norwood', '2840')
insert @OrgUnit values ('73B4BEE9-F046-4E06-9196-EBB612126DB1', 'Paradox Valley', '2730')
insert @OrgUnit values ('40A3948B-2946-4D9F-9312-F44E225E742A', 'Ouray', '2580')


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
