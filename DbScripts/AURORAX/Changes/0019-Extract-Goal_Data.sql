IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[AURORAX].[Goal_Data_LOCAL]') AND type in (N'U'))
DROP TABLE [AURORAX].[Goal_Data_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[AURORAX].[Goal_Data]'))
DROP VIEW [AURORAX].[Goal_Data]
GO

CREATE TABLE [AURORAX].[Goal_Data_LOCAL](
GoalPKID    varchar(10) not null,
SASID    varchar(20) not null, 
IEPPKID    varchar(10) null, 
Sequence    varchar(3) null, 
GoalAreaCOde    varchar(10) null, 
PostSchoolAreaCode    varchar(10) null,
IsEsy    varchar(1) null, 
GoalStatement    varchar(4000) null
)
GO

CREATE VIEW [AURORAX].[Goal_Data]
AS
	SELECT * FROM [AURORAX].[Goal_Data_LOCAL]
GO

-- #############################################################################

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'AURORAX.MAP_PrgGoalID') AND type in (N'U'))
DROP TABLE AURORAX.MAP_PrgGoalID
GO

CREATE TABLE AURORAX.MAP_PrgGoalID (
GoalPKID INT not null,
DestID	uniqueidentifier not null
)


-- #############################################################################


IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'AURORAX.MAP_GoalScheduleID') AND type in (N'U'))
DROP TABLE AURORAX.MAP_GoalScheduleID
GO

CREATE TABLE AURORAX.MAP_GoalScheduleID (
GoalPKID INT not null,
DestID	uniqueidentifier not null
)
