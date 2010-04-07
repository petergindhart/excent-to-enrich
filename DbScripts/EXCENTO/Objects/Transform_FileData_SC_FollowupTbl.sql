IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'EXCENTO.Transform_FileData_SC_FollowupTbl') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW EXCENTO.Transform_FileData_SC_FollowupTbl
GO

CREATE VIEW EXCENTO.Transform_FileData_SC_FollowupTbl
AS
 SELECT
 s.FollowupSeqNum,
 m.DestID,
 OriginalName = 'Follow-up to Reevaluation Review',
 ReceivedDate = s.NoticeDate,
 MimeType = 'document\pdf', 
 [Content] = s.SavedPDF,
 IsTemporary = cast(0 as bit)
 FROM
	EXCENTO.Transform_Iep i JOIN
	EXCENTO.SC_FollowupTbl s on i.GStudentID = s.GStudentID LEFT JOIN 
	EXCENTO.MAP_FileData_SC_FollowupTbl m on s.FollowupSeqNum = m.FollowupSeqNum
 WHERE s.SavedPDF is not null AND
 	s.NoticeDate is not null
GO
