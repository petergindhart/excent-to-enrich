-- #############################################################################
-- Objective
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_PrgGoalObjectiveID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE AURORAX.MAP_PrgGoalObjectiveID
	(
	ObjectiveRefID nvarchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)

ALTER TABLE AURORAX.MAP_PrgGoalObjectiveID ADD CONSTRAINT
	PK_MAP_PrgGoalObjectiveID PRIMARY KEY CLUSTERED
	(
	ObjectiveRefID
	)
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_PrgGoalObjective]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_PrgGoalObjective]
GO

CREATE VIEW [AURORAX].[Transform_PrgGoalObjective]
AS
 SELECT
  o.ObjectiveRefID,
  DestID = m.DestID,
  TypeID = cast('4440EBD6-2AAD-4B78-9018-F52EC89A8D49'  as uniqueidentifier),
  InstanceID = g.InstanceID,
  Sequence = (
	SELECT count(*)
	FROM AURORAX.Objective
	WHERE GoalRefID = g.GoalRefID AND
	Sequence < o.Sequence
	),
  IsProbeGoal = cast(0 as bit),
  TargetDate = g.TargetDate,
  GoalStatement = cast(o.ObjText as text),
  ParentID = g.DestID
 FROM
  AURORAX.Transform_PrgGoal g JOIN
  AURORAX.Objective o on g.GoalRefID = o.GoalRefID LEFT JOIN
  AURORAX.MAP_PrgGoalObjectiveID m on o.ObjectiveRefID = m.ObjectiveRefID LEFT JOIN
  dbo.PrgGoal obj on m.DestID = obj.ID
GO
---
/*




*/


