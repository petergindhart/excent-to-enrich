IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_Iep]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_Iep]
GO

CREATE VIEW EXCENTO.Transform_Iep
AS

	SELECT
		iep.GStudentID,
		iep.IEPSeqNum,
		mt.DestID,
		DefID = '251DA756-A67A-453C-A676-3B88C1B9340C', -- IEP
		StudentID = stu.DestID,
		StartDate = sc.IEPInitDate,
		EndDate = CASE WHEN sc.IEPEndDate > GETDATE() THEN NULL ELSE sc.IEPEndDate END,
		CreatedDate = iep.CreateDate,
		CreatedBy = 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', -- BuiltIn: Support
		SchoolID = sch.SchoolID,
		GradeLevelID = gl.GradeLevelID,
		InvolvementID = inv.DestID,
		StartStatus = '3AC946C4-57CF-4C96-84A7-3FF5A40F33AA', -- Placed
		PlannedEndDate = sc.IEPEndDate,
		IsTransitional = CASE WHEN sc.TranServNeeds = 1 THEN 1 ELSE 0 END,
		VersionDestID = ver.DestID,
		VersionFinalizedDate = case when iep.IEPComplete = 'IEPComplete' THEN sc.IEPInitDate ELSE NULL END
	FROM
		EXCENTO.MAP_StudentID stu JOIN
		EXCENTO.IEPTbl iep ON iep.GStudentID = stu.GStudentID JOIN
		EXCENTO.IEPTbl_SC sc ON sc.IEPSeqNum = iep.IEPSeqNum JOIN
		StudentSchoolHistory sch ON sch.StudentID = stu.DestID AND dbo.DateInRange(sc.IEPInitDate, sch.StartDate, sch.EndDate) = 1 JOIN
		StudentGradeLevelHistory gl ON gl.StudentID = stu.DestID AND dbo.DateInRange(sc.IEPInitDate, gl.StartDate, gl.EndDate) = 1 LEFT JOIN
		EXCENTO.MAP_IepID mt ON iep.IEPSeqNum = mt.IEPSeqNum LEFT JOIN
		EXCENTO.MAP_InvolvementID inv ON iep.GStudentID = inv.GStudentID LEFT JOIN
		EXCENTO.Map_VersionID ver ON iep.IEPSeqNum = ver.IEPSeqNum
	WHERE
		iep.IEPComplete = 'IEPComplete' -- remove clause due to VersionFinalizedDate?
GO
-- last line