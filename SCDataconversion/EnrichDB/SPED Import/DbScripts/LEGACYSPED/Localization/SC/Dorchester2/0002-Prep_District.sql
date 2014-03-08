
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
/*
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
*/

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

