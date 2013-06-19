
-- Florida
-- Polk
-- GIFTED

if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYGIFT' and o.name = 'MAP_PrgStatus_ConvertedEP')
drop table x_LEGACYGIFT.MAP_PrgStatus_ConvertedEP
go

create table x_LEGACYGIFT.MAP_PrgStatus_ConvertedEP (DestID uniqueidentifier not null)
insert x_LEGACYGIFT.MAP_PrgStatus_ConvertedEP values ('DA52C2A1-5265-4DE6-9509-B4B97FCA3900') 
go


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.ImportPrgSections') AND type in (N'U'))
DROP TABLE x_LEGACYGIFT.ImportPrgSections
GO

CREATE TABLE x_LEGACYGIFT.ImportPrgSections (
Enabled bit not null,
SectionDefName varchar(100) not null,
SectionDefID uniqueidentifier not null
)
GO

ALTER TABLE x_LEGACYGIFT.ImportPrgSections
	ADD CONSTRAINT PK_ImportPrgSections PRIMARY KEY CLUSTERED
(
	SectionDefID
)
GO

set nocount on;
declare @importPrgSections table (Enabled bit not null, SectionDefName varchar(100) not null, SectionDefID uniqueidentifier not null)
-- update the Enabled column below to 0 if the section is not required for this district
insert @importPrgSections values (1, 'EP Services', '9AC79680-7989-4CC9-8116-1CCDB1D0AE5F')
insert @importPrgSections values (1, 'EP Dates', 'EE479921-3ECB-409A-96D7-61C8E7BA0E7B')
insert @importPrgSections values (1, 'EP Goals', '84E5A67D-CC9A-4D5B-A7B8-C04E8C3B8E0A')

insert x_LEGACYGIFT.ImportPrgSections
select * from @importPrgSections
go


---- #############################################################################
----		Goal Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_EPSubGoalAreaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE x_LEGACYGIFT.MAP_EPSubGoalAreaDefID 
(
	SubGoalAreaCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL,
	ParentID uniqueidentifier not null
)

ALTER TABLE x_LEGACYGIFT.MAP_EPSubGoalAreaDefID ADD CONSTRAINT
PK_MAP_EPSubGoalAreaDefID PRIMARY KEY CLUSTERED
(
	SubGoalAreaCode
)

END
GO

-- select 'insert x_LEGACYGIFT.MAP_EPSubGoalAreaDefID values ('''+SubGoalAreaCode+''', '''+convert(varchar(36), DestID)+''', '''+convert(varchar(36), ParentID)+''')' from x_LEGACYGIFT.Transform_EPSubGoalAreaDef
if not exists (select 1 from x_LEGACYGIFT.MAP_EPSubGoalAreaDefID where SubGoalAreaCode = 'GAReading')
insert x_LEGACYGIFT.MAP_EPSubGoalAreaDefID values ('GAReading', 'A7506FED-1F87-484C-97DF-99517AC26971', '35B32108-174B-4F7F-9B5A-B5AF106F06BC')

if not exists (select 1 from x_LEGACYGIFT.MAP_EPSubGoalAreaDefID where SubGoalAreaCode = 'GAWriting')
insert x_LEGACYGIFT.MAP_EPSubGoalAreaDefID values ('GAWriting', '7099C2E7-02C9-4903-8A01-8F0774364E5B', '35B32108-174B-4F7F-9B5A-B5AF106F06BC')

if not exists (select 1 from x_LEGACYGIFT.MAP_EPSubGoalAreaDefID where SubGoalAreaCode = 'GAMath')
insert x_LEGACYGIFT.MAP_EPSubGoalAreaDefID values ('GAMath', 'D58C5141-DD5D-4C80-BB93-7CC88A234B2D', '35B32108-174B-4F7F-9B5A-B5AF106F06BC')

if not exists (select 1 from x_LEGACYGIFT.MAP_EPSubGoalAreaDefID where SubGoalAreaCode = 'GAOther')
insert x_LEGACYGIFT.MAP_EPSubGoalAreaDefID values ('GAOther', 'DEEB5A06-156D-43D0-B976-4B30245C6784', '35B32108-174B-4F7F-9B5A-B5AF106F06BC')

---- Lee County had a MAP_ServiceFrequencyID from a previouos ETL run that had bogus frequency data. delete that data and insert the good.
--declare @Map_ServiceFrequencyID table (ServiceFrequencyCode varchar(30), ServiceFrequencyName varchar(50), DestID uniqueidentifier)
--set nocount on;
--insert @Map_ServiceFrequencyID values ('day', 'daily', '71590A00-2C40-40FF-ABD9-E73B09AF46A1')
--insert @Map_ServiceFrequencyID values ('week', 'weekly', 'A2080478-1A03-4928-905B-ED25DEC259E6')
--insert @Map_ServiceFrequencyID values ('month', 'monthly', '3D4B557B-0C2E-4A41-9410-BA331F1D20DD')
--insert @Map_ServiceFrequencyID values ('year', 'yearly', '5F3A2822-56F3-49DA-9592-F604B0F202C3')
--insert @Map_ServiceFrequencyID values ('ZZZ', 'unknown', 'C42C50ED-863B-44B8-BF68-B377C8B0FA95')

--if (select COUNT(*) from @Map_ServiceFrequencyID t join x_LEGACYGIFT.MAP_ServiceFrequencyID m on t.DestID = m.DestID) <> 5
--	delete x_LEGACYGIFT.MAP_ServiceFrequencyID

--set nocount off;
--insert x_LEGACYGIFT.MAP_ServiceFrequencyID
--select m.ServiceFrequencyCode, m.ServiceFrequencyName, m.DestID
--from @Map_ServiceFrequencyID m left join
--	x_LEGACYGIFT.MAP_ServiceFrequencyID t on m.DestID = t.DestID
--where t.DestID is null

---- this is seed data, but maybe this is not the best place for this code.....
--insert ServiceFrequency (ID, Name, Sequence, WeekFactor)
--select DestID, m.ServiceFrequencyName, 99, 0
--from x_LEGACYGIFT.MAP_ServiceFrequencyID m left join
--	ServiceFrequency t on m.DestID = t.ID
--where t.ID is null
--GO


if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_LEGACYGIFT' and o.name = 'GiftedConversionWrapUp')
drop procedure x_LEGACYGIFT.GiftedConversionWrapUp
go

create procedure x_LEGACYGIFT.GiftedConversionWrapUp
as
-- this should run for all districts in all states
update d set IsReevaluationNeeded = 1, StartDate = dateadd(dd, -d.MaxDaysToComplete, dateadd(yy, -d.MaxYearsToComplete, getdate())) from PrgMilestoneDef d where d.ID in ('27C002AF-ED92-4152-8B8C-7CA1ADEA2C81', 'AC043E4C-55EC-4F10-BCED-7E9201D7D0E2')

exec dbo.Util_VerifyProgramDataAssumptions '2FF58E06-9E4A-4BE5-8274-E0FDE0012D4E'

GO


