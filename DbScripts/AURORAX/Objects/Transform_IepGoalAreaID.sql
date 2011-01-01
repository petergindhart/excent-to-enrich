IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_IepGoalAreaID') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_IepGoalAreaID
GO

CREATE VIEW AURORAX.Transform_IepGoalAreaID
AS
select
	t.GoalAreaCode,
	t.DestID,
	t.Name,
	t.Sequence,
	t.AllowCustomProbes
from (
	SELECT
		m.GoalAreaCode,
		m.DestID,
		Sequence = cast(0 as int),
		Name = CONVERT(VARCHAR(100), 'No Goal Area Selected'),
		AllowCustomProbes = cast(0 as bit)
	FROM AURORAX.MAP_IepGoalAreaID m 
	WHERE GoalAreaCode = '00'
	UNION
	SELECT
		c.GoalAreaCode,
		m.DestID,
		Sequence = (
		 SELECT count(*)+1
		 FROM AURORAX.GoalAreaCode
		 WHERE isnull(Sequence, GoalAreaCode) < isnull(c.Sequence, c.GoalAreaCode)
		),
	  Name = convert(varchar(100), c.GoalAreaDescription),   AllowCustomProbes = cast(1 as bit)
	FROM
		AURORAX.GoalAreaCode c LEFT JOIN
		AURORAX.MAP_IepGoalAreaID m on c.GoalAreaCode = m.GoalAreaCode
	) t LEFT JOIN
	dbo.IepGoalArea ga on t.DestID = ga.ID
GO
