---- #############################################################################
---- GradeLevel Map Table
--IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Map_GradeLevelID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
--	DROP TABLE [AURORAX].[Map_GradeLevelID]
--GO
--CREATE TABLE AURORAX.[Map_GradeLevelID]
--(
--	Type varchar(20) NOT NULL,
--	SubType varchar(20) NOT NULL,
--	Code varchar(150) NOT NULL,
--	DestID uniqueidentifier NOT NULL
--)
--GO

--ALTER TABLE AURORAX.Map_GradeLevelID ADD CONSTRAINT
--PK_Map_GradeLevelID PRIMARY KEY CLUSTERED
--(
--	Type, SubType, Code
--)
--

-- #############################################################################
-- Student
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[MAP_StudentRefID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [AURORAX].[MAP_StudentRefID]
GO
CREATE TABLE [AURORAX].[MAP_StudentRefID]
	(
	StudentRefID varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE [AURORAX].[MAP_StudentRefID] ADD CONSTRAINT
	[PK_MAP_StudentRefID] PRIMARY KEY CLUSTERED
	(
	StudentRefID
	) ON [PRIMARY]
GO

-- #############################################################################
-- Involvement
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Map_InvolvementID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [AURORAX].[Map_InvolvementID]
GO
CREATE TABLE AURORAX.Map_InvolvementID
(
	StudentRefID varchar(150) NOT NULL ,
	DestID uniqueidentifier NOT NULL
)
GO
ALTER TABLE AURORAX.Map_InvolvementID ADD CONSTRAINT
PK_Map_InvolvementID PRIMARY KEY CLUSTERED
(
	StudentRefID
)
GO

-- #############################################################################
-- IEP
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Map_IepRefID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [AURORAX].[Map_IepRefID]
GO
CREATE TABLE AURORAX.Map_IepRefID
(
	IepRefID varchar(150) NOT NULL ,
	DestID uniqueidentifier NOT NULL
)
GO
ALTER TABLE AURORAX.Map_IepRefID ADD CONSTRAINT
PK_Map_IepRefID PRIMARY KEY CLUSTERED
(
	IepRefID
)
GO

-- #############################################################################
-- Version
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Map_VersionID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [AURORAX].[Map_VersionID]
GO
CREATE TABLE AURORAX.Map_VersionID
(
	IepRefID varchar(150) NOT NULL ,
	DestID uniqueidentifier NOT NULL
)
GO
ALTER TABLE AURORAX.Map_VersionID ADD CONSTRAINT
PK_Map_VersionID PRIMARY KEY CLUSTERED
(
	IepRefID
)
GO

-- #############################################################################
-- Section
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Map_SectionID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [AURORAX].[Map_SectionID]
GO
CREATE TABLE AURORAX.Map_SectionID
(
	VersionID uniqueidentifier NOT NULL,
	DefID uniqueidentifier NOT NULL,
	DestID uniqueidentifier
)
GO
ALTER TABLE AURORAX.Map_SectionID ADD CONSTRAINT
PK_Map_SectionID PRIMARY KEY CLUSTERED
(
	VersionID, DefID
)
GO

-- ########  Map tables below this line inserted with data (IDs) from Template DB IDs
-- ########  from Template DB by hand with IDs provided by client by comparing the respective descriptions

-- #############################################################################
-- Service Frequency
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Map_ServiceFrequencyID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.Map_ServiceFrequencyID
GO

CREATE TABLE AURORAX.Map_ServiceFrequencyID
(
	ServiceFrequencyCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)
GO

ALTER TABLE AURORAX.Map_ServiceFrequencyID ADD CONSTRAINT
PK_Map_ServiceFrequencyID PRIMARY KEY CLUSTERED
(
	ServiceFrequencyCode
)
GO

CREATE INDEX IX_Map_ServiceFrequencyID_ServiceFrequencyCode on AURORAX.Map_ServiceFrequencyID (ServiceFrequencyCode)
GO


-- #############################################################################
-- Service Provider Title
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_ServiceProviderTitleID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_ServiceProviderTitleID
GO

CREATE TABLE AURORAX.MAP_ServiceProviderTitleID
(
	ServiceProviderTitleCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)
GO

ALTER TABLE AURORAX.MAP_ServiceProviderTitleID ADD CONSTRAINT
PK_MAP_ServiceProviderTitleID PRIMARY KEY CLUSTERED
(
	ServiceProviderTitleCode
)
GO


-- #############################################################################
-- Service Definition
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Map_ServiceDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.Map_ServiceDefID
GO

CREATE TABLE AURORAX.Map_ServiceDefID
(
	ServiceDefCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)
GO

ALTER TABLE AURORAX.Map_ServiceDefID ADD CONSTRAINT
PK_Map_ServiceDefID PRIMARY KEY CLUSTERED
(
	ServiceDefCode, DestID
)
GO

CREATE INDEX IX_Map_ServiceDefID_ServiceDefCode on AURORAX.Map_ServiceDefID (ServiceDefCode)
GO

-- Service Definition STATIC (this is mapped once in LoadMaps and not touched afterward, since there is no other way to identify hard-mapped records).
-- This map will be important in the transform view.
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Map_ServiceDefIDstatic') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.Map_ServiceDefIDstatic
GO

CREATE TABLE AURORAX.Map_ServiceDefIDstatic
(
	ServiceDefCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)
GO

ALTER TABLE AURORAX.Map_ServiceDefIDstatic ADD CONSTRAINT
PK_Map_ServiceDefIDstatic PRIMARY KEY CLUSTERED
(
	ServiceDefCode, DestID
)
GO

CREATE INDEX IX_Map_ServiceDefIDstatic_ServiceDefCode on AURORAX.Map_ServiceDefIDstatic (ServiceDefCode)
GO

/*
-- #############################################################################
-- Disability
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_IepDisabilityID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_IepDisabilityID
GO
CREATE TABLE AURORAX.MAP_IepDisabilityID
	(
	DisabilityCode nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	) 
GO
ALTER TABLE AURORAX.MAP_IepDisabilityID ADD CONSTRAINT
	PK_MAP_IepDisabilityID PRIMARY KEY CLUSTERED
	(
	DisabilityCode
	)
GO
*/

-- #############################################################################
-- LRE Placement
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Map_PlacementOptionID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [AURORAX].[Map_PlacementOptionID]
GO
CREATE TABLE AURORAX.Map_PlacementOptionID
(
	LRECode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL,
	PlacementTypeID uniqueidentifier NOT NULL
)
GO

ALTER TABLE AURORAX.Map_PlacementOptionID ADD CONSTRAINT
PK_Map_PlacementOptionID PRIMARY KEY CLUSTERED
(
	LRECode,
	DestID
)
GO

CREATE INDEX IX_Map_PlacementOptionID_LRECode on AURORAX.Map_PlacementOptionID (LRECode)
GO


-- #############################################################################
-- Ethnicity (though this table will not be used as other MAP tables, it imitates the same usage and will make the Transform view code simpler).
-- Do not use ETL delete
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_EthnicityID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_EthnicityID
GO

CREATE TABLE AURORAX.MAP_EthnicityID
	(
	EthnicityCode nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)
GO
ALTER TABLE AURORAX.MAP_EthnicityID ADD CONSTRAINT
	PK_MAP_IepEthnicityID PRIMARY KEY CLUSTERED
	(
	EthnicityCode
	)
GO


-- #############################################################################
-- OrgUnit Only one match will exist - that of the one district record in Enrich.  How to handle this for non-Enrich customers?
-- Do not use ETL delete
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_OrgUnit') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_OrgUnit
GO

CREATE TABLE AURORAX.MAP_OrgUnit
	(
	DistrictRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)
GO
ALTER TABLE AURORAX.MAP_OrgUnit ADD CONSTRAINT
	PK_MAP_OrgUnit PRIMARY KEY CLUSTERED
	(
	DistrictRefID
	)
GO



-- #############################################################################
-- ExitReason
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[MAP_OutcomeID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [AURORAX].[MAP_OutcomeID]
GO
CREATE TABLE [AURORAX].[MAP_OutcomeID]
	(
	ExitReason varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE [AURORAX].[MAP_OutcomeID] ADD CONSTRAINT
	[PK_MAP_OutcomeID] PRIMARY KEY CLUSTERED
	(
	ExitReason
	) ON [PRIMARY]
GO

-- #############################################################################
-- ServicePlan
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_ServicePlanID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_ServicePlanID
GO
CREATE TABLE AURORAX.MAP_ServicePlanID
	(
	ServiceRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	) 
GO
ALTER TABLE AURORAX.MAP_ServicePlanID ADD CONSTRAINT
	PK_MAP_ServicePlanID PRIMARY KEY CLUSTERED
	(
	ServiceRefID
	)
GO

-- #############################################################################
-- Service Location
-- static table for those values that are already in CO-template at time of developement - using static map to prevent deleting with ETL code
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_ServiceLocationIDstatic') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_ServiceLocationIDstatic
GO

CREATE TABLE AURORAX.MAP_ServiceLocationIDstatic
	(
	ServiceLocationCode nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)
GO
ALTER TABLE AURORAX.MAP_ServiceLocationIDstatic ADD CONSTRAINT
	PK_MAP_ServiceLocationIDstatic PRIMARY KEY CLUSTERED
	(
	ServiceLocationCode
	)
GO



IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_ServiceLocationID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_ServiceLocationID
GO

CREATE TABLE AURORAX.MAP_ServiceLocationID
	(
	ServiceLocationCode nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)
GO
ALTER TABLE AURORAX.MAP_ServiceLocationID ADD CONSTRAINT
	PK_MAP_ServiceLocationID PRIMARY KEY CLUSTERED
	(
	ServiceLocationCode
	)
GO


-- #############################################################################
-- Goal
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_PrgGoalID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_PrgGoalID
GO

CREATE TABLE AURORAX.MAP_PrgGoalID
	(
	GoalRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)
GO

ALTER TABLE AURORAX.MAP_PrgGoalID ADD CONSTRAINT
	PK_MAP_PrgGoalID PRIMARY KEY CLUSTERED
	(
	GoalRefID
	)
GO

-- #############################################################################
-- Post School Goal Area
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_PostSchoolGoalAreaDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_PostSchoolGoalAreaDefID
GO

CREATE TABLE AURORAX.MAP_PostSchoolGoalAreaDefID
	(
	PostSchoolAreaID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)
GO

ALTER TABLE AURORAX.MAP_PostSchoolGoalAreaDefID ADD CONSTRAINT
	PK_MAP_PostSchoolGoalAreaDefID PRIMARY KEY CLUSTERED
	(
	PostSchoolAreaID
	)
GO

-- #############################################################################
-- Objective
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_PrgGoalObjectiveID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_PrgGoalObjectiveID
GO

CREATE TABLE AURORAX.MAP_PrgGoalObjectiveID
	(
	ObjectiveRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)
GO

ALTER TABLE AURORAX.MAP_PrgGoalObjectiveID ADD CONSTRAINT
	PK_MAP_PrgGoalObjectiveID PRIMARY KEY CLUSTERED
	(
	ObjectiveRefID
	)
GO

-- #############################################################################
-- Service
CREATE TABLE AURORAX.MAP_IepServiceID
	(
	ServiceRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)
GO
ALTER TABLE AURORAX.MAP_IepServiceID ADD CONSTRAINT
	PK_MAP_IepServiceID PRIMARY KEY CLUSTERED
	(
	ServiceRefID
	)
GO

-- #############################################################################
-- Schedule
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_ScheduleID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_ScheduleID
GO

CREATE TABLE AURORAX.MAP_ScheduleID
	(
	ServiceRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)
GO
ALTER TABLE AURORAX.MAP_ScheduleID ADD CONSTRAINT
	PK_MAP_ScheduleID PRIMARY KEY CLUSTERED
	(
	ServiceRefID
	)
GO




set nocount on;
-- OrgUnit (District)
insert AURORAX.MAP_OrgUnit (DistrictRefID, DestID) values ('73008CCD-1BFB-489C-BDFE-955AA27DDE34', '6531EF88-352D-4620-AF5D-CE34C54A9F53')


-- Ethnicity (hand-coded and will not change, so no ETL required)
insert AURORAX.MAP_EthnicityID values ('01', '5CCBE0AB-3D77-4E25-BD89-1DAA8EDC8236')
insert AURORAX.MAP_EthnicityID values ('02', '33484F8E-72C5-4113-B31F-BA5E4E68DA84')
insert AURORAX.MAP_EthnicityID values ('03', '7CA2E182-7402-4049-A547-A05912C73F28')
insert AURORAX.MAP_EthnicityID values ('04', '49B39B32-FF45-49D9-B06C-A00F93B52490')
insert AURORAX.MAP_EthnicityID values ('05', 'B6D5642A-36A4-44C7-AFAB-1B811FB4383B')

-- LRE (hand-coded and will not change, so no ETL required)
INSERT AURORAX.Map_PlacementOptionID VALUES('204', '0B2E63D7-6493-44A7-95B1-8DF327D77C38', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC')
INSERT AURORAX.Map_PlacementOptionID VALUES('205', '2E45FDA2-0767-43D0-892D-D1BB40AFCEC1', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC')
INSERT AURORAX.Map_PlacementOptionID VALUES('206', '0DA48AA5-183C-4434-91C1-AC3C9941BE15', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC')
INSERT AURORAX.Map_PlacementOptionID VALUES('207', '0980382F-594C-453F-A0C9-77D54A0443B1', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC')
INSERT AURORAX.Map_PlacementOptionID VALUES('208', '1945D36A-8D62-4FDB-9F22-5836F553A958', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC')
INSERT AURORAX.Map_PlacementOptionID VALUES('301', 'FEFF9910-F320-4097-AFC2-A3D9713470BD', 'D9D84E5B-45F9-4C72-8265-51A945CD0049')
INSERT AURORAX.Map_PlacementOptionID VALUES('302', '521ACE5E-D04B-4E30-80E3-517516383536', 'D9D84E5B-45F9-4C72-8265-51A945CD0049')
INSERT AURORAX.Map_PlacementOptionID VALUES('303', '9CD2726E-6461-4F6C-B65F-B4232FB4D36E', 'D9D84E5B-45F9-4C72-8265-51A945CD0049')
INSERT AURORAX.Map_PlacementOptionID VALUES('304', '77E0EE80-143B-41E5-84B9-5076605CCC9A', 'D9D84E5B-45F9-4C72-8265-51A945CD0049')
INSERT AURORAX.Map_PlacementOptionID VALUES('305', 'E4EE85F2-8307-4C8D-BA77-4EB5D12D8470', 'D9D84E5B-45F9-4C72-8265-51A945CD0049')
INSERT AURORAX.Map_PlacementOptionID VALUES('306', '91EF0ECE-A770-4D05-8868-F19180A000DB', 'D9D84E5B-45F9-4C72-8265-51A945CD0049')
-- INSERT AURORAX.Map_PlacementOptionID VALUES('306', '5EE0CA16-1F59-4BC8-9AFA-BAED97D29B77', 'D9D84E5B-45F9-4C72-8265-51A945CD0049')
-- INSERT AURORAX.Map_PlacementOptionID VALUES('306', 'D634CD6A-C22F-4B34-89A8-340A13891E24', 'D9D84E5B-45F9-4C72-8265-51A945CD0049')
INSERT AURORAX.Map_PlacementOptionID VALUES('307', '84DAF081-F700-4F57-99DA-A2A983FDE919', 'D9D84E5B-45F9-4C72-8265-51A945CD0049')
INSERT AURORAX.Map_PlacementOptionID VALUES('308', '304AEBA5-3162-4B40-89D3-F094602CFF2D', 'D9D84E5B-45F9-4C72-8265-51A945CD0049')

-- added after the fact because we had some students with these codes, apparently inactive students
INSERT AURORAX.Map_PlacementOptionID VALUES('209', 'DC20B53C-0559-44F6-A463-3A92D9D4F69A', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC')
INSERT AURORAX.Map_PlacementOptionID VALUES('210', 'DC20B53C-0559-44F6-A463-3A92D9D4F69A', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC')
INSERT AURORAX.Map_PlacementOptionID VALUES('211', 'DC20B53C-0559-44F6-A463-3A92D9D4F69A', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC')
INSERT AURORAX.Map_PlacementOptionID VALUES('212', 'DC20B53C-0559-44F6-A463-3A92D9D4F69A', 'E47FBA7F-8EB0-4869-89DF-9DD3456846EC')

-- made these school age placement options although it is possible there are some students under 6yo with these coddes
INSERT AURORAX.Map_PlacementOptionID VALUES('000', 'B0091A53-FEBE-44FB-8D15-4ED6728B03B4', 'D9D84E5B-45F9-4C72-8265-51A945CD0049')
INSERT AURORAX.Map_PlacementOptionID VALUES('DNQ', '75AC7101-1F19-439D-8898-DDF6B310AA7A', 'D9D84E5B-45F9-4C72-8265-51A945CD0049')

-- these did not exist in IepPlacementOption (and maybe should not).  we are adding them here to avoid messing with more dynamic ETL
insert IepPlacementOption (ID, TypeID, Sequence, Text) values ('B0091A53-FEBE-44FB-8D15-4ED6728B03B4', 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 8, 'None')
insert IepPlacementOption (ID, TypeID, Sequence, Text) values ('75AC7101-1F19-439D-8898-DDF6B310AA7A', 'D9D84E5B-45F9-4C72-8265-51A945CD0049', 9, 'Did not qualify')

/*
-- Disability
insert AURORAX.MAP_IepDisabilityID values ('01', '8D0AA58F-597A-462F-B509-BB8F0B2AB593')
insert AURORAX.MAP_IepDisabilityID values ('03', 'A1504419-19F6-434B-B4A3-1E5A69E99A9B')
insert AURORAX.MAP_IepDisabilityID values ('04', '0E026822-6B22-43A1-BD6E-C1412E3A6FA3')
insert AURORAX.MAP_IepDisabilityID values ('05', '79450790-72A4-4F16-8840-6193DB199A1E')
insert AURORAX.MAP_IepDisabilityID values ('06', 'D31E4ED0-9A37-490F-B49B-FF18133644FE')
insert AURORAX.MAP_IepDisabilityID values ('07', '07093979-0C3F-414D-9750-8080C6BB7C45')
insert AURORAX.MAP_IepDisabilityID values ('08', '96A66C19-7AAB-4EE6-AA81-7CD8CD4FEB09')
insert AURORAX.MAP_IepDisabilityID values ('10', 'CA41A561-16BE-4E21-BE8A-BC59ED86C921')
insert AURORAX.MAP_IepDisabilityID values ('11', 'B0439371-3A5E-4FD7-912E-0C3AA4963C26')
insert AURORAX.MAP_IepDisabilityID values ('13', '8D9B3B54-4080-4D5E-A196-956D5223E479')
insert AURORAX.MAP_IepDisabilityID values ('14', 'E65E6AAE-AE9B-4275-B547-9CE1A4B9EEF3')
-- (note:  at time of this coding, the following records did not have a corresponding row in IepDisability (from the CO-Template database):
insert AURORAX.MAP_IepDisabilityID values ('09', 'CAFC7172-946C-4B6B-BC5E-2FC67F215C8D')
insert AURORAX.MAP_IepDisabilityID values ('12', '36B1ED81-4230-480C-BFCA-E17CFDEBB70D')
insert AURORAX.MAP_IepDisabilityID values ('15', 'E569D304-377A-4E82-8261-D7046B8DC294')
insert AURORAX.MAP_IepDisabilityID values ('16', '8AFF29C4-A480-4AE2-BBDC-DDE429FFEB03')
-- the above 4 GUIDS are maintained here.
*/

-- Service Frequency (hand-coded and will not change, so no ETL required)
insert AURORAX.Map_ServiceFrequencyID values ('01', 'A2080478-1A03-4928-905B-ED25DEC259E6')
insert AURORAX.Map_ServiceFrequencyID values ('02', '3D4B557B-0C2E-4A41-9410-BA331F1D20DD')
insert AURORAX.Map_ServiceFrequencyID values ('03', '5F3A2822-56F3-49DA-9592-F604B0F202C3')
insert AURORAX.MAP_ServiceFrequencyID values ('AN', 'E2996A26-3DB5-42F3-907A-9F251F58AB09')
insert AURORAX.Map_ServiceFrequencyID values ('D', '71590A00-2C40-40FF-ABD9-E73B09AF46A1')
insert AURORAX.MAP_ServiceFrequencyID values ('ESY', 'E2996A26-3DB5-42F3-907A-9F251F58AB09')


-- Service Def ID (static MAP)
insert AURORAX.Map_ServiceDefIDstatic (ServiceDefCode, DestID) values ('SvcRelAT', '8C054380-B22F-4D2A-98DE-568498E06EAB')
insert AURORAX.Map_ServiceDefIDstatic (ServiceDefCode, DestID) values ('SvcRelATI', '8C054380-B22F-4D2A-98DE-568498E06EAB')
insert AURORAX.Map_ServiceDefIDstatic (ServiceDefCode, DestID) values ('SvcRelAUDI', '7157C518-6040-4ACF-9096-9793519D7B42')
insert AURORAX.Map_ServiceDefIDstatic (ServiceDefCode, DestID) values ('SvcRelAUD', '7157C518-6040-4ACF-9096-9793519D7B42')
insert AURORAX.Map_ServiceDefIDstatic (ServiceDefCode, DestID) values ('SvcSped01', '9DE4CBF9-BD8D-490C-8E1B-34F5E73DEF11')
insert AURORAX.Map_ServiceDefIDstatic (ServiceDefCode, DestID) values ('SvcSped04', '9DE4CBF9-BD8D-490C-8E1B-34F5E73DEF11')
insert AURORAX.Map_ServiceDefIDstatic (ServiceDefCode, DestID) values ('SvcRelOT', 'B874A136-2F0E-4955-AA1E-1F0D45F263FB')
insert AURORAX.Map_ServiceDefIDstatic (ServiceDefCode, DestID) values ('SvcRelOTI', 'B874A136-2F0E-4955-AA1E-1F0D45F263FB')
insert AURORAX.Map_ServiceDefIDstatic (ServiceDefCode, DestID) values ('SvcRelOM', '9362532B-A768-41E7-8E99-9BB899948DBC')
insert AURORAX.Map_ServiceDefIDstatic (ServiceDefCode, DestID) values ('SvcRelPT', '73107912-4959-4137-910B-B17E52076074')
insert AURORAX.Map_ServiceDefIDstatic (ServiceDefCode, DestID) values ('SvcRelPTI', '73107912-4959-4137-910B-B17E52076074')
insert AURORAX.Map_ServiceDefIDstatic (ServiceDefCode, DestID) values ('SvcRelPSY', '7BBAAB01-398D-4835-B4B0-13D543FAC564')
insert AURORAX.Map_ServiceDefIDstatic (ServiceDefCode, DestID) values ('SvcRelPSYI', '7BBAAB01-398D-4835-B4B0-13D543FAC564')
insert AURORAX.Map_ServiceDefIDstatic (ServiceDefCode, DestID) values ('SvcRelNUR', '75D07F63-F586-4C55-8FDE-A5B6D0737157')
insert AURORAX.Map_ServiceDefIDstatic (ServiceDefCode, DestID) values ('SvcRelNURI', '75D07F63-F586-4C55-8FDE-A5B6D0737157')
insert AURORAX.Map_ServiceDefIDstatic (ServiceDefCode, DestID) values ('SvcRelSW', 'C6BF0D48-6C01-456A-8661-227903696CA5')
insert AURORAX.Map_ServiceDefIDstatic (ServiceDefCode, DestID) values ('SvcRelSWI', 'C6BF0D48-6C01-456A-8661-227903696CA5')
insert AURORAX.Map_ServiceDefIDstatic (ServiceDefCode, DestID) values ('SvcRelSLP', 'BF859DEF-67A2-4285-A871-E80315AF3BD5')
insert AURORAX.Map_ServiceDefIDstatic (ServiceDefCode, DestID) values ('SvcRelSPCI', 'BF859DEF-67A2-4285-A871-E80315AF3BD5')

insert AURORAX.Map_ServiceDefID (ServiceDefCode, DestID)
select ServiceDefCode, DestID from AURORAX.Map_ServiceDefIDstatic


-- Service Location
insert AURORAX.MAP_ServiceLocationIDstatic values ('01', '27D86DFE-218E-4E1B-A6DB-8B8E74D6F8BA')
insert AURORAX.MAP_ServiceLocationIDstatic values ('04', '465C097B-DEC0-4E20-ACDC-2ACF9E7F5DEF')
insert AURORAX.MAP_ServiceLocationIDstatic values ('05', '2D48D839-511D-4CBA-9E72-BDE1348EDCFB')
insert AURORAX.MAP_ServiceLocationIDstatic values ('06', '7A691C77-B4D6-4D4D-8A29-131FC1E7A33A')
insert AURORAX.MAP_ServiceLocationIDstatic values ('18', '701DF30A-7C66-423D-9796-DE5B5CB97139')
insert AURORAX.MAP_ServiceLocationIDstatic values ('20', 'B1DA5BF5-325B-496F-A0B2-4AEAA6085C64')
insert AURORAX.MAP_ServiceLocationIDstatic values ('21', 'E9DD5433-BC4C-4817-BF1D-A0B9203BAB8B')
insert AURORAX.MAP_ServiceLocationIDstatic values ('24', '8FC37445-260F-4185-8E43-F5EC8AFCDDB3')
insert AURORAX.MAP_ServiceLocationIDstatic values ('COM', '8FC37445-260F-4185-8E43-F5EC8AFCDDB3')
insert AURORAX.MAP_ServiceLocationIDstatic values ('HOM', '7A691C77-B4D6-4D4D-8A29-131FC1E7A33A')
insert AURORAX.MAP_ServiceLocationIDstatic values ('SUM', '27D86DFE-218E-4E1B-A6DB-8B8E74D6F8BA')

insert AURORAX.MAP_ServiceLocationID (ServiceLocationCode, DestID)
select ServiceLocationCode, DestID from AURORAX.MAP_ServiceLocationIDstatic


-- Post School Area Goal Definition
insert AURORAX.MAP_PostSchoolGoalAreaDefID values ('01', 'ADB5C7FD-C09F-41E3-9C0E-9AF403C741D1')
insert AURORAX.MAP_PostSchoolGoalAreaDefID values ('02', '823BA9DB-AF13-42BD-9CC2-EAA884701523')
insert AURORAX.MAP_PostSchoolGoalAreaDefID values ('03', '2B5D9C8A-7FA7-4E74-9F0C-53327209E751')


