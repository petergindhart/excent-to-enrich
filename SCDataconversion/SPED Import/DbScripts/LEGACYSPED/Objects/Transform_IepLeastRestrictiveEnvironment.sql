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
			sec.DefID = '0CBA436F-8043-4D22-8F3D-289E057F1AAB'  --IEP LRE
	WHERE IEPRefID is not null -- Need to exclude NULL.  Found this when students that were imported previously were not imported subsequently
GO
-- 
