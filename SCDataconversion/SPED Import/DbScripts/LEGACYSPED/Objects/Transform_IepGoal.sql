----#include Transform_PrgGoal.sql
----#include Transform_IepGoalArea.sql
----#include Transform_IepGoalPostSchoolArea.sql

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepGoal') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_IepGoal
go

create view LEGACYSPED.Transform_IepGoal
as
select 
  ga.GoalRefID,
  DestID = ga.GoalID,
  GoalAreaID = ga.DestID,
  PostSchoolAreaDefID = psa.PostSchoolAreaDefID, 
  ga.EsyID 
FROM LEGACYSPED.Transform_IepGoalArea_goals ga LEFT JOIN 
	LEGACYSPED.Transform_IepGoalPostSchoolAreaDef psa on ga.GoalRefID = psa.GoalRefID and psa.Sequence = 0 LEFT JOIN ---------- we cheated!
	dbo.IepGoalArea tgt on ga.InstanceID = tgt.InstanceID and psa.PostSchoolAreaDefID = tgt.DefID 
go


