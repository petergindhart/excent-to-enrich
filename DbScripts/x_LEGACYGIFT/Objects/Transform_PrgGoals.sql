IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYGIFT.Transform_PrgGoals') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYGIFT.Transform_PrgGoals
GO

CREATE VIEW x_LEGACYGIFT.Transform_PrgGoals
AS
	SELECT
		iep.EPRefID,
		DestID = sec.ID,
		ReportFrequencyID = isnull(pf.ID, 'A3FF9417-0899-42BE-8090-D1855D50612F'), 
		UseProgressReporting = cast (1 as BIT) 
	FROM
	x_LEGACYGIFT.Transform_PrgItem iep JOIN 
	PrgSection sec ON
		sec.VersionID = iep.VersionDestID AND 
		sec.DefID = 'F9BCB1A3-D7D2-43E8-9B92-E269B80A2C62' left join --IEP Goals (at Polk)
	dbo.School h on iep.SchoolID = h.ID left join
	x_LEGACYGIFT.SchoolProgressFrequency sf on h.Number = sf.SchoolCode left join 
	PrgGoalProgressFreq pf on sf.FrequencyName = pf.Name 
GO
--
