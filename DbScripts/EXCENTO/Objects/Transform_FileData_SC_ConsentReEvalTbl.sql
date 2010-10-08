IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'EXCENTO.Transform_FileData_SC_ConsentReEvalTbl') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW EXCENTO.Transform_FileData_SC_ConsentReEvalTbl
GO

CREATE VIEW EXCENTO.Transform_FileData_SC_ConsentReEvalTbl
AS
 SELECT
 s.ConsentReevalSeqNum,
 m.DestID,
 OriginalName = 'Consent for Reevaluation',
 ReceivedDate = s.NoticeDate,
 MimeType = 'document\pdf', 
 [Content] = s.SavedPDF,
 IsTemporary = cast(0 as bit)
 FROM
	EXCENTO.Transform_Iep i JOIN
	EXCENTO.SC_ConsentReEvalTbl s on i.GStudentID = s.GStudentID LEFT JOIN 
	EXCENTO.MAP_FileData_SC_ConsentReEvalTbl m on s.ConsentReevalSeqNum = m.ConsentReevalSeqNum
 WHERE s.SavedPDF is not null AND
 	s.NoticeDate is not null
GO
