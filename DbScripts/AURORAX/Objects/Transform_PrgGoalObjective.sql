IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_PrgGoalObjective]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_PrgGoalObjective]
GO

CREATE VIEW [AURORAX].[Transform_PrgGoalObjective]
AS
	SELECT 
		o.GoalPKID,
		o.ObjPKID,
		m.DestID, 
		GoalID = g.DestID, 
		Sequence = (
				SELECT count(*)
				FROM AURORAX.Objective_Data
				WHERE GoalPKID = o.GoalPKID AND
				isnull(Sequence, ObjPKID) < isnull(o.Sequence, o.ObjPKID)
			), 
		Text = o.ObjText
	FROM
		AURORAX.Transform_PrgGoal g JOIN
		AURORAX.Objective_Data o on g.GoalPKID = o.GoalPKID LEFT JOIN
		AURORAX.MAP_PrgGoalObjectiveID m on o.ObjPKID = m.ObjPKID LEFT JOIN
		dbo.PrgGoalObjective d on m.DestID = d.ID
GO
-- select * from AURORAX.Transform_PrgGoalObjective
