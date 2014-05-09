IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.Goal_LOCAL') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.Goal_LOCAL
GO
CREATE TABLE x_DATAVALIDATION.Goal_LOCAL(  
Line_No INT,
GoalRefID		  varchar(max),
IepRefID		  varchar(max),
Sequence		 varchar(max),
GoalAreaCode	varchar(max),
SCInstructional	varchar(max),
SCTransition	varchar(max),
SCRelatedService  varchar(max),
UNITOFMEASUREMENT varchar(max),
BASELINEDATAPOINT varchar(max),
EVALUATIONMETHOD varchar(max),
GoalStatement	varchar(max)
)
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.Goal') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.Goal
GO
CREATE TABLE x_DATAVALIDATION.Goal(
Line_No INT,  
GoalRefID		  varchar(150), 
IepRefID		  varchar(150), 
Sequence		  varchar(2),
GoalAreaCode		varchar(150),
SCInstructional	varchar(1),
SCTransition	varchar(1),
SCRelatedService varchar(1),
IsEsy		  varchar(1),
UNITOFMEASUREMENT VARCHAR(100),
BASELINEDATAPOINT VARCHAR(100),
EVALUATIONMETHOD VARCHAR(100),
GoalStatement	 varchar(8000)
)
GO