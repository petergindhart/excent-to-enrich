--#include Transform_Section.sql
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[AURORAX].[Transform_LREPlacement]') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW [AURORAX].[Transform_LREPlacement]
GO

CREATE VIEW AURORAX.Transform_LREPlacement
AS
	SELECT
		DestID = lre.DestID,
		placeID = place.ID,
		InstanceID = sec.DestID,
		TypeID = isnull(placeMap.PlacementTypeID, 'D9D84E5B-45F9-4C72-8265-51A945CD0049'), -- cheating to avoid error where student LRE code does not map 
		OptionID = placeMap.DestID,
		IsEnabled = 0,
		IsDecOneCount = 0
	-- select * -- select iep.DestID iep_DestID, place.ID place_ID, sec.DestID sec_DestID, placeMap.PlacementTypeID placeMap_PlacementTypeID, placeMap.DestID placeMap_DestID, 0 IsEnabled, 0 IsDecOneCount
	FROM
		AURORAX.Transform_Iep iep JOIN
		AURORAX.Transform_Section sec ON sec.ItemID = iep.DestID JOIN
		AURORAX.Transform_LRE lre ON lre.DestID = sec.DestID JOIN
		-- AURORAX.MAP_StudentID mStu ON mStu.DestID = iep.StudentID JOIN
		AURORAX.IEP_Data lre01 ON lre01.IEPPKID = iep.IEPPKID LEFT JOIN -- to exclude students without LRE
		AURORAX.Map_PlacementOptionID placeMap ON lre01.LRE = placeMap.LRE LEFT JOIN
		IepPlacement place ON lre.DestID = place.ID
	where sec.DefID = '0CBA436F-8043-4D22-8F3D-289E057F1AAB'
GO

--select * from AURORAX.Transform_LREPlacement
--select * from AURORAX.LeastRestrictiveEnvironmentCode
--select * from AURORAX.Map_PlacementOptionID
--
--select * from AURORAX.Transform_Iep iep -- 1442 4 sec
--select * from AURORAX.Transform_Section sec -- 4326, 4 sec
--select * from AURORAX.Transform_LRE lre -- 1442, 4 sec
--select * from AURORAX.MAP_StudentID mStu -- 3816, 0 sec
--select * from AURORAX.Map_PlacementOptionID placeMap -- 15, 0 sec
--select * from IepPlacement place -- 0, 0 sec
--
--select *
--from AURORAX.MAP_StudentID mStu JOIN
--	AURORAX.Transform_Iep iep on mstu.SASID = iep.SASID JOIN
--	AURORAX.Transform_Section sec ON sec.ItemID = iep.DestID -- JOIN
--
--where sec.DefID = '89436456-BAB8-4B13-8C7D-F08A5860F959'
--
--select * from AURORAX.Map_IepID






