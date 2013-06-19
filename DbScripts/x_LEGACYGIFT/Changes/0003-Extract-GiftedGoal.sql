
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.GiftedGoal_LOCAL') AND type in (N'U'))
DROP TABLE x_LEGACYGIFT.GiftedGoal_LOCAL
GO

CREATE TABLE x_LEGACYGIFT.GiftedGoal_LOCAL(
GoalRefID		  varchar(150) not null, 
EpRefID		  varchar(150), 
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
GO
alter table x_LEGACYGIFT.GiftedGoal_LOCAL 
add constraint PK_x_LEGACYGIFT_GiftedGoal_LOCAL_GoalRefID primary key (GoalRefID)
Go

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.GiftedGoal'))
DROP VIEW x_LEGACYGIFT.GiftedGoal
GO  

CREATE VIEW x_LEGACYGIFT.GiftedGoal
AS
 SELECT * FROM x_LEGACYGIFT.GiftedGoal_LOCAL
GO
--