--#include Transform_Section.sql
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_LREPlacement]') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW [AURORAX].[Transform_LREPlacement]
GO

CREATE VIEW AURORAX.Transform_LREPlacement
AS
	SELECT
		DestID = lre.DestID,
		InstanceID = sec.DestID,
		TypeID = isnull(placeMap.PlacementTypeID, 'D9D84E5B-45F9-4C72-8265-51A945CD0049'), -- cheating to avoid error where student LRE code does not map 
		OptionID = placeMap.DestID,
		IsEnabled = 0,
		IsDecOneCount = 0
	FROM
		AURORAX.Transform_Iep iep LEFT JOIN -- left join for speed (filter in where clause)
		AURORAX.Transform_Section sec ON sec.ItemID = iep.DestID JOIN -- and sec.DefID = '0CBA436F-8043-4D22-8F3D-289E057F1AAB' JOIN
		AURORAX.Transform_LRE lre ON lre.DestID = sec.DestID JOIN
		AURORAX.IEP lre01 ON lre01.IepRefID = iep.IepRefID JOIN 
		AURORAX.Map_PlacementOptionID placeMap ON lre01.LRECode = placeMap.LRECode LEFT JOIN
-- 	AURORAX.Map_PlacementOptionID placeMap ON lre.LRECode = placeMap.LRECode LEFT JOIN
		IepPlacement place ON lre.DestID = place.ID
	WHERE
		sec.DefID = '0CBA436F-8043-4D22-8F3D-289E057F1AAB'
GO
---