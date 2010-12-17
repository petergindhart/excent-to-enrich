IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_LRE]') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW [AURORAX].[Transform_LRE]
GO

CREATE VIEW AURORAX.Transform_LRE
AS
	SELECT
		DestID = sec.ID,
		MinutesInstruction = CAST(NULL AS INT)
	FROM
		-- AURORAX.Transform_Iep iep JOIN
		PrgSection sec -- ON
--			sec.VersionID = iep.VersionDestID AND
--			sec.DefID = '89436456-BAB8-4B13-8C7D-F08A5860F959' -- LEFT JOIN --IEP LRE 
	WHERE sec.DefID = '0CBA436F-8043-4D22-8F3D-289E057F1AAB'  --IEP LRE
GO
-- last line

