--#include Transform_Section.sql
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_LREPlacement]') AND OBJECTPROPERTY(id, N'IsView') = 1)
	DROP VIEW [EXCENTO].[Transform_LREPlacement]
GO

CREATE VIEW EXCENTO.Transform_LREPlacement
AS
	SELECT
		DestID = place.ID,
		InstanceID = sec.DestID,
		TypeID = placeMap.PlacementTypeID,
		OptionID = placeMap.DestID,
		IsEnabled = 0,
		IsDecOneCount = 0
	FROM
		EXCENTO.Transform_Iep iep JOIN
		EXCENTO.Transform_Section sec ON sec.ItemID = iep.DestID JOIN
		EXCENTO.Transform_LRE lre ON lre.DestID = sec.DestID JOIN
		EXCENTO.MAP_StudentID mStu ON mStu.DestID = iep.StudentID JOIN
		EXCENTO.IEPLRETbl lre01 ON lre01.GStudentID = mStu.GStudentID JOIN
		EXCENTO.IEPLRETbl_SC lre02 ON lre02.IEPLRESeqNum = lre01.IEPLRESeqNum JOIN
		(
			SELECT GStudentID, MAX(IEPLRESeqNum) [HighestSeqNum]
			FROM EXCENTO.IEPLRETbl
			GROUP BY GStudentID
		) lreLatest ON lre01.IEPLRESeqNum = lreLatest.HighestSeqNum JOIN
		EXCENTO.Map_PlacementOptionID placeMap ON
			( lre02.EdPlacement IN (1, 2, 3, 4, 6, 9, 10) AND lre02.EdPlacement = placeMap.EdPlacement ) OR 
			( lre02.EdPlacement = 8 AND lre02.HomeHosPlace = placeMap.HomeHosPlace ) OR 
			( lre02.EdPlacement IS NULL AND lre02.PrePlacement = placeMap.PrePlacement ) LEFT JOIN
		IepPlacement place ON lre.DestID = place.ID
	WHERE
		ISNULL(lre01.Del_Flag, 0) = 0 AND
		ISNULL(lre02.DeleteDate, 0) = 0
GO