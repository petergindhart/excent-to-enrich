IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_GoalSchedule]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [AURORAX].[Transform_GoalSchedule]
GO

CREATE VIEW [AURORAX].[Transform_GoalSchedule]
AS
	SELECT 
		g.GoalPKID, 
		m.DestID
	FROM
		AURORAX.Goal_Data g LEFT JOIN
		AURORAX.MAP_GoalScheduleID m on g.GoalPKID = m.GoalPKID LEFT JOIN 
		dbo.Schedule s on m.DestID = s.ID 
GO
-- select * from [AURORAX].[Transform_GoalSchedule]
