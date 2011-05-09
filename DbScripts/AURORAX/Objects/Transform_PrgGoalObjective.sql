IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_PrgGoalObjective]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_PrgGoalObjective]
GO

CREATE VIEW [AURORAX].[Transform_PrgGoalObjective]
AS
 SELECT
  o.ObjectiveRefID,
  DestID = m.DestID,
  GoalID = g.DestID,
  Sequence = (
	SELECT count(*)
	FROM AURORAX.Objective
	WHERE GoalRefID = g.GoalRefID AND
	Sequence < o.Sequence
	),
  Text = cast(o.ObjText as text)
 FROM
  AURORAX.Transform_PrgGoal g JOIN
  AURORAX.Objective o on g.GoalRefID = o.GoalRefID LEFT JOIN
  AURORAX.MAP_PrgGoalObjectiveID m on o.ObjectiveRefID = m.ObjectiveRefID LEFT JOIN
  dbo.PrgGoalObjective obj on m.DestID = obj.ID
GO
---