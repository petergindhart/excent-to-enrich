
IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'LEGACYSPED.Goal'))  
DROP VIEW LEGACYSPED.Goal  
GO  

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.Goal_LOCAL') AND type in (N'U'))
BEGIN
CREATE TABLE LEGACYSPED.Goal_LOCAL(  
GoalRefID		  varchar(150), 
IepRefID		  varchar(150), 
Sequence		  varchar(2),
GAReading	varchar(1),
GAWriting	varchar(1),
GAMath		varchar(1),
GAOther		varchar(1),
GAEmotional		varchar(1),
GAIndependent		varchar(1),
GAHealth		varchar(1),
GACommunication		varchar(1),
PSInstruction 		varchar(1),
PSCommunity		varchar(1),
PSAdult		varchar(1),
PSVocational	varchar(1),
PSRelated	varchar(1),
PSEmployment	varchar(1),
PSDailyLiving	varchar(1),
IsEsy		  varchar(1),
GoalStatement		  varchar(8000)
)
END
GO

CREATE VIEW LEGACYSPED.Goal  
AS
 SELECT * FROM LEGACYSPED.Goal_LOCAL  
GO
--