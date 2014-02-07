--#include ..\..\..\Objects\Transform_ServiceFrequency.sql

-- South Caralonia
-- ChesterField
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
insert @OrgUnit values ('6531EF88-352D-4620-AF5D-CE34C54A9F53', 'Chesterfield County School District', '1301')

update ou set Number = t.Number
-- select * 
from @OrgUnit t join
OrgUnit ou on t.ID = ou.ID 


if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'MAP_PrgStatus_ConvertedDataPlan')
drop table LEGACYSPED.MAP_PrgStatus_ConvertedDataPlan
go

create table LEGACYSPED.MAP_PrgStatus_ConvertedDataPlan (DestID uniqueidentifier not null)
insert LEGACYSPED.MAP_PrgStatus_ConvertedDataPlan values ('0B5D5C72-5058-4BF5-A414-BDB27BD5DD94')
go



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
insert @importPrgSections values (1, 'IEP Services', 'F8261D6C-2528-4461-8E28-E70C40C417B2')
insert @importPrgSections values (1, 'IEP LRE', '3727E5F0-762F-44D8-B303-068B99A90475')
insert @importPrgSections values (1, 'IEP Dates', 'D32860C0-9F4A-44B8-9925-A2E34241B5A0')
insert @importPrgSections values (1, 'IEP Demographics', '3BD3B039-2805-4983-948A-F3BFA86A72C9')
insert @importPrgSections values (1, 'Sped Eligibility Determination', 'DC3BE88C-7BA4-4041-A8FB-BCC96D2D4C29')
insert @importPrgSections values (1, 'IEP Goals', 'A9DF977C-088E-47E8-9CEF-550D8A42AF58')
insert @importPrgSections values (1, 'Sped Consent Services', '91D56FAB-554E-4F5C-9E84-55A85DAD30F0')
insert @importPrgSections values (1, 'IEP ESY', 'F60392DA-8EB3-49D0-822D-77A1618C1DAA')

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
