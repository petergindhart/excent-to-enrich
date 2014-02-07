IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'LEGACYSPED.Transform_IepLeastRestrictiveEnvironment') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW LEGACYSPED.Transform_IepLeastRestrictiveEnvironment
GO

CREATE VIEW LEGACYSPED.Transform_IepLeastRestrictiveEnvironment
AS
	SELECT
		iep.IepRefId,
		iep.AgeGroup,
		iep.LRECode,
		DestID = sec.ID,
		MinutesInstruction = iep.MinutesPerWeek,
		iep.DoNotTouch
	FROM
		LEGACYSPED.Transform_PrgIep iep JOIN
		PrgSection sec ON
			sec.VersionID = iep.VersionDestID AND
			sec.DefID = '3727E5F0-762F-44D8-B303-068B99A90475'  --IEP LRE
	WHERE IEPRefID is not null -- Need to exclude NULL.  Found this when students that were imported previously were not imported subsequently
GO
-- 
