IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgGoals') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgGoals
GO

CREATE VIEW LEGACYSPED.Transform_PrgGoals
AS
	SELECT
		iep.IepRefId,
		DestID = sec.ID,
		ReportFrequencyID = isnull(pf.ID, 'A3FF9417-0899-42BE-8090-D1855D50612F'), -- if PrgGoals.ReportFrequencyID exists, we MUST keep it
		UseProgressReporting = cast (1 as BIT),
		iep.DoNotTouch
	FROM
	LEGACYSPED.Transform_PrgIep iep JOIN -- 10721
	PrgSection sec ON
		sec.VersionID = iep.VersionDestID AND -- our map of PrgSection is using ItemID instead of VersionID.  Does that matter?
		sec.DefID = 'A9DF977C-088E-47E8-9CEF-550D8A42AF58' left join --IEP Goals
	dbo.School h on iep.SchoolID = h.ID left join
	LEGACYSPED.SchoolProgressFrequency sf on h.Number = sf.SchoolCode left join 
	PrgGoalProgressFreq pf on sf.FrequencyName = pf.Name 
GO
--
