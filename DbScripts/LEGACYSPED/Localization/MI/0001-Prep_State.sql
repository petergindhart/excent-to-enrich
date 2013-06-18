-- MICHIGAN
/*
	If the state codes were the same in all 50 states we could put this code in the transform files, 
	but so that the transforms can be used in all states, we are separating the state-specific code into this file.

*/


/*

	Ensure IepDisability.StateCode is populated
	If the state code is not populated on Template we need to run this script every time we run ImportExtactLoad or ExtractLoadOnly.  Otherwise there will be an error.
	LEGACYSPED.MAP_IepDisability is populated with ETL from legacy data.  Legacy data must have the StateCode.  
	Legacy disabilities without a state code will be added to the database and hidden from the UI.

	This query should extract the data as needed
	select 'insert @Map_IepDisabilityID values ('''+StateCode+''', '''+convert(varchar(36), ID)+''')'
	from IepDisability r
	where DeletedDate is null


*/


-- NEW powerschool map to indicate up to how many leading zeros to add to district and school numbers
-- This is necessary because PowerSchool trims leading zeros from District Numbers and SchoolNumbers, but the sped program does not.
-- See Transform_OrgUnit and Transform_School to see how this view is used
IF EXISTS (SELECT * FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id WHERE s.name = 'LEGACYSPED' and o.Name ='DistrictSchoolLeadingZeros' and type = 'U')
drop table LEGACYSPED.DistrictSchoolLeadingZeros
GO

CREATE TABLE LEGACYSPED.DistrictSchoolLeadingZeros
(
	Entity	varchar(10) not null,
	Zeros	varchar(10) not null
)

-- MI:  District 5 characters, School 5 characters
insert LEGACYSPED.DistrictSchoolLeadingZeros values ('District', '00000')
insert LEGACYSPED.DistrictSchoolLeadingZeros values ('School', '00000')
go


set nocount on;
declare @Map_IepDisabilityID table (StateCode varchar(10), DestID uniqueidentifier)

insert @Map_IepDisabilityID values ('08', 'CF411FEB-F76E-4EC0-BE2F-0F84AA453292')
insert @Map_IepDisabilityID values ('20', '4AF9506C-F4D5-430E-9BB7-3D46D96BDC96')
insert @Map_IepDisabilityID values ('15', 'B9AAA2A4-A395-4BF2-B5C1-6AF98CCEA676')
insert @Map_IepDisabilityID values ('13', '73B7E618-3177-4879-A7EB-76D579E61AE6')
insert @Map_IepDisabilityID values ('10', '96A66C19-7AAB-4EE6-AA81-7CD8CD4FEB09')
insert @Map_IepDisabilityID values ('11', '1D0B34DD-55BF-42EB-A0CA-7D2542EBC059')
insert @Map_IepDisabilityID values ('09', '07093979-0C3F-414D-9750-8080C6BB7C45')
insert @Map_IepDisabilityID values ('07', 'D1CFA1E9-D8D8-4317-92A4-94621F5C3466')
insert @Map_IepDisabilityID values ('16', 'E65E6AAE-AE9B-4275-B547-9CE1A4B9EEF3')
insert @Map_IepDisabilityID values ('06', '7599B90D-8842-4B49-9BFC-B5CDBAAAA074')
insert @Map_IepDisabilityID values ('14', 'CA41A561-16BE-4E21-BE8A-BC59ED86C921')
insert @Map_IepDisabilityID values ('13', '0E026822-6B22-43A1-BD6E-C1412E3A6FA3')
insert @Map_IepDisabilityID values ('17', 'BAD7E731-3459-4EED-80C6-CA4D91BCD246')
insert @Map_IepDisabilityID values ('05', '12F08D30-1ADA-4F9A-AD2A-EF5451BB2325')

set nocount off;
update d set StateCode = m.StateCode
from @Map_IepDisabilityID m
join IepDisability d on m.DestID = d.ID
go


-- this may need to be modified for states that don't have a specific code for each race, but set a flag for it (such as FL).  Eather that, or we can derive a code for those statues (first 2 letters of the fed name?)
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_FederalRace') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
create table LEGACYSPED.MAP_FederalRace 
	(
	StateRaceCode varchar(150) NOT NULL,
	FederalRaceName varchar(150) NOT NULL
	)
ALTER TABLE LEGACYSPED.MAP_FederalRace ADD CONSTRAINT
	PK_MAP_FederalRace PRIMARY KEY CLUSTERED
	(
	StateRaceCode
	)
END
GO

insert LEGACYSPED.MAP_FederalRace values ('A', 'Asian')
insert LEGACYSPED.MAP_FederalRace values ('I', 'American Indian')
insert LEGACYSPED.MAP_FederalRace values ('P', 'Hawaiian Pacific Islander')
insert LEGACYSPED.MAP_FederalRace values ('H', 'Hispanic')
insert LEGACYSPED.MAP_FederalRace values ('W', 'White')
insert LEGACYSPED.MAP_FederalRace values ('B', 'Black African American')
go



-- #############################################################################
--		Goal Area Def MAP

IF EXISTS (SELECT * FROM sys.objects WHERE Name ='LEGACYSPED.MAP_IepGoalAreaDefID' and type = 'U')
drop table LEGACYSPED.MAP_GoalAreaDefID
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepGoalAreaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE LEGACYSPED.MAP_IepGoalAreaDefID
	(
		GoalAreaCode	varchar(150) NOT NULL,
		DestID uniqueidentifier NOT NULL
	)

	ALTER TABLE LEGACYSPED.MAP_IepGoalAreaDefID ADD CONSTRAINT
	PK_MAP_IepGoalAreaDefID PRIMARY KEY CLUSTERED
	(
		GoalAreaCode
	)
END

-- Should these be exported with the configuration?
-- Specific to Michigan
declare @ga table (GoalAreaCode varchar(20), DestID uniqueidentifier)
set nocount on;

/*
	select 'insert @ga values (''GA'+right('00'+ convert(varchar(5), Sequence), 3)  +''', '''+convert(varchar(36), ID)+''')'
	from IepGoalAreaDef 
	where DeletedDate is null
	order by Sequence

*/

insert @ga values ('GA000', '504CE0ED-537F-4EA0-BD97-0349FB1A4CA8')
insert @ga values ('GA001', '37EA0554-EC3F-4B95-AAD7-A52DECC7377C')
insert @ga values ('GA002', '0E95D360-5CBE-4ECA-820F-CC25864D70D8')
insert @ga values ('GA003', '51C976DF-DC56-4F89-BCA1-E9AB6A01FBE7')
insert @ga values ('GA004', '4F131BE0-D2A9-4EB2-8639-D772E05F3D5E')
insert @ga values ('GA005', '25D890C3-BCAE-4039-AC9D-2AE21686DEB0')
insert @ga values ('GA006', '6BBAADD8-BD9D-4C8F-A573-80F136B0A9FB')
insert @ga values ('GA007', '0C0783DD-3D11-47A2-A1C1-CFE2F8F1FB4C')
insert @ga values ('GA008', '010CB59C-5767-47D1-BECA-7FCC12D80948')
insert @ga values ('GA009', '7137572B-21E7-4258-BD7C-4F43151B133D')
insert @ga values ('GA010', '78AEC564-D597-4024-AB84-771218A666C4')
insert @ga values ('GA011', '5EB076EB-7094-42DE-8713-897D4EC16677')
insert @ga values ('GA012', 'D74A66C5-DCFB-46DC-8F30-5878FA16BAFA')
insert @ga values ('ZZZ', '3A7762D8-E514-439A-A0BE-6F3D3D77085E')


insert LEGACYSPED.MAP_IepGoalAreaDefID
select ga.* from @ga ga left join LEGACYSPED.MAP_IepGoalAreaDefID m on ga.GoalAreaCode = m.GoalAreaCode where m.GoalAreaCode is null

-- we are hard coding the relationship with IEPGoalAreaDef, so since this one didn't exist we need to create it.
if not exists (select 1 from IepGoalAreaDef where ID = '3A7762D8-E514-439A-A0BE-6F3D3D77085E')
insert IepGoalAreaDef (ID, Sequence, Name, AllowCustomProbes, RequireGoal) values ('3A7762D8-E514-439A-A0BE-6F3D3D77085E', 13, 'Not Provided', 0, 0)

-- #############################################################################
--		Post School Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PostSchoolAreaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE LEGACYSPED.MAP_PostSchoolAreaDefID
	(
		PostSchoolAreaCode	varchar(150) NOT NULL,
		DestID uniqueidentifier NOT NULL
	)

	ALTER TABLE LEGACYSPED.MAP_PostSchoolAreaDefID ADD CONSTRAINT
	PK_MAP_PostSchoolAreaDefID PRIMARY KEY CLUSTERED
	(
		PostSchoolAreaCode
	)

create index IX_LEGACYSPED_MAP_PostSchoolAreaDefID_DestID on LEGACYSPED.MAP_PostSchoolAreaDefID (DestID)

-- thse IDs are exported with Enrich configuration for Jackson, MI.  This should be in the State config file
END


/*
	select 'insert @psa values ('''+Code+''', '''+convert(varchar(36), ID)+''')'
	from IepPostSchoolAreaDef 
	where DeletedDate is null
	order by Sequence

*/

set nocount on;
declare @psa table (PostSchoolAreaCode varchar(20), DestID uniqueidentifier)
insert @psa values ('EdTraining', 'ADB5C7FD-C09F-41E3-9C0E-9AF403C741D1')
insert @psa values ('Employment', '823BA9DB-AF13-42BD-9CC2-EAA884701523')
insert @psa values ('IndLiving', '2B5D9C8A-7FA7-4E74-9F0C-53327209E751')
insert @psa values ('Particip', '418173BC-8EE2-47A1-8EE7-FBDBC15B096D')

insert LEGACYSPED.MAP_PostSchoolAreaDefID
select * from @psa where PostSchoolAreaCode not in (select PostSchoolAreaCode from LEGACYSPED.MAP_PostSchoolAreaDefID)

GO

-- last line
