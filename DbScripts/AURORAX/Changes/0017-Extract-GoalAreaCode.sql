IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[AURORAX].[GoalAreaCode_LOCAL]') AND type in (N'U'))
DROP TABLE [AURORAX].[GoalAreaCode_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[AURORAX].[GoalAreaCode]'))
DROP VIEW [AURORAX].[GoalAreaCode]
GO

CREATE TABLE [AURORAX].[GoalAreaCode_LOCAL](
GoalAreaCode			varchar(10)	not null,
GoalAreaDescription	varchar(100)	not null,
Sequence					int				NULL
)
GO

CREATE VIEW [AURORAX].[GoalAreaCode]
AS
	SELECT * FROM [AURORAX].[GoalAreaCode_LOCAL]
GO
