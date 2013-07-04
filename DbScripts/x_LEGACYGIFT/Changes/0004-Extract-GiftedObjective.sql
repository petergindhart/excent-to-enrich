
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.GiftedObjective_LOCAL') AND type in (N'U'))
DROP TABLE x_LEGACYGIFT.GiftedObjective_LOCAL
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'x_LEGACYGIFT.GiftedObjective'))
DROP VIEW x_LEGACYGIFT.GiftedObjective
GO  

CREATE TABLE x_LEGACYGIFT.GiftedObjective_LOCAL(
  ObjectiveRefID	varchar(150)	not null,
  GoalRefID	varchar(150)	not null,
  Sequence	int,
  ObjText	varchar(8000)
 )
GO
alter table x_LEGACYGIFT.GiftedObjective_LOCAL 
add constraint PK_x_LEGACYGIFT_GiftedObjective_LOCAL_ObjectiveRefID primary key (ObjectiveRefID)
Go

CREATE VIEW x_LEGACYGIFT.GiftedObjective
AS
 SELECT * FROM x_LEGACYGIFT.GiftedObjective_LOCAL
GO
--