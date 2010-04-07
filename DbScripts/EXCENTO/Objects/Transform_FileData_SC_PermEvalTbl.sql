IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'EXCENTO.Transform_FileData_SC_PermEvalTbl') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW EXCENTO.Transform_FileData_SC_PermEvalTbl
GO

CREATE VIEW EXCENTO.Transform_FileData_SC_PermEvalTbl
AS
 SELECT
 s.PermEvalSeqNum,
 m.DestID,
 OriginalName = 'Permission to Evaluate',
 ReceivedDate = s.LetterDate,
 MimeType = 'document\pdf', 
 [Content] = s.SavedPDF,
 IsTemporary = cast(0 as bit)
 FROM
	EXCENTO.Transform_Iep i JOIN
	EXCENTO.SC_PermEvalTbl s on i.GStudentID = s.GStudentID LEFT JOIN 
	EXCENTO.MAP_FileData_SC_PermEvalTbl m on s.PermEvalSeqNum = m.PermEvalSeqNum
 WHERE s.SavedPDF is not null AND
 	s.LetterDate is not null
GO
