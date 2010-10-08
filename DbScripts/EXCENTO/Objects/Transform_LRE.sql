IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_LRE]') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW [EXCENTO].[Transform_LRE]
GO

CREATE VIEW EXCENTO.Transform_LRE
AS
	SELECT
		DestID = sec.ID,
		MinutesInstruction = CAST(NULL AS INT)
	FROM
		EXCENTO.Transform_Iep iep JOIN
		PrgSection sec ON
			sec.VersionID = iep.VersionDestID AND
			sec.DefID = 'E34A618E-DC70-465D-84FE-3663D524B0F7' --IEP LRE
GO
