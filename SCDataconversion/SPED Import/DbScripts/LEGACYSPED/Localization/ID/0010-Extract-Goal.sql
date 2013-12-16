
IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'LEGACYSPED.Goal'))  
DROP VIEW LEGACYSPED.Goal  
GO  
  
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.Goal_LOCAL') AND type in (N'U'))
BEGIN
CREATE TABLE LEGACYSPED.Goal_LOCAL(  
GoalRefID		  varchar(150), 
IepRefID		  varchar(150), 
Sequence		  varchar(3),
GoalAreaCode		varchar(150),
PSEducation	varchar(1),
PSEmployment	varchar(1),
PSIndependent	varchar(1),
IsEsy		  varchar(1),
UnitOfMeasurement	varchar(100), 
BaselineDataPoint	varchar(100), 
EvaluationMethod	varchar(100),
GoalStatement		  varchar(8000)
)
END
GO
  
  
CREATE VIEW LEGACYSPED.Goal  
AS
 SELECT * FROM LEGACYSPED.Goal_LOCAL  
GO
--