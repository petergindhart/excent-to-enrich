if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetInterventionTimeframe]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetInterventionTimeframe]
GO


CREATE FUNCTION dbo.GetInterventionTimeframe (@intervention uniqueidentifier)  
RETURNS TABLE
AS  

return (
		
	select 
		StartDate = min(StartDate),
		EndDate = dateadd(d, 7*4 /*=@PROJECTION_HILOW_MAX_FORCAST_IN_WEEKS*/,  max(EndDate))
	from (
			-- Plan start/end
			select
				StartDate,
				EndDate = isnull(PlannedEndDate, EndDate)
			from PrgItem 
			where ID = @intervention

			-- Probes associated with interventions
			union all
			select
				StartDate = min(DateTaken),
				EndDate = max(DateTaken)
			from
				IntvGoal g join
				PrgItem i on g.InterventionID = i.ID join
				ProbeType p on g.ProbeTypeID = p.ID join
				ProbeTime t on
					t.ProbeTypeID = p.ID and
					t.StudentID = i.StudentID and
					dbo.DateInRange(t.DateTaken, i.StartDate, isnull(i.EndDate, i.PlannedEndDate)) = 1
			where
				g.InterventionID = @intervention

			-- also include baseline scores
			union all
			select
				StartDate = min(DateTaken),
				EndDate = max(DateTaken)
			from
				IntvGoal g join
				ProbeScore ps on ps.ID = g.BaselineScoreID join
				ProbeTime pt on pt.ID = ps.ProbeTimeID
			where
				g.InterventionID = @intervention

			-- Plan activities
			union all
			select
				StartDate = min(StartDate),
				EndDate = max(StartDate)
			from PrgActivity a JOIN PrgItem i on i.ID = a.ID 
			where ItemID = @intervention
		) dates
)
GO

--  James Anderson
--select * from dbo.GetInterventionTimeframe('7d362883-5fcf-40b8-add3-38f536604249')
