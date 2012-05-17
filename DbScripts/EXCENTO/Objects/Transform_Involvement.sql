IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[Transform_Involvement]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[Transform_Involvement]
GO

CREATE VIEW EXCENTO.Transform_Involvement
AS

	SELECT
		iep.GStudentID,
		mt.DestID,
		stu.DestID [StudentID],
		ProgramID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C',
		VariantID = cast(NULL as uniqueidentifier),
		StartDate = MIN(sc.IEPInitDate),
		EndDate = CASE WHEN MAX(sc.IEPEndDate) > GETDATE() THEN NULL ELSE MAX(sc.IEPEndDate)END
	FROM
		EXCENTO.MAP_StudentID stu JOIN
		EXCENTO.IEPTbl iep ON iep.GStudentID = stu.GStudentID JOIN
		EXCENTO.IEPTbl_SC sc ON sc.IEPSeqNum = iep.IEPSeqNum JOIN
		StudentSchoolHistory sch ON sch.StudentID = stu.DestID AND dbo.DateInRange(sc.IEPInitDate, sch.StartDate, sch.EndDate) = 1 JOIN
		StudentGradeLevelHistory gl ON gl.StudentID = stu.DestID AND dbo.DateInRange(sc.IEPInitDate, gl.StartDate, gl.EndDate) = 1 LEFT JOIN
		EXCENTO.MAP_InvolvementID mt ON iep.GStudentID = mt.GStudentID
	WHERE
		iep.IEPComplete = 'IEPComplete'
	GROUP BY
		iep.GStudentID, stu.DestID, mt.DestID

GO