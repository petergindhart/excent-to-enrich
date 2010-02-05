IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[QA_LrePlacement]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[QA_LrePlacement]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [EXCENTO].[QA_LrePlacement]
AS
	SELECT
		iep.IEPSeqNum, stu.GStudentID,
		sec.MinutesInstruction,
		pt.Name [PlacementType],
		po.Text [Placement]
	FROM
		EXCENTO.Transform_Iep iep JOIN
		EXCENTO.MAP_StudentID stu ON iep.StudentID = stu.DestID JOIN
		EXCENTO.Transform_Section secBase ON secBase.ItemID = iep.DestID JOIN
		-- replace [<section table>] below with table name in list
		[IepLeastRestrictiveEnvironment] sec ON sec.ID = secBase.DestID LEFT JOIN
		IepPlacement p on p.InstanceID = sec.ID LEFT JOIN
		IepPlacementType pt on p.TypeID = pt.ID LEFT JOIN
		IepPlacementOption po on p.OptionID = po.ID
GO

