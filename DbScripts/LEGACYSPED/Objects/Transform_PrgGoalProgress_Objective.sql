IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgGoalProgress_Objective') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgGoalProgress_Objective
go

create view LEGACYSPED.Transform_PrgGoalProgress_Objective
as
-- insert PrgGoalProgress (ID, GoalID, ReportPeriodID)
select ID = newid(), GoalID = o.ID, ReportPeriodID = p.ID 
from PrgGoals gs join 
PrgGoal g on gs.ID = g.InstanceID join 
IepGoal ig on g.ID = ig.ID join
PrgGoal o on g.ID = o.ParentID join
PrgGoalProgressPeriod p on gs.ReportFrequencyID = p.FrequencyID 
    and (case ig.EsyID when 'B76DDCD6-B261-4D46-A98E-857B0A814A0C' then 1 else 0 end = p.IsESY or p.IsESY = 0) 
    and dbo.DateInRangeAdvanced(p.Date, g.StartDate, g.TargetDate, 1) = 1
go
