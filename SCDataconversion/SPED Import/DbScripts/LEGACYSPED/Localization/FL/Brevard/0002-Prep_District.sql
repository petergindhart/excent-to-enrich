-- Florida
-- Brevard 

-- OrgUnit 
/*
update ou set Number = '05' -- Brevard County State Reporting DistrictID
from (select top 1 OrgUnitID from School group by OrgUnitID order by count(*) desc) m join dbo.OrgUnit ou on m.OrgUnitID = ou.ID

*/




--declare @cs varchar(max) ; set @cs = ''
--select @cs = @cs+c.name+ case when c.column_id = (select max(column_id) from sys.columns where object_id = o.object_id) then '' else ', ' end
--from sys.objects o
--join sys.columns c on o.object_id = c.object_id 
--where o.name = 'IEP_Local'
--print @cs



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

update OrgUnit set Number = '05' where ID = '6531EF88-352D-4620-AF5D-CE34C54A9F53'
go


--------- specifically for Brevard, thousands of IEPs would be deleted without this 
update vc3etl.loadtable set Enabled = 0 where ID = '3EEBD21C-9A24-4634-B678-BF0211602446'
go

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
insert @importPrgSections values (0, 'IEP Services', '9AC79680-7989-4CC9-8116-1CCDB1D0AE5F')
insert @importPrgSections values (1, 'IEP LRE', '0CBA436F-8043-4D22-8F3D-289E057F1AAB')
insert @importPrgSections values (1, 'IEP Dates', 'EE479921-3ECB-409A-96D7-61C8E7BA0E7B')
insert @importPrgSections values (1, 'IEP Demographics', '427AF47C-A2D2-47F0-8057-7040725E3D89')
insert @importPrgSections values (1, 'Sped Eligibility Determination', 'F050EF5E-3ED8-43D5-8FE7-B122502DE86A')
insert @importPrgSections values (0, 'IEP Goals', '84E5A67D-CC9A-4D5B-A7B8-C04E8C3B8E0A')
insert @importPrgSections values (1, 'Sped Consent Services', 'D83A4710-A69F-4310-91F8-CB5BFFB1FE4C')
insert @importPrgSections values (1, 'Sped Consent Evaluation', '47958E63-10C4-4124-A5BA-8C1077FB2D40')
insert @importPrgSections values (1, 'IEP ESY', 'F60392DA-8EB3-49D0-822D-77A1618C1DAA')

insert LEGACYSPED.ImportPrgSections
select * from @importPrgSections
go


-- if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'PrgItemOutcome_EndIEP')
-- drop table LEGACYSPED.PrgItemOutcome_EndIEP
-- go

-- create table LEGACYSPED.PrgItemOutcome_EndIEP (
-- PrgItemOutcomeID uniqueidentifier not null
-- )

-- insert LEGACYSPED.PrgItemOutcome_EndIEP values ('0BA96EE2-EF98-4B5F-BBD4-BD407F12405F')
-- go

if not exists (select * from PrgSectionDef where ID = '47958E63-10C4-4124-A5BA-8C1077FB2D40')
insert PrgSectionDef (ID, TypeID, ItemDefID, Sequence, IsVersioned, DisplayPrevious, CanCopy) values ('47958E63-10C4-4124-A5BA-8C1077FB2D40', '31A1AE20-5F63-47FD-852A-4801595033ED', '8011D6A2-1014-454B-B83C-161CE678E3D3', 7, 0, 0, 0)

/*			 To find the appropriate PrgItemOutcome, see the following

select * from PrgItemOutcome where CurrentDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3' and Text like 'IEP%' and DeletedDate is null


Noted PrgItemOutcome IDs to date (20120330)

62CD92CE-E0C9-40EC-B648-EB92A7F78331 	Lee county School District, Florida
62CD92CE-E0C9-40EC-B648-EB92A7F78331	Collier
0BA96EE2-EF98-4B5F-BBD4-BD407F12405F	Brevard
0B54D171-8307-4352-94CB-C092D7CF8D23	Polk

-- 5ADC11E8-227D-4142-91BA-637E68FDBE70	all Colorado districts
B52A60EA-848D-4FFB-8CA1-27FD41765167	Aurora Public Schools -- but on APS Template it is B52A60EA-848D-4FFB-8CA1-27FD41765167
84AFA8B4-DB0A-4E3C-A62F-44A2513A471B	CO Template
84AFA8B4-DB0A-4E3C-A62F-44A2513A471B	Weld4
84AFA8B4-DB0A-4E3C-A62F-44A2513A471B	Weld6



select * from PrgItemOutcome where CurrentDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3' and Text like 'IEP%' and DeletedDate is null

select * from PrgItemOutcome where ID = '5ADC11E8-227D-4142-91BA-637E68FDBE70'
select * from PrgItemOutcome where ID = 'B52A60EA-848D-4FFB-8CA1-27FD41765167'




*/
-- ############################################################################# 
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


if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'SpedConversionWrapUp')
drop procedure LEGACYSPED.SpedConversionWrapUp
go

create procedure LEGACYSPED.SpedConversionWrapUp
as
-- this should run for all districts in all states
update d set IsReevaluationNeeded = 1, StartDate = dateadd(dd, -d.MaxDaysToComplete, dateadd(yy, -d.MaxYearsToComplete, getdate())) from PrgMilestoneDef d where d.ID in ('27C002AF-ED92-4152-8B8C-7CA1ADEA2C81', 'AC043E4C-55EC-4F10-BCED-7E9201D7D0E2')

exec dbo.Util_VerifyProgramDataAssumptions 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C'

GO




