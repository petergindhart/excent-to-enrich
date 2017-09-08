
-- Idaho
-- TwinFalls

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
--insert @OrgUnit values ('3D5F2D4D-FB5D-4742-9474-53C28F94A293', 'Private Schools under West Ada', 'PS')


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


if not exists (select 1 from PrgSectionDef where ID = 'F60392DA-8EB3-49D0-822D-77A1618C1DAA')
insert PrgSectionDef (ID, TypeID, ItemDefID, Sequence, IsVersioned, DisplayPrevious, CanCopy, HeaderFormTemplateID) values ('F60392DA-8EB3-49D0-822D-77A1618C1DAA', '9B10DCDE-15CC-4AA3-808A-DFD51CE91079', '13CB8C6A-FB83-4644-886C-79E8A5B40CBE', 6, 0, 0, 0, '29693CB4-F504-4E8D-9412-D2BACFBC5104')
set nocount on;
declare @importPrgSections table (Enabled bit not null, SectionDefName varchar(100) not null, SectionDefID uniqueidentifier not null)
-- update the Enabled column below to 0 if the section is not required for this district
insert @importPrgSections values (0, 'Item Services', '54228EE4-3A8C-4544-9216-D842BE7B0A3B') -- This was called IEP Services
insert @importPrgSections values (1, 'IEP LRE', 'D1C4004B-EF82-4E8F-BA12-D8F086EB9BBE')
insert @importPrgSections values (1, 'IEP Dates', '7E6F8640-DEB8-441F-BD3A-4B2E96EAA6B4')
insert @importPrgSections values (1, 'IEP Enrollment', 'F2A1374B-46D6-4E25-9733-D7F3256369ED')
insert @importPrgSections values (1, 'Sped Eligibility Determination', 'F65AEF7A-5EF8-46DD-B207-ADA61CD3A4CB')
insert @importPrgSections values (0, 'IEP Goals', '469601E0-B8E6-483A-9CE7-2A88DE0EAB78')
insert @importPrgSections values (1, 'Sped Consent Services', 'FAAC8057-2256-456A-A441-3391C2F1BEF7')
--insert @importPrgSections values (1, 'Sped Consent Evaluation', '0FEB4F39-9450-43A4-BF09-A98C4D296916') -- Does not exist in Twinfalls under Converted Data
insert @importPrgSections values (1, 'IEP ESY', '9B10DCDE-15CC-4AA3-808A-DFD51CE91079')
--Accommodations & Modifications we donot import in Data conversion

--select t.* 
--from @importPrgSections t 
--left join prgSectionDef sd on t.SectionDefID = sd.id 
--where sd.id is null

----Just checking to see what exist in Converted Data matching with above table variable
--select st.name, i.SectionDefName importPrgSections_name, st.ID, i.SectionDefID as importPrgSections_ID, st.CanVersion, sd.id, sd.isversioned, sd.sequence
--from PrgSectionDef sd
--join prgItemDef id on sd.ItemDefID = id.id
--join prgSectiontype st on st.id = sd.typeid
--left join @importPrgSections i on i.SectionDefName = st.name
--where id.id = '13CB8C6A-FB83-4644-886C-79E8A5B40CBE'
--order by sd.sequence

----Just checking to see what exist in Converted Data
--select st.name, st.CanVersion, sd.id, sd.isversioned, sd.sequence
--from PrgSectionDef sd
--join prgItemDef id on sd.ItemDefID = id.id
----join prgItem i on i.DefID = id.id
--join prgSectiontype st on st.id = sd.typeid
--where id.id = '13CB8C6A-FB83-4644-886C-79E8A5B40CBE'
--order by sd.sequence

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
insert @map_servicefrequencyid values ('01', 'daily', '71590a00-2c40-40ff-abd9-e73b09af46a1')
insert @map_servicefrequencyid values ('02', 'weekly', 'a2080478-1a03-4928-905b-ed25dec259e6')
insert @map_servicefrequencyid values ('03', 'monthly', '3d4b557b-0c2e-4a41-9410-ba331f1d20dd')
insert @map_servicefrequencyid values ('', 'yearly', '5f3a2822-56f3-49da-9592-f604b0f202c3')


-- select * from ServiceFrequency order by sequence

if (select count(*) from @map_servicefrequencyid t join legacysped.map_servicefrequencyid m on t.destid = m.destid) <> 4
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


if not exists (select * from PrgItemOutcome where Text = 'IEP Ended' and CurrentDefID = '13CB8C6A-FB83-4644-886C-79E8A5B40CBE') --use Converted Data ID here
begin
	insert PrgItemOutcome (ID, CurrentDefID, Text, Sequence) values (newid(), '13CB8C6A-FB83-4644-886C-79E8A5B40CBE', 'IEP Ended', 0)
end
declare @PrgItemOutcomeID uniqueidentifier
select @PrgItemOutcomeID = ID from PrgItemOutcome where Text = 'IEP Ended' and CurrentDefID = '13CB8C6A-FB83-4644-886C-79E8A5B40CBE'

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
update d set IsReevaluationNeeded = 1, StartDate = dateadd(dd, -d.MaxDaysToComplete, dateadd(yy, -d.MaxYearsToComplete, getdate())) 
from PrgMilestoneDef d where d.ID in ('27C002AF-ED92-4152-8B8C-7CA1ADEA2C81', 'AC043E4C-55EC-4F10-BCED-7E9201D7D0E2')
GO
