IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_PrgGoals') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW LEGACYSPED.Transform_PrgGoals
GO

CREATE VIEW LEGACYSPED.Transform_PrgGoals
AS
	SELECT
		iep.IepRefId,
		DestID = sec.ID,
		ReportFrequencyID = isnull(gs.ReportFrequencyID, 'A3FF9417-0899-42BE-8090-D1855D50612F'), -- if PrgGoals.ReportFrequencyID exists, we MUST keep it
		UseProgressReporting = cast (1 as BIT),
		iep.DoNotTouch
	FROM
	LEGACYSPED.Transform_PrgIep iep JOIN -- 10721
	PrgSection sec ON
		sec.VersionID = iep.VersionDestID AND -- our map of PrgSection is using ItemID instead of VersionID.  Does that matter?
		sec.DefID = '84E5A67D-CC9A-4D5B-A7B8-C04E8C3B8E0A' left join --IEP Goals
	PrgGoals gs on sec.ID = gs.ID 
GO
--
