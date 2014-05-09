IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.Objective_LOCAL') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.Objective_LOCAL  
GO  
  
CREATE TABLE x_DATAVALIDATION.Objective_LOCAL( 
  Line_No INT, 
  ObjectiveRefID	varchar(max),
  GoalRefID	varchar(max),
  Sequence	varchar(max),
  ObjText	varchar(max)
)  
GO  	

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.Objective') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.Objective  
GO  
  
CREATE TABLE x_DATAVALIDATION.Objective( 
  Line_No INT, 
  ObjectiveRefID	varchar(150)	not null,
  GoalRefID	varchar(150)	not null,
  Sequence	int,
  ObjText	varchar(8000)
)  
GO  	