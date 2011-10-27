-- Colorado
/*
	If the state codes were the same in all 50 states we could put this code in the transform files, 
	but so that the transforms can be used in all states, we are separating the state-specific code into this file.

*/

-- Ensure GradeLevel StateCode is populated.  Specific to Colorado
update gl set StateCode = case when Name like 'K%' then 'KG' when Name = '00' then NULL else Name end from GradeLevel gl where (ISNUMERIC(Name) = 1 or Name in ('K', 'PK', 'KG'))
go

/*

	Ensure IepDisability.StateCode is populated
	If the state code is not populated on Template we need to run this script every time we run ImportExtactLoad or ExtractLoadOnly.  Otherwise there will be an error.
	LEGACYSPED.MAP_IepDisability is populated with ETL from legacy data.  Legacy data must have the StateCode.
	Legacy disabilities without a state code will be added to the database and hidden from the UI.

*/
set nocount on;
declare @Map_IepDisabilityID table (StateCode varchar(10), DestID uniqueidentifier)
insert @Map_IepDisabilityID values ('13 ', '8D9B3B54-4080-4D5E-A196-956D5223E479')
--insert @Map_IepDisabilityID values ('09 ', '')
insert @Map_IepDisabilityID values ('05 ', '79450790-72A4-4F16-8840-6193DB199A1E')
--insert @Map_IepDisabilityID values ('12 ', '')
insert @Map_IepDisabilityID values ('10 ', 'CA41A561-16BE-4E21-BE8A-BC59ED86C921')
insert @Map_IepDisabilityID values ('07 ', '07093979-0C3F-414D-9750-8080C6BB7C45')
insert @Map_IepDisabilityID values ('11 ', 'B0439371-3A5E-4FD7-912E-0C3AA4963C26')
insert @Map_IepDisabilityID values ('03 ', 'A1504419-19F6-434B-B4A3-1E5A69E99A9B')
insert @Map_IepDisabilityID values ('01 ', '8D0AA58F-597A-462F-B509-BB8F0B2AB593')
insert @Map_IepDisabilityID values ('04 ', '0E026822-6B22-43A1-BD6E-C1412E3A6FA3')
insert @Map_IepDisabilityID values ('08 ', '96A66C19-7AAB-4EE6-AA81-7CD8CD4FEB09')
insert @Map_IepDisabilityID values ('14 ', 'E65E6AAE-AE9B-4275-B547-9CE1A4B9EEF3')
insert @Map_IepDisabilityID values ('06 ', 'D31E4ED0-9A37-490F-B49B-FF18133644FE')

set nocount off;
update d set StateCode = m.StateCode
from @Map_IepDisabilityID m
join IepDisability d on m.DestID = d.ID
go

-- #############################################################################
--		Goal Area Def MAP
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_IepGoalAreaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_IepGoalAreaDefID
(
	GoalAreaCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)

ALTER TABLE LEGACYSPED.MAP_IepGoalAreaDefID ADD CONSTRAINT
PK_MAP_GoalAreaDefID PRIMARY KEY CLUSTERED
(
	GoalAreaCode
)

-- In FL EO deployments these are populated in the Prep_State file, but in CO Clarity they are populated via ETL.  Transform should work in both cases.

-- these IDs are exported with Enrich configuration for Colorado.  
-- Values from Clarity for APS do not at all match up with the IepGoalAreaDef values
--set nocount on;
--declare @ga table (GoalAreaCode varchar(20), DestID uniqueidentifier)
--insert @ga values ('BEEP', 'F7F042D5-885E-4BA0-B76D-C00C7C7988E3')
--insert @ga values ('BEPS', 'F7F042D5-885E-4BA0-B76D-C00C7C7988E3')
--insert @ga values ('TPIE', '8705E0BB-2CD9-498D-BB80-B54B2D2B9BF6')
--insert @ga values ('VOC', '8705E0BB-2CD9-498D-BB80-B54B2D2B9BF6')
--insert @ga values ('LAEX', '51C976DF-DC56-4F89-BCA1-E9AB6A01FBE7')
--insert @ga values ('LARL', '51C976DF-DC56-4F89-BCA1-E9AB6A01FBE7')
--insert @ga values ('SP', '51C976DF-DC56-4F89-BCA1-E9AB6A01FBE7')
--insert @ga values ('TPIIR', '6BBAADD8-BD9D-4C8F-A573-80F136B0A9FB')
--insert @ga values ('MA', '0E95D360-5CBE-4ECA-820F-CC25864D70D8')
--insert @ga values ('NM', '0E95D360-5CBE-4ECA-820F-CC25864D70D8')
--insert @ga values ('APE', 'D9260B1A-F268-4304-A22B-34A9D8001DE0')
--insert @ga values ('EC', 'D9260B1A-F268-4304-A22B-34A9D8001DE0')
--insert @ga values ('FM', 'D9260B1A-F268-4304-A22B-34A9D8001DE0')
--insert @ga values ('GMAP', 'D9260B1A-F268-4304-A22B-34A9D8001DE0')
--insert @ga values ('GMGC1', 'D9260B1A-F268-4304-A22B-34A9D8001DE0')
--insert @ga values ('GMPO2', 'D9260B1A-F268-4304-A22B-34A9D8001DE0')
--insert @ga values ('HHLD', 'D9260B1A-F268-4304-A22B-34A9D8001DE0')
--insert @ga values ('HLTH', 'D9260B1A-F268-4304-A22B-34A9D8001DE0')
--insert @ga values ('OMF', 'D9260B1A-F268-4304-A22B-34A9D8001DE0')
--insert @ga values ('VIS', 'D9260B1A-F268-4304-A22B-34A9D8001DE0')
--insert @ga values ('RD', '504CE0ED-537F-4EA0-BD97-0349FB1A4CA8')
--insert @ga values ('TPIC', '25D890C3-BCAE-4039-AC9D-2AE21686DEB0')
--insert @ga values ('BESI', '5050E2FA-7FF7-4910-8893-D354FFAF15C9')
--insert @ga values ('TPICP', 'D5976143-EE40-484F-B888-5D203452BDC9')
--insert @ga values ('TPIDL', 'D5976143-EE40-484F-B888-5D203452BDC9')
--insert @ga values ('TPIH', 'D5976143-EE40-484F-B888-5D203452BDC9')
--insert @ga values ('TPILA', 'D5976143-EE40-484F-B888-5D203452BDC9')
--insert @ga values ('TPIPS', 'D5976143-EE40-484F-B888-5D203452BDC9')
--insert @ga values ('TPISD', 'D5976143-EE40-484F-B888-5D203452BDC9')
--insert @ga values ('WL', '37EA0554-EC3F-4B95-AAD7-A52DECC7377C')


--insert LEGACYSPED.MAP_IepGoalAreaDefID 
--select ga.* from @ga ga where GoalAreaCode not in (select GoalAreaCode from LEGACYSPED.MAP_GoalAreaDefID)

END
GO

-- select * from iepgoalareadef




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

-- thse IDs are exported with Enrich configuration for Colorado.  This should be in the State config file
set nocount on;
declare @psa table (PostSchoolAreaCode varchar(20), DestID uniqueidentifier)
insert @psa values ('01', 'ADB5C7FD-C09F-41E3-9C0E-9AF403C741D1')
insert @psa values ('02', '823BA9DB-AF13-42BD-9CC2-EAA884701523')
insert @psa values ('03', '2B5D9C8A-7FA7-4E74-9F0C-53327209E751')

insert LEGACYSPED.MAP_PostSchoolAreaDefID
select * from @psa where PostSchoolAreaCode not in (select PostSchoolAreaCode from LEGACYSPED.MAP_PostSchoolAreaDefID)
END
GO

-- last line
