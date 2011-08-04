
-- #############################################################################
-- School
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[MAP_SchoolRefID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [AURORAX].[MAP_SchoolRefID]
GO
CREATE TABLE [AURORAX].[MAP_SchoolRefID]
	(
	SchoolRefID varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE [AURORAX].[MAP_SchoolRefID] ADD CONSTRAINT
	[PK_MAP_SchoolRefID] PRIMARY KEY CLUSTERED
	(
	SchoolRefID
	) ON [PRIMARY]
GO

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
-- IepServiceCategory Map Table
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[MAP_IepServiceCategoryID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [AURORAX].[MAP_IepServiceCategoryID]
GO
CREATE TABLE AURORAX.[MAP_IepServiceCategoryID]
(
	SubType varchar(20) NOT NULL,
	DestID uniqueidentifier NOT NULL
)
GO

ALTER TABLE AURORAX.MAP_IepServiceCategoryID ADD CONSTRAINT
PK_MAP_IepServiceCategoryID PRIMARY KEY CLUSTERED
(
	SubType
)

-- #############################################################################
--		Service Frequency
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
--		SCHEDULE Frequency
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Map_ScheduleFrequencyID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.Map_ScheduleFrequencyID
GO

CREATE TABLE AURORAX.Map_ScheduleFrequencyID
(
	ServiceFrequencyCode	varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)
GO

ALTER TABLE AURORAX.Map_ScheduleFrequencyID ADD CONSTRAINT
PK_Map_ScheduleFrequencyID PRIMARY KEY CLUSTERED
(
	ServiceFrequencyCode
)
GO

CREATE INDEX IX_Map_ScheduleFrequencyID_ServiceFrequencyCode on AURORAX.Map_ScheduleFrequencyID (ServiceFrequencyCode)
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
-- Service Location
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_PrgLocationID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_PrgLocationID
GO

CREATE TABLE AURORAX.MAP_PrgLocationID
(
	Code varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
)
GO

ALTER TABLE AURORAX.MAP_PrgLocationID ADD CONSTRAINT
PK_MAP_PrgLocationID PRIMARY KEY CLUSTERED
(
	Code
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
--GO
CREATE TABLE AURORAX.MAP_IepDisabilityID
	(
	DisabilityCode nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	) 
--GO
ALTER TABLE AURORAX.MAP_IepDisabilityID ADD CONSTRAINT
	PK_MAP_IepDisabilityID PRIMARY KEY CLUSTERED
	(
	DisabilityCode
	)
--GO
*/

-- #############################################################################
-- LRE Placement OPTION
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[MAP_IepPlacementOptionID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [AURORAX].[MAP_IepPlacementOptionID]
GO
CREATE TABLE AURORAX.MAP_IepPlacementOptionID
(
	LRECode	varchar(150) NOT NULL,
	PlacementTypeID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
)
GO

ALTER TABLE AURORAX.MAP_IepPlacementOptionID ADD CONSTRAINT
PK_MAP_IepPlacementOptionID PRIMARY KEY CLUSTERED
(
	LRECode,
	PlacementTypeId,
	DestID
)
GO

CREATE INDEX IX_MAP_IepPlacementOptionID_PlacementTypeID_LRECode on AURORAX.Map_IepPlacementOptionID (PlacementTypeID, LRECode)
GO


-- #############################################################################
-- LRE Placement
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[MAP_IepPlacement]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [AURORAX].[MAP_IepPlacement]
GO
CREATE TABLE AURORAX.MAP_IepPlacement
(
	IepRefID	varchar(150) NOT NULL,
	TypeId uniqueidentifier not null,
	DestID uniqueidentifier NOT NULL -- this is the id of the iepplacement recod
)
GO

ALTER TABLE AURORAX.MAP_IepPlacement ADD CONSTRAINT
PK_MAP_IepPlacement PRIMARY KEY CLUSTERED
(
	IepRefID,
	TypeId
)
GO
-- select * from AURORAX.MAP_IepPlacement


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





-- Ethnicity (hand-coded and will not change, so no ETL required)
--insert AURORAX.MAP_EthnicityID values ('01', '5CCBE0AB-3D77-4E25-BD89-1DAA8EDC8236')
--insert AURORAX.MAP_EthnicityID values ('02', '33484F8E-72C5-4113-B31F-BA5E4E68DA84')
--insert AURORAX.MAP_EthnicityID values ('03', '7CA2E182-7402-4049-A547-A05912C73F28')
--insert AURORAX.MAP_EthnicityID values ('04', '49B39B32-FF45-49D9-B06C-A00F93B52490')
--insert AURORAX.MAP_EthnicityID values ('05', 'B6D5642A-36A4-44C7-AFAB-1B811FB4383B')



-- Service Frequency (hand-coded and will not change, so no ETL required)

--insert AURORAX.Map_ServiceFrequencyID (ServiceFrequencyCode, DestID) values ('01', 'A2080478-1A03-4928-905B-ED25DEC259E6')
--insert AURORAX.Map_ServiceFrequencyID (ServiceFrequencyCode, DestID) values ('02', '3D4B557B-0C2E-4A41-9410-BA331F1D20DD')
--insert AURORAX.Map_ServiceFrequencyID (ServiceFrequencyCode, DestID) values ('03', '5F3A2822-56F3-49DA-9592-F604B0F202C3')
--insert AURORAX.Map_ServiceFrequencyID (ServiceFrequencyCode, DestID) values ('AN', 'E2996A26-3DB5-42F3-907A-9F251F58AB09')
--insert AURORAX.Map_ServiceFrequencyID (ServiceFrequencyCode, DestID) values ('D', '71590A00-2C40-40FF-ABD9-E73B09AF46A1')
--insert AURORAX.Map_ServiceFrequencyID (ServiceFrequencyCode, DestID) values ('EST', 'E2996A26-3DB5-42F3-907A-9F251F58AB09')


