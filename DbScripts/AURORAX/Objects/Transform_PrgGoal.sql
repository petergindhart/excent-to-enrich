IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_PrgGoal]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_PrgGoal]
GO

CREATE VIEW [AURORAX].[Transform_PrgGoal]
AS
	SELECT 
		iep.IEPPKID,
		iep.SASID,
		g.GoalPKID,
		m.DestID, 
		TypeID = 'AB74929E-B03F-4A51-82CA-659CA90E291A', -- IEP Goal
		InstanceID = sec.DestID, -- PrgGoals.ID
		Sequence = (
				SELECT count(*)
				FROM AURORAX.Goal_Data
				WHERE IEPPKID = g.IEPPKID AND
				isnull(Sequence, GoalPKID) < isnull(g.Sequence, g.GoalPKID)
			), 
		IsProbeGoal = cast(1 as bit), -- imitating behavior of inserting a goal from UI
		TargetDate = iep.PlannedEndDate, -- assumption
		GoalStatement = cast(g.GoalStatement as text), 
		ProbeTypeID = cast(NULL as uniqueidentifier), -- Defaulted - this will be entered on the UI
		NumericTarget = cast(0 as float), -- Defaulted - this will be entered on the UI
		RubricTargetID = cast(NULL as uniqueidentifier), -- Defaulted - this will be entered on the UI
		RatioPartTarget = cast(0 as float), -- Defaulted - this will be entered on the UI
		RatioOutOfTarget = cast(0 as float), -- Defaulted - this will be entered on the UI
		BaselineScoreID = cast(NULL as uniqueidentifier), -- Defaulted - this will be entered on the UI
		IndDefID = cast(NULL as uniqueidentifier), -- Defaulted - this will be entered on the UI
		IndTarget = cast(0 as float), -- Defaulted - this will be entered on the UI
		-- May use this column to insert the schedule record through ETL (to imitate UI behavior).  Only Schedule.ID column required.
		ProbeScheduleID = s.DestID,
		-- These columns are for IepGoal as opposed to PrgGoal
		GoalAreaID = ga.DestID,
		PostSchoolAreaDefID = ps.DestID,
		EsyID = cast(NULL as uniqueidentifier) -- Find this then hard-code here with a case statement where isnull(IsEsy,0) = GUID for False, etc
	FROM
		AURORAX.Transform_Iep iep JOIN
		AURORAX.Transform_Section sec on 
			iep.VersionDestID = sec.VersionID AND
			sec.DefID = '84E5A67D-CC9A-4D5B-A7B8-C04E8C3B8E0A' JOIN
--		dbo.PrgGoals gs on sec.ID = gs.ID -- save a join
		AURORAX.Goal_Data g on iep.IEPPKID = g.IEPPKID LEFT JOIN
		AURORAX.MAP_PrgGoalID m on g.GoalPKID = m.GoalPKID LEFT JOIN
		dbo.PrgGoal d on m.DestID = d.ID LEFT JOIN 
		AURORAX.MAP_GoalScheduleID s on g.GoalPKID = s.GoalPKID LEFT JOIN -- since this is handled in a seperate transform it may not be needed here.
		-- For IepGoal
		AURORAX.MAP_IepGoalAreaID ga on g.GoalAreaCode = ga.GoalAreaCode LEFT JOIN
		AURORAX.MAP_IepPostSchoolAreaDefID ps on g.PostSchoolAreaCode = ps.PostSchoolAreaCode 
GO
-- select * from [AURORAX].[Transform_PrgGoal]
