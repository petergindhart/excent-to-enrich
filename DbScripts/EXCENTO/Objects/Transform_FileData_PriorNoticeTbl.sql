IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'EXCENTO.Transform_FileData_PriorNoticeTbl') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW EXCENTO.Transform_FileData_PriorNoticeTbl
GO

CREATE VIEW EXCENTO.Transform_FileData_PriorNoticeTbl
AS
 SELECT
 s.PriorSeqNum,
 m.DestID,
 OriginalName = 'Prior Written Notice',
 ReceivedDate = s.NoticeDate,
 MimeType = 'document\pdf', 
 [Content] = s.SavedPDF,
 IsTemporary = cast(0 as bit)
 FROM
	EXCENTO.Transform_Iep i JOIN
	EXCENTO.PriorNoticeTbl s on i.GStudentID = s.GStudentID LEFT JOIN 
	EXCENTO.MAP_FileData_PriorNoticeTbl m on s.PriorSeqNum = m.PriorSeqNum
 WHERE s.SavedPDF is not null AND
 	s.NoticeDate is not null
GO
