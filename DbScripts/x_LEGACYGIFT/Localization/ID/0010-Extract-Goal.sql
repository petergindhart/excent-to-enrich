
IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.GiftedGoal'))  
DROP VIEW x_LEGACYGIFT.GiftedGoal  
GO  
  
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.GiftedGoal_LOCAL') AND type in (N'U'))
BEGIN
CREATE TABLE x_LEGACYGIFT.GiftedGoal_LOCAL(  
GoalRefID		  varchar(150), 
EpRefID		  varchar(150), 
Sequence		  varchar(3),
GoalAreaCode		varchar(150),
PSEducation	varchar(1),
PSEmployment	varchar(1),
PSIndependent	varchar(1),
IsEsy		  varchar(1),
UNITOFMEASUREMENT VARCHAR(100),
BASELINEDATAPOINT VARCHAR(100),
EVALUATIONMETHOD VARCHAR(100),
GoalStatement		  varchar(8000)
)
END
GO


CREATE VIEW x_LEGACYGIFT.GiftedGoal  
AS
 SELECT * FROM x_LEGACYGIFT.GiftedGoal_LOCAL  
GO
--