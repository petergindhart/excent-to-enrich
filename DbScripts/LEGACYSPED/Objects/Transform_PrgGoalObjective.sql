-- #############################################################################
-- Objective
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.MAP_PrgGoalObjectiveID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE LEGACYSPED.MAP_PrgGoalObjectiveID
	(
	ObjectiveRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)

ALTER TABLE LEGACYSPED.MAP_PrgGoalObjectiveID ADD CONSTRAINT
	PK_MAP_PrgGoalObjectiveID PRIMARY KEY CLUSTERED
	(
	ObjectiveRefID
	)
END

if not exists (select 1 from sys.indexes where name = 'IX_LEGACYSPED_Objective_LOCAL_GoalRefID_Sequence')
CREATE NONCLUSTERED INDEX IX_LEGACYSPED_Objective_LOCAL_GoalRefID_Sequence ON [LEGACYSPED].[Objective_LOCAL] ([GoalRefID],[Sequence])

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgGoalObjective') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgGoalObjective
GO

CREATE VIEW LEGACYSPED.Transform_PrgGoalObjective
AS
 SELECT
  o.ObjectiveRefID,
  DestID = m.DestID,
  TypeID = cast('4440EBD6-2AAD-4B78-9018-F52EC89A8D49'  as uniqueidentifier),
  InstanceID = g.InstanceID,
  Sequence = (
	SELECT count(*)
	FROM LEGACYSPED.Objective
	WHERE GoalRefID = g.GoalRefID AND
	Sequence < o.Sequence
	),
  IsProbeGoal = cast(0 as bit),
  TargetDate = g.TargetDate,
  GoalStatement = cast(o.ObjText as text),
  ParentID = g.DestID,
  CrossVersionGoalID =( select top 1 ID from PrgCrossVersionGoal)
 FROM
  LEGACYSPED.Transform_PrgGoal g JOIN
  LEGACYSPED.Objective o on g.GoalRefID = o.GoalRefID LEFT JOIN
  LEGACYSPED.MAP_PrgGoalObjectiveID m on o.ObjectiveRefID = m.ObjectiveRefID LEFT JOIN
  dbo.PrgGoal obj on m.DestID = obj.ID
GO
---
