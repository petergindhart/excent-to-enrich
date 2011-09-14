IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.Objective_LOCAL') AND type in (N'U'))
DROP TABLE LEGACYSPED.Objective_LOCAL  
GO  
  
IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'LEGACYSPED.Objective'))  
DROP VIEW LEGACYSPED.Objective  
GO  
  
CREATE TABLE LEGACYSPED.Objective_LOCAL(  
  ObjectiveRefID	varchar(150)	not null,
  GoalRefID	varchar(150)	not null,
  Sequence	int,
  ObjText	varchar(8000)
)  
GO  
  
  
CREATE VIEW LEGACYSPED.Objective  
AS  
 SELECT * FROM LEGACYSPED.Objective_LOCAL  
GO
--