-- Florida
/*
	If the state codes were the same in all 50 states we could put this code in the transform files, 
	but so that the transforms can be used in all states, we are separating the state-specific code into this file.

*/

-- ############################################################################# --------------- we are going to use the one from LEGACYSPED
--		Goal Area Def MAP

--IF EXISTS (SELECT * FROM sys.objects WHERE Name ='x_LEGACYGIFT.MAP_IepGoalAreaDefID' and type = 'U')
--drop table x_LEGACYGIFT.MAP_GoalAreaDefID
--GO

--IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_IepGoalAreaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
--BEGIN
--	CREATE TABLE x_LEGACYGIFT.MAP_IepGoalAreaDefID
--	(
--		GoalAreaCode	varchar(150) NOT NULL,
--		DestID uniqueidentifier NOT NULL
--	)

--	ALTER TABLE x_LEGACYGIFT.MAP_IepGoalAreaDefID ADD CONSTRAINT
--	PK_MAP_IepGoalAreaDefID PRIMARY KEY CLUSTERED
--	(
--		GoalAreaCode
--	)
--END

---- Should these be exported with the configuration?
---- these IDs used to be exported with Enrich configuration for Florida.  This should be in the State config file
--declare @ga table (GoalAreaCode varchar(20), DestID uniqueidentifier)
--set nocount on;
----insert @ga values ('GAReading', '35B32108-174B-4F7F-9B5A-B5AF106F06BC')
----insert @ga values ('GAWriting', 'DA0ECBD3-9E20-4031-8F8F-631D3FB4118C')
----insert @ga values ('GAMath', 'F6C49490-FA7B-4188-A24A-D98797484D38')
----insert @ga values ('GAOther', '489C84EA-BD0D-4F56-9C79-89FB089E2511')
--insert @ga values ('GACurriculum', '35B32108-174B-4F7F-9B5A-B5AF106F06BC')
--insert @ga values ('GAEmotional', '52073BF0-C83A-4DEF-9C3C-F4D6884BE9AA')
--insert @ga values ('GAIndependent', '5A3D5EE7-618B-4F70-B893-BFB0EE8754BE')
--insert @ga values ('GAHealth', '7D6B33A0-216B-4747-A827-7A4FFC80227F')
--insert @ga values ('GACommunication', '2AA2F135-2FB3-4607-B932-99F5491916DE')


--insert x_LEGACYGIFT.MAP_IepGoalAreaDefID
--select ga.* from @ga ga left join x_LEGACYGIFT.MAP_IepGoalAreaDefID m on ga.GoalAreaCode = m.GoalAreaCode where m.GoalAreaCode is null


--		these are inserted in PrepDistrict (not all FL districts will have their goal areas separated this way).
--insert @ga values ('GAReading', '35B32108-174B-4F7F-9B5A-B5AF106F06BC')
--insert @ga values ('GAWriting', 'DA0ECBD3-9E20-4031-8F8F-631D3FB4118C')
--insert @ga values ('GAMath', 'F6C49490-FA7B-4188-A24A-D98797484D38')
--insert @ga values ('GAOther', '489C84EA-BD0D-4F56-9C79-89FB089E2511')




-- #############################################################################
--		Post School Area MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.MAP_PostSchoolAreaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE x_LEGACYGIFT.MAP_PostSchoolAreaDefID
	(
		PostSchoolAreaCode	varchar(150) NOT NULL,
		DestID uniqueidentifier NOT NULL
	)

	ALTER TABLE x_LEGACYGIFT.MAP_PostSchoolAreaDefID ADD CONSTRAINT
	PK_MAP_PostSchoolAreaDefID PRIMARY KEY CLUSTERED
	(
		PostSchoolAreaCode
	)

	create index IX_x_LEGACYGIFT_MAP_PostSchoolAreaDefID_DestID on x_LEGACYGIFT.MAP_PostSchoolAreaDefID (DestID)

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

insert x_LEGACYGIFT.MAP_PostSchoolAreaDefID
select * from @psa where PostSchoolAreaCode not in (select PostSchoolAreaCode from x_LEGACYGIFT.MAP_PostSchoolAreaDefID)

GO

-- last line
