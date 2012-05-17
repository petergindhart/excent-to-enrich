IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'EXCENTO.Transform_FileData_MeetingTbl') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW EXCENTO.Transform_FileData_MeetingTbl
GO

CREATE VIEW EXCENTO.Transform_FileData_MeetingTbl
AS
 SELECT
 s.MeetSeqNum, 
 m.DestID,
 OriginalName = 'Meeting Notice',
 ReceivedDate = s.MeetingDate,
 MimeType = 'document\pdf', 
 [Content] = s.SavedPDF,
 IsTemporary = cast(0 as bit)
 FROM
	EXCENTO.Transform_Iep i JOIN
	EXCENTO.MeetingTbl s on i.GStudentID = s.GStudentID LEFT JOIN 
	EXCENTO.MAP_FileData_MeetingTbl m on s.MeetSeqNum = m.MeetSeqNum
 WHERE s.SavedPDF is not null AND
 	s.MeetingDate is not null
GO
