--#include ..\..\..\Objects\Transform_ServiceFrequency.sql

-- Colorado
-- San Luis Valley

-- note : data model for SystemSettings table has changed (v 19)

-- OrgUnit
update ou set Number = '9055' 
 --select ou.*
from (select top 1 OrgUnitID from School group by OrgUnitID order by count(*) desc) m join dbo.OrgUnit ou on m.OrgUnitID = ou.ID
go

--update OrgUnit set Number = '1980' where ID = '4794DAC4-151A-45B2-9570-91C8297218E9'
--update OrgUnit set Number = '1990' where ID = 'B717B3FE-10F1-4788-8C77-C60A2C04AF1D'	
--update OrgUnit set Number = '2000' where ID = '6531EF88-352D-4620-AF5D-CE34C54A9F53'	
	


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
--declare @Map_ServiceFrequencyID table (ServiceFrequencyCode varchar(30), ServiceFrequencyName varchar(50), DestID uniqueidentifier)
--set nocount on;
--insert @Map_ServiceFrequencyID values ('ZZZ', 'Not specified', 'C42C50ED-863B-44B8-BF68-B377C8B0FA95')
--insert @Map_ServiceFrequencyID values ('03', 'monthly', '3D4B557B-0C2E-4A41-9410-BA331F1D20DD')
--insert @Map_ServiceFrequencyID values ('01', 'daily', '71590A00-2C40-40FF-ABD9-E73B09AF46A1')
--insert @Map_ServiceFrequencyID values ('02', 'weekly', 'A2080478-1A03-4928-905B-ED25DEC259E6')
--insert @Map_ServiceFrequencyID values ('', 'yearly', '5F3A2822-56F3-49DA-9592-F604B0F202C3')
--insert @Map_ServiceFrequencyID values('AN', 'As Needed', '69439D9D-B6C1-4B7A-9CAC-C69810ADFD31')
--insert @Map_ServiceFrequencyID values('ESY', 'As Needed for ESY', '836D1E97-CE4D-4FD5-9D0A-148924AC007B')




--if (select COUNT(*) from @Map_ServiceFrequencyID t join LEGACYSPED.MAP_ServiceFrequencyID m on t.DestID = m.DestID) <> 5
--	delete LEGACYSPED.MAP_ServiceFrequencyID

--set nocount off;
--insert LEGACYSPED.MAP_ServiceFrequencyID
--select m.ServiceFrequencyCode, m.ServiceFrequencyName, m.DestID
--from @Map_ServiceFrequencyID m left join
--	LEGACYSPED.MAP_ServiceFrequencyID t on m.DestID = t.DestID
--where t.DestID is null

---- this is seed data, but maybe this is not the best place for this code.....
--insert ServiceFrequency (ID, Name, Sequence, WeekFactor)
--select DestID, m.ServiceFrequencyName, 99, 0
--from LEGACYSPED.MAP_ServiceFrequencyID m left join
--	ServiceFrequency t on m.DestID = t.ID
--where t.ID is null
--GO


if exists (select 1 from sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'LEGACYSPED' and o.name = 'PrgItemOutcome_EndIEP')
drop table LEGACYSPED.PrgItemOutcome_EndIEP
go

create table LEGACYSPED.PrgItemOutcome_EndIEP (
PrgItemOutcomeID uniqueidentifier not null
)

insert LEGACYSPED.PrgItemOutcome_EndIEP values ('5ADC11E8-227D-4142-91BA-637E68FDBE70')
go


if not exists (select * from PrgItemOutcome where Text = 'IEP Ended' and CurrentDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3')
begin
 insert PrgItemOutcome (ID, CurrentDefID, Text, Sequence) values (newid(), '8011D6A2-1014-454B-B83C-161CE678E3D3', 'IEP Ended', 0)
end
select * from PrgItemOutcome where Text = 'IEP Ended' and CurrentDefID = '8011D6A2-1014-454B-B83C-161CE678E3D3'