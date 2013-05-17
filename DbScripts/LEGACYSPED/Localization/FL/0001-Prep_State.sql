-- Florida
/*
	If the state codes were the same in all 50 states we could put this code in the transform files, 
	but so that the transforms can be used in all states, we are separating the state-specific code into this file.

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
insert LEGACYSPED.DistrictSchoolLeadingZeros values ('District', '00')
insert LEGACYSPED.DistrictSchoolLeadingZeros values ('School', '0000')
go



-- Ensure GradeLevel StateCode is populated.  Specific to Florida
update GradeLevel set StateCode = case Name when 'K' then 'KG' when '00' then NULL else Name end
go

/*

	Ensure IepDisability.StateCode is populated
	If the state code is not populated on Template we need to run this script every time we run ImportExtactLoad or ExtractLoadOnly.  Otherwise there will be an error.
	LEGACYSPED.MAP_IepDisability is populated with ETL from legacy data.  Legacy data must have the StateCode.  
	Legacy disabilities without a state code will be added to the database and hidden from the UI.

*/
set nocount on;
declare @Map_IepDisabilityID table (StateCode varchar(10), DestID uniqueidentifier)
insert @Map_IepDisabilityID values ('P', '8D9B3B54-4080-4D5E-A196-956D5223E479')
insert @Map_IepDisabilityID values ('H', '79450790-72A4-4F16-8840-6193DB199A1E')
insert @Map_IepDisabilityID values ('O', '8387827A-D139-41E1-A0CF-C741C6420C91')
insert @Map_IepDisabilityID values ('J', 'A1504419-19F6-434B-B4A3-1E5A69E99A9B')
insert @Map_IepDisabilityID values ('U', '78992797-25C0-468F-95C3-EAC4B6FDE392')
insert @Map_IepDisabilityID values ('L', '30DAB9E4-A94B-4297-BE09-7BE4CA8E0059')
insert @Map_IepDisabilityID values ('M', '282A8F78-A603-45FE-8724-82C43F034936')
insert @Map_IepDisabilityID values ('G', '8F8579F1-B58C-4FBB-A8CC-A153B460D98C')
insert @Map_IepDisabilityID values ('D', 'FED29935-0384-4C42-A7E7-C5B07031253B')
insert @Map_IepDisabilityID values ('C', '07093979-0C3F-414D-9750-8080C6BB7C45')
insert @Map_IepDisabilityID values ('V', 'E52F0A25-994F-4CBA-9310-EEB96773FC14')
insert @Map_IepDisabilityID values ('E', '49A41ECA-6738-41E6-9DAE-3D6963DFB6E1')
insert @Map_IepDisabilityID values ('K', '0E026822-6B22-43A1-BD6E-C1412E3A6FA3')
insert @Map_IepDisabilityID values ('F', '96A66C19-7AAB-4EE6-AA81-7CD8CD4FEB09')
insert @Map_IepDisabilityID values ('T', 'B0439371-3A5E-4FD7-912E-0C3AA4963C26')
insert @Map_IepDisabilityID values ('S', 'E65E6AAE-AE9B-4275-B547-9CE1A4B9EEF3')
insert @Map_IepDisabilityID values ('I', 'D31E4ED0-9A37-490F-B49B-FF18133644FE')
insert @Map_IepDisabilityID values ('Z', '1057DFB9-1DE9-4147-9326-F13C0CC3A661') -- not currently in
insert @Map_IepDisabilityID values ('W', '8D0AA58F-597A-462F-B509-BB8F0B2AB593')

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

--insert LEGACYSPED.MAP_FederalRace values ('A', 'Asian')
--insert LEGACYSPED.MAP_FederalRace values ('I', 'American Indian')
--insert LEGACYSPED.MAP_FederalRace values ('P', 'Hawaiian Pacific Islander')
--insert LEGACYSPED.MAP_FederalRace values ('H', 'Hispanic')
--insert LEGACYSPED.MAP_FederalRace values ('W', 'White')
--insert LEGACYSPED.MAP_FederalRace values ('B', 'Black African American')
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
-- these IDs used to be exported with Enrich configuration for Florida.  This should be in the State config file
declare @ga table (GoalAreaCode varchar(20), DestID uniqueidentifier)
set nocount on;
--insert @ga values ('GAReading', '35B32108-174B-4F7F-9B5A-B5AF106F06BC')
--insert @ga values ('GAWriting', 'DA0ECBD3-9E20-4031-8F8F-631D3FB4118C')
--insert @ga values ('GAMath', 'F6C49490-FA7B-4188-A24A-D98797484D38')
--insert @ga values ('GAOther', '489C84EA-BD0D-4F56-9C79-89FB089E2511')
insert @ga values ('GACurriculum', '35B32108-174B-4F7F-9B5A-B5AF106F06BC')
insert @ga values ('GAEmotional', '52073BF0-C83A-4DEF-9C3C-F4D6884BE9AA')
insert @ga values ('GAIndependent', '5A3D5EE7-618B-4F70-B893-BFB0EE8754BE')
insert @ga values ('GAHealth', '7D6B33A0-216B-4747-A827-7A4FFC80227F')
insert @ga values ('GACommunication', '2AA2F135-2FB3-4607-B932-99F5491916DE')


insert LEGACYSPED.MAP_IepGoalAreaDefID
select ga.* from @ga ga left join LEGACYSPED.MAP_IepGoalAreaDefID m on ga.GoalAreaCode = m.GoalAreaCode where m.GoalAreaCode is null


--		these are inserted in PrepDistrict (not all FL districts will have their goal areas separated this way).
--insert @ga values ('GAReading', '35B32108-174B-4F7F-9B5A-B5AF106F06BC')
--insert @ga values ('GAWriting', 'DA0ECBD3-9E20-4031-8F8F-631D3FB4118C')
--insert @ga values ('GAMath', 'F6C49490-FA7B-4188-A24A-D98797484D38')
--insert @ga values ('GAOther', '489C84EA-BD0D-4F56-9C79-89FB089E2511')




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

	-- thse IDs are exported with Enrich configuration for Florida.  This should be in the State config file
END

set nocount on;
declare @psa table (PostSchoolAreaCode varchar(20), DestID uniqueidentifier)
insert @psa values ('PSAdult', '57D9D83C-FB23-4712-8744-960A11BF6110')
insert @psa values ('PSCommunity', '99491AC1-AE42-4752-8CE2-326F5AD84199')
insert @psa values ('PSInstruction', 'ADB5C7FD-C09F-41E3-9C0E-9AF403C741D1')
insert @psa values ('PSEmployment', '823BA9DB-AF13-42BD-9CC2-EAA884701523')
insert @psa values ('PSDailyLiving', '2B5D9C8A-7FA7-4E74-9F0C-53327209E751')
insert @psa values ('PSRelated', '6F86246C-025C-4EE6-A81F-F9983CC37469')
insert @psa values ('PSVocational', 'DBB7D8F5-DA73-4F1A-948D-6EF17D93D0D8')

insert LEGACYSPED.MAP_PostSchoolAreaDefID
select * from @psa where PostSchoolAreaCode not in (select PostSchoolAreaCode from LEGACYSPED.MAP_PostSchoolAreaDefID)

GO

-- last line
