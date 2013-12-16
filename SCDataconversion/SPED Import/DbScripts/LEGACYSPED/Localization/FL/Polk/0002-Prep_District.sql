
-- Florida
-- Polk

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

update OrgUnit set Number = '53' where ID = '6531EF88-352D-4620-AF5D-CE34C54A9F53'
go


if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'MAP_PrgStatus_ConvertedDataPlan')
drop table LEGACYSPED.MAP_PrgStatus_ConvertedDataPlan
go

create table LEGACYSPED.MAP_PrgStatus_ConvertedDataPlan (DestID uniqueidentifier not null)
insert LEGACYSPED.MAP_PrgStatus_ConvertedDataPlan values ('0B5D5C72-5058-4BF5-A414-BDB27BD5DD94')
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

--select * from FormTemplate where name like '%ESY%'

-- use the FormTemplate for ESY Criteria for this district 
if not exists (select 1 from PrgSectionDef where ID = 'F60392DA-8EB3-49D0-822D-77A1618C1DAA')
insert PrgSectionDef (ID, TypeID, ItemDefID, Sequence, IsVersioned, DisplayPrevious, CanCopy, HeaderFormTemplateID) values ('F60392DA-8EB3-49D0-822D-77A1618C1DAA', '9B10DCDE-15CC-4AA3-808A-DFD51CE91079', '8011D6A2-1014-454B-B83C-161CE678E3D3', 6, 0, 0, 0, 'B97E7849-36B4-4181-8D03-241FDCA5105C')


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
insert @importPrgSections values (1, 'Sped Consent Evaluation', '47958E63-10C4-4124-A5BA-8C1077FB2D40')
insert @importPrgSections values (1, 'IEP ESY', 'F60392DA-8EB3-49D0-822D-77A1618C1DAA')

insert LEGACYSPED.ImportPrgSections
select * from @importPrgSections where SectionDefID not in (select SectionDefID from LEGACYSPED.ImportPrgSections)
go


---- #############################################################################
----		Goal Area MAP
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
GO

-- select 'insert LEGACYSPED.MAP_IepSubGoalAreaDefID values ('''+SubGoalAreaCode+''', '''+convert(varchar(36), DestID)+''', '''+convert(varchar(36), ParentID)+''')' from LEGACYSPED.Transform_IepSubGoalAreaDef
if not exists (select 1 from LEGACYSPED.MAP_IepSubGoalAreaDefID where SubGoalAreaCode = 'GAReading')
insert LEGACYSPED.MAP_IepSubGoalAreaDefID values ('GAReading', 'A7506FED-1F87-484C-97DF-99517AC26971', '35B32108-174B-4F7F-9B5A-B5AF106F06BC')

if not exists (select 1 from LEGACYSPED.MAP_IepSubGoalAreaDefID where SubGoalAreaCode = 'GAWriting')
insert LEGACYSPED.MAP_IepSubGoalAreaDefID values ('GAWriting', '7099C2E7-02C9-4903-8A01-8F0774364E5B', '35B32108-174B-4F7F-9B5A-B5AF106F06BC')

if not exists (select 1 from LEGACYSPED.MAP_IepSubGoalAreaDefID where SubGoalAreaCode = 'GAMath')
insert LEGACYSPED.MAP_IepSubGoalAreaDefID values ('GAMath', 'D58C5141-DD5D-4C80-BB93-7CC88A234B2D', '35B32108-174B-4F7F-9B5A-B5AF106F06BC')

if not exists (select 1 from LEGACYSPED.MAP_IepSubGoalAreaDefID where SubGoalAreaCode = 'GAOther')
insert LEGACYSPED.MAP_IepSubGoalAreaDefID values ('GAOther', 'DEEB5A06-156D-43D0-B976-4B30245C6784', '35B32108-174B-4F7F-9B5A-B5AF106F06BC')


-- Map_ServiceFrequencyID is created in the Transform script. -- select * from IepSubGoalAreaDef


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


-- Lee County had a MAP_ServiceFrequencyID from a previouos ETL run that had bogus frequency data. delete that data and insert the good.
declare @Map_ServiceFrequencyID table (ServiceFrequencyCode varchar(30), ServiceFrequencyName varchar(50), DestID uniqueidentifier)
set nocount on;
insert @Map_ServiceFrequencyID values ('day', 'daily', '71590A00-2C40-40FF-ABD9-E73B09AF46A1')
insert @Map_ServiceFrequencyID values ('week', 'weekly', 'A2080478-1A03-4928-905B-ED25DEC259E6')
insert @Map_ServiceFrequencyID values ('month', 'monthly', '3D4B557B-0C2E-4A41-9410-BA331F1D20DD')
insert @Map_ServiceFrequencyID values ('year', 'yearly', '5F3A2822-56F3-49DA-9592-F604B0F202C3')
insert @Map_ServiceFrequencyID values ('ZZZ', 'unknown', 'C42C50ED-863B-44B8-BF68-B377C8B0FA95')

if (select COUNT(*) from @Map_ServiceFrequencyID t join LEGACYSPED.MAP_ServiceFrequencyID m on t.DestID = m.DestID) <> 5
	delete LEGACYSPED.MAP_ServiceFrequencyID

set nocount off;
insert LEGACYSPED.MAP_ServiceFrequencyID
select m.ServiceFrequencyCode, m.ServiceFrequencyName, m.DestID
from @Map_ServiceFrequencyID m left join
	LEGACYSPED.MAP_ServiceFrequencyID t on m.DestID = t.DestID
where t.DestID is null

-- this is seed data, but maybe this is not the best place for this code.....
insert ServiceFrequency (ID, Name, Sequence, WeekFactor)
select DestID, m.ServiceFrequencyName, 99, 0
from LEGACYSPED.MAP_ServiceFrequencyID m left join
	ServiceFrequency t on m.DestID = t.ID
where t.ID is null
GO



--A3FF9417-0899-42BE-8090-D1855D50612F	Quarterly

--67FA2FF5-2300-42D9-A3A7-DF2B76BA2B16	1st Marking Period	Quarterly
--25A2BE26-9706-4127-B1FD-EE0063E0F99E	2nd Marking Period	Quarterly
--B6A39644-01C9-4AC9-A793-5D754848009F	3rd Marking Period	Quarterly
--25FF7721-3E3D-4607-AC9A-C76019444F94	4th Marking Period	Quarterly


--B608ACEE-656E-4F45-B6D9-5D8D9B31BF12	Quarterly and Interim Reports

--8C8F5A4F-7AB3-434A-AC41-839005519762	1st Interim Report	Quarterly and Interim Reports
--39490C65-B14C-4C65-8638-3922EBDD0A6C	1st Marking Period	Quarterly and Interim Reports
--E767511B-0CBA-4C18-9D5E-4F5E8864C71A	2nd Interim Report	Quarterly and Interim Reports
--83284E4D-D586-4843-B7F9-5CCF2CBE2501	2nd Marking Period	Quarterly and Interim Reports
--BF0F3412-61ED-437B-A474-8EA736CA599E	3rd Interim Report	Quarterly and Interim Reports
--9458D601-90B4-4229-994F-0F8FA2EF7F00	3rd Marking Period	Quarterly and Interim Reports
--FAD5B4C8-36B8-4F1D-84A9-C126BDB5325C	4th Interim Report	Quarterly and Interim Reports
--B73FE1CE-AD18-4E86-9B84-1115938612DB	4th Marking Period	Quarterly and Interim Reports
--119F85F4-3252-43B5-AA4F-CE9176510627	ESY Summer			Quarterly and Interim Reports




if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'SpedConversionWrapUp')
drop procedure LEGACYSPED.SpedConversionWrapUp
go

create procedure LEGACYSPED.SpedConversionWrapUp
as
-- this should run for all districts in all states
update d set IsReevaluationNeeded = 1, StartDate = dateadd(dd, -d.MaxDaysToComplete, dateadd(yy, -d.MaxYearsToComplete, getdate())) from PrgMilestoneDef d where d.ID in ('27C002AF-ED92-4152-8B8C-7CA1ADEA2C81', 'AC043E4C-55EC-4F10-BCED-7E9201D7D0E2')

exec dbo.Util_VerifyProgramDataAssumptions 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C'

GO


