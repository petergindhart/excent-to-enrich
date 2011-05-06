IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_PrgGoalObjective]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_PrgGoalObjective]
GO

CREATE VIEW [AURORAX].[Transform_PrgGoalObjective]
AS
 SELECT
  m.ObjectiveRefID,
  DestID = cast(NULL as uniqueidentifier),
  GoalID = cast(NULL as uniqueidentifier),
  Sequence = cast(0 as int),
  Text = cast(o.ObjText as text)
 FROM
  AURORAX.Transform_PrgGoal g JOIN
  AURORAX.Objective o on g.GoalRefID = o.GoalRefID JOIN
  AURORAX.MAP_PrgGoalObjectiveID m on o.ObjectiveRefID = m.ObjectiveRefID LEFT JOIN
  dbo.PrgGoalObjective obj on m.DestID = obj.ID
GO
---