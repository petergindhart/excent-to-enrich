IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[AURORAX].[Objective_LOCAL]') AND type in (N'U'))
DROP TABLE [AURORAX].[Objective_LOCAL]  
GO  
  
IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[AURORAX].[Objective]'))  
DROP VIEW [AURORAX].[Objective]  
GO  
  
CREATE TABLE [AURORAX].[Objective_LOCAL](  
  ObjectiveRefID	varchar(150)	not null,
  GoalRefID	varchar(150)	not null,
  IepRefID	varchar(150)	not null,
  Sequence	int,
  ObjText	varchar(8000)
)  
GO  
  
  
CREATE VIEW [AURORAX].[Objective]  
AS  
 SELECT * FROM [AURORAX].[Objective_LOCAL]  
GO
--