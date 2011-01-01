-- #############################################################################
-- IepGoalAreaID
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'AURORAX.MAP_IepGoalAreaID') AND type in (N'U'))
DROP TABLE AURORAX.MAP_IepGoalAreaID
GO

CREATE TABLE AURORAX.MAP_IepGoalAreaID (
GoalAreaCode	varchar(10)	not null,
DestID		uniqueidentifier not null
)

ALTER TABLE AURORAX.MAP_IepGoalAreaID
	ADD CONSTRAINT PK_MAP_IepGoalAreaID
		PRIMARY KEY CLUSTERED (DestID)
GO

create index IX_MAP_IepGoalAreaID_GoalAreaCode on AURORAX.MAP_IepGoalAreaID (GoalAreaCode)
go

insert AURORAX.MAP_IepGoalAreaID values ('00', 'CFD77237-0E1D-4055-B557-AA6978B3A21B')
insert AURORAX.MAP_IepGoalAreaID values ('01', '504CE0ED-537F-4EA0-BD97-0349FB1A4CA8')
insert AURORAX.MAP_IepGoalAreaID values ('02', '37EA0554-EC3F-4B95-AAD7-A52DECC7377C')
insert AURORAX.MAP_IepGoalAreaID values ('03', '0E95D360-5CBE-4ECA-820F-CC25864D70D8')
go


-- IepPostSchoolGoalID
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'AURORAX.MAP_IepPostSchoolAreaDefID') AND type in (N'U'))
DROP TABLE AURORAX.MAP_IepPostSchoolAreaDefID
GO

CREATE TABLE AURORAX.MAP_IepPostSchoolAreaDefID (
PostSchoolAreaCode	varchar(10)	not null,
DestID		uniqueidentifier not null
)

ALTER TABLE AURORAX.MAP_IepPostSchoolAreaDefID
	ADD CONSTRAINT PK_MAP_IepPostSchoolAreaDefID
		PRIMARY KEY CLUSTERED (DestID)
GO

create index IX_MAP_IepPostSchoolAreaDefID_PostSchoolAreaCode on AURORAX.MAP_IepPostSchoolAreaDefID (PostSchoolAreaCode)
go

-- assuming that we need to map the codes and descriptions visually, in case of mispellings between Clarity and CO-Template
insert AURORAX.MAP_IepPostSchoolAreaDefID values ('10', 'ADB5C7FD-C09F-41E3-9C0E-9AF403C741D1')
insert AURORAX.MAP_IepPostSchoolAreaDefID values ('11', '823BA9DB-AF13-42BD-9CC2-EAA884701523')
insert AURORAX.MAP_IepPostSchoolAreaDefID values ('12', '2B5D9C8A-7FA7-4E74-9F0C-53327209E751')
go
