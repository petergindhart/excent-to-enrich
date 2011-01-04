IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[AURORAX].[Objective_Data_LOCAL]') AND type in (N'U'))
DROP TABLE [AURORAX].[Objective_Data_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[AURORAX].[Objective_Data]'))
DROP VIEW [AURORAX].[Objective_Data]
GO

CREATE TABLE [AURORAX].[Objective_Data_LOCAL](
ObjPKID    varchar(10)	not null, 
GoalPKID    varchar(10)	not null, 
SASID    varchar(20) not null, 
IEPPKID    varchar(10)	null, 
Sequence    varchar(3) null, 
ObjText    varchar(4000) null
)
GO

CREATE VIEW [AURORAX].[Objective_Data]
AS
	SELECT * FROM [AURORAX].[Objective_Data_LOCAL]
GO

-- #############################################################################

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'AURORAX.MAP_PrgGoalObjectiveID') AND type in (N'U'))
DROP TABLE AURORAX.MAP_PrgGoalObjectiveID
GO

CREATE TABLE AURORAX.MAP_PrgGoalObjectiveID (
ObjPKID INT not null,
DestID	uniqueidentifier not null
)
