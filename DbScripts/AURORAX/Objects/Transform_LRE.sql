IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_LRE]') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW [AURORAX].[Transform_LRE]
GO

CREATE VIEW AURORAX.Transform_LRE
AS
	SELECT
		iep.IepRefId,
		DestID = sec.ID,
		MinutesInstruction = iep.MinutesPerWeek
	FROM
		AURORAX.Transform_Iep iep JOIN
		PrgSection sec ON
			sec.VersionID = iep.VersionDestID AND
			sec.DefID = '0CBA436F-8043-4D22-8F3D-289E057F1AAB'  --IEP LRE
GO
-- 
