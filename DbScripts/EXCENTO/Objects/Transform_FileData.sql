IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].Transform_FileData') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].Transform_FileData
GO

CREATE VIEW EXCENTO.Transform_FileData
AS
	SELECT
		d.RecNum,
		m.DestID,
		OriginalName = 'C:\Blah.pdf', 
		ReceivedDate = IEPCompleteDate, 
		MimeType = 'document\pdf', 
		[Content] =  d.PDFImage, 
		IsTemporary = 0,
		DocItemID = iep.DestID, 
		DocVersionID = iep.VersionDestID
	FROM
		EXCENTO.Transform_Iep iep JOIN
		EXCENTO.IEPArchiveDocTbl d on d.GStudentID = iep.GStudentID LEFT JOIN
		EXCENTO.MAP_FileDataID m on d.RecNum = m.RecNum
	WHERE d.RecNum = (
		SELECT max(dIn.RecNum) RecNum 
		FROM EXCENTO.IEPArchiveDocTbl dIn
		WHERE d.GStudentID = dIn.GStudentID
		GROUP BY dIn.GStudentID
		)
GO
-- last line