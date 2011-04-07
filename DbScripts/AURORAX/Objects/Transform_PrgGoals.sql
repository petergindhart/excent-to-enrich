IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.Transform_PrgGoals') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.Transform_PrgGoals
GO

CREATE VIEW AURORAX.Transform_PrgGoals
AS
	SELECT
		iep.IepRefId,
		DestID = sec.ID,
		ReportFrequencyID = cast(NULL as uniqueidentifier)
	FROM
	AURORAX.Transform_Iep iep JOIN
	PrgSection sec ON
		sec.VersionID = iep.VersionDestID AND
		sec.DefID = '84E5A67D-CC9A-4D5B-A7B8-C04E8C3B8E0A' --IEP Goals
GO
-- last line
