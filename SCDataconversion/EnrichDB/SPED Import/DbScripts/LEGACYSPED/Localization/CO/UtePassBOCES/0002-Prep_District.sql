--#include ..\..\..\Objects\Transform_ServiceFrequency.sql

-- Colorado
-- UtePassBoces

-- note : data model for SystemSettings table has changed (v 19)

-- OrgUnit
--update ou set Number = '9165' 
-- select ou.*
--from (select top 1 OrgUnitID from School group by OrgUnitID order by count(*) desc) m join dbo.OrgUnit ou on m.OrgUnitID = ou.ID
--go
--UPDATE OrgUnit
--SET Number = '3020'
--Where ID = '1A7AE897-99F4-4C22-B529-6EB36A763DC4'
--1A7AE897-99F4-4C22-B529-6EB36A763DC4	420A9663-FFE8-4FF1-B405-1DB1D42B6F8A	Woodland Park
--8558AD16-FEF6-4008-8BEA-B3A19BF8B6A9	420A9663-FFE8-4FF1-B405-1DB1D42B6F8A	Manitou Springs
--6F22BFFC-728F-4304-8FDC-CDD151A946AB	420A9663-FFE8-4FF1-B405-1DB1D42B6F8A	Cripple Creek
--6531EF88-352D-4620-AF5D-CE34C54A9F53	420A9663-FFE8-4FF1-B405-1DB1D42B6F8A	UTE Pass BOCES
--select * from Orgunittype where ID = '420A9663-FFE8-4FF1-B405-1DB1D42B6F8A'

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

declare @OrgUnit table (ID uniqueidentifier, Name varchar(200), Number varchar(10))
insert @OrgUnit values ('1295D5FF-2E5D-45B4-8DCA-2A0ADEB3FA68','El Paso 2','0980')
insert @OrgUnit values ('64B46E66-61B5-461D-BA95-3EBE8FBFEED3','El Paso 12','1020')
insert @OrgUnit values('EFC57A8C-6CD7-4456-9DD5-459EE2ED8C5F','El Paso 11','1010')
insert @OrgUnit values('70EE2A06-EF2F-4544-83DA-532DF3006649','PIKES PEAK BOCES','9045')
insert @OrgUnit values('44118DF4-DE34-423C-9F51-6B32ACF661C7','Fremont RE-2 Florence','1150')
insert @OrgUnit values('1A7AE897-99F4-4C22-B529-6EB36A763DC4','Woodland Park','3020')
insert @OrgUnit values('99714D30-07C8-4BE0-9D20-AC92875EF3F7','El Paso 49','1110')
insert @OrgUnit values('8558AD16-FEF6-4008-8BEA-B3A19BF8B6A9','Manitou Springs','1030')
insert @OrgUnit values('16686C6F-637E-43C4-A3E8-B67C8533C1B0','ZZZZ','0000')
insert @OrgUnit values('6F22BFFC-728F-4304-8FDC-CDD151A946AB','Cripple Creek','3010')
insert @OrgUnit values('6531EF88-352D-4620-AF5D-CE34C54A9F53','UTE Pass BOCES','9165')
insert @OrgUnit values('648BAB04-405E-491B-996E-DFE7D14580CC','Park RE-2 Fairplay','2610')
insert @OrgUnit values('D20A5171-7E06-4D79-B569-E8BE9E5D419E','El Paso 20','1040')


update ou set Number = t.Number
-- select * 
from @OrgUnit t join
OrgUnit ou on t.ID = ou.ID


--UPDATE OrgUnit
--SET Number = '3020' --, ParentID = '6531EF88-352D-4620-AF5D-CE34C54A9F53'
--Where ID = '1A7AE897-99F4-4C22-B529-6EB36A763DC4'

--UPDATE OrgUnit
--SET Number = '1030'  --, ParentID = '6531EF88-352D-4620-AF5D-CE34C54A9F53'
--Where ID = '8558AD16-FEF6-4008-8BEA-B3A19BF8B6A9'

--UPDATE OrgUnit
--SET Number = '3010'  --, ParentID = '6531EF88-352D-4620-AF5D-CE34C54A9F53'
--Where ID = '6F22BFFC-728F-4304-8FDC-CDD151A946AB'

--UPDATE OrgUnit
--SET Number = '9165'
--Where ID = '6531EF88-352D-4620-AF5D-CE34C54A9F53'





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

-- Lee County had a MAP_ServiceFrequencyID from a previouos ETL run that had bogus frequency data. delete that data and insert the good.
declare @Map_ServiceFrequencyID table (ServiceFrequencyCode varchar(30), ServiceFrequencyName varchar(50), DestID uniqueidentifier)
set nocount on;
insert @Map_ServiceFrequencyID values ('ZZZ', 'Not specified', 'C42C50ED-863B-44B8-BF68-B377C8B0FA95')
insert @Map_ServiceFrequencyID values ('03', 'monthly', '3D4B557B-0C2E-4A41-9410-BA331F1D20DD')
insert @Map_ServiceFrequencyID values ('01', 'daily', '71590A00-2C40-40FF-ABD9-E73B09AF46A1')
insert @Map_ServiceFrequencyID values ('02', 'weekly', 'A2080478-1A03-4928-905B-ED25DEC259E6')
insert @Map_ServiceFrequencyID values ('', 'yearly', '5F3A2822-56F3-49DA-9592-F604B0F202C3')
insert @Map_ServiceFrequencyID values('AN', 'As Needed', '69439D9D-B6C1-4B7A-9CAC-C69810ADFD31')
insert @Map_ServiceFrequencyID values('ESY', 'As Needed for ESY', '836D1E97-CE4D-4FD5-9D0A-148924AC007B')




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


---- need this code to add cascade delete on FK_PrgIep_PrgItem until the build with this change makes production
--IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'dbo.FK_PrgIep_PrgItem') AND parent_object_id = OBJECT_ID(N'dbo.PrgIep'))
--ALTER TABLE dbo.PrgIep DROP CONSTRAINT FK_PrgIep_PrgItem
--GO

--ALTER TABLE dbo.PrgIep  WITH CHECK ADD  CONSTRAINT FK_PrgIep_PrgItem FOREIGN KEY(ID)
--REFERENCES dbo.PrgItem (ID)
--      ON DELETE CASCADE
--GO

--ALTER TABLE dbo.PrgIep CHECK CONSTRAINT FK_PrgIep_PrgItem
--GO


--IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'dbo.FK_PrgMatrixOfServices#InitiatingIep#') AND parent_object_id = OBJECT_ID(N'dbo.PrgMatrixOfServices'))
--ALTER TABLE dbo.PrgMatrixOfServices DROP CONSTRAINT FK_PrgMatrixOfServices#InitiatingIep#
--GO

--ALTER TABLE dbo.PrgMatrixOfServices  WITH CHECK ADD  CONSTRAINT FK_PrgMatrixOfServices#InitiatingIep# FOREIGN KEY(InitiatingIepID)
--REFERENCES dbo.PrgIep (ID)
--	ON DELETE CASCADE
--GO

--ALTER TABLE dbo.PrgMatrixOfServices CHECK CONSTRAINT FK_PrgMatrixOfServices#InitiatingIep#
--GO


-- drop objects no longer needed

-- Florida
-- Lee County School District

-- All MAP tables have been moved to the transform script files.  This file contains drop table statements for MAP tables that are no longer used.

-- #############################################################################
-- ServiceDef
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Map_ServiceDefIDstatic') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.Map_ServiceDefIDstatic
GO
-- no longer used

-- #############################################################################
-- ExitReason
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_OutcomeID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_OutcomeID
GO
-- we are using PrgStatus

-- #############################################################################
-- Service Location
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_ServiceLocationIDstatic') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_ServiceLocationIDstatic
GO
-- no longer used

-- #############################################################################
-- Service Location
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_ServiceLocationID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_ServiceLocationID
GO
-- we are using PrgLocation


-- #############################################################################
-- School
IF  EXISTS (SELECT 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'AURORAX' and o.name = 'MAP_SchoolView')
	DROP VIEW AURORAX.MAP_SchoolView
GO
-- no longer used

-- #############################################################################
-- ServiceDefID
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_ServiceDefID') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_ServiceDefID
GO
-- renamed this transform


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



/*

select 
	PlacementTypeCode = k.SubType,
	PlacementOptionCode = isnull(k.Code, convert(varchar(150), k.Label)), 
	StateCode = k.StateCode, -- ??
	DestID = coalesce(s.ID, t.ID, m.DestID),
	TypeID = coalesce(s.TypeID, t.TypeID, my.DestID),
	Sequence = coalesce(s.Sequence, t.Sequence, 99),
	Text = coalesce(s.Text, t.Text, k.Label),
	MinPercentGenEd = isnull(s.MinPercentGenEd, t.MinPercentGenEd),   
	MaxPercentGenEd = isnull(s.MaxPercentGenEd, t.MaxPercentGenEd),   
	DeletedDate = 
			CASE 
				WHEN s.ID IS NOT NULL THEN NULL -- Always show in UI where there is a StateID.  Period.
				ELSE 
					CASE WHEN k.DisplayInUI = 'Y' THEN NULL -- User specified they want to see this in the UI.  Let them.
					ELSE GETDATE()
					END
			END 
from 
	LEGACYSPED.Lookups k LEFT JOIN
	LEGACYSPED.MAP_IepPlacementTypeID my on k.SubType = my.PlacementTypeCode LEFT JOIN 
	dbo.IepPlacementOption s on 
		my.DestID = s.TypeID and
		k.StateCode = s.StateCode LEFT JOIN 
	LEGACYSPED.MAP_IepPlacementOptionID m on 
		my.PlacementTypeCode = m.PlacementTypeCode and
		isnull(k.Code, convert(varchar(150), k.label)) = m.PlacementOptionCode LEFT JOIN
	dbo.IepPlacementOption t on m.DestID = t.ID
where k.Type = 'LRE' and
	k.SubType in ('PK', 'K12') 



*/





