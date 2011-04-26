IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_PrgGoal]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_PrgGoal]
GO

CREATE VIEW [AURORAX].[Transform_PrgGoal]
AS
 SELECT
  g.GoalRefID,
  DestID = m.DestID,
  TypeID = cast('AB74929E-B03F-4A51-82CA-659CA90E291A'  as uniqueidentifier),
  InstanceID = i.DestID,   
  Sequence = (
	SELECT count(*)
	FROM AURORAX.Goal
	WHERE IepRefID = g.IepRefID AND
	Sequence < g.Sequence
	),
  IsProbeGoal = cast(0 as bit),   
  TargetDate = cast(NULL as datetime),   
  GoalStatement = cast(NULL as text),   
  ProbeTypeID = cast(NULL as uniqueidentifier),   
  NumericTarget = cast(0 as float),
  RubricTargetID = cast(NULL as uniqueidentifier),
  RatioPartTarget = cast(0 as float),
  RatioOutOfTarget = cast(0 as float),
  BaselineScoreID = cast(NULL as uniqueidentifier),
  IndDefID = cast(NULL as uniqueidentifier),
  IndTarget = cast(0 as float),
  ProbeScheduleID = cast(NULL as uniqueidentifier)
 FROM
  AURORAX.Goal g JOIN
  AURORAX.Transform_PrgGoals i on g.IepRefID = i.IepRefID LEFT JOIN
  AURORAX.MAP_PrgGoalID m on g.GoalRefID = m.GoalRefID LEFT JOIN
  dbo.PrgGoal pg on m.DestID = pg.ID
-- order by i.IepRefID, Sequence
GO
