IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'EXCENTO.Transform_FileData_SC_EvalScheduleTbl') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW EXCENTO.Transform_FileData_SC_EvalScheduleTbl
GO

CREATE VIEW EXCENTO.Transform_FileData_SC_EvalScheduleTbl
AS
 SELECT
 s.EvalSchedSeqNum,
 m.DestID,
 OriginalName = 'Notice of Evaluation Schedule',
 ReceivedDate = s.NoticeDate,
 MimeType = 'document\pdf', 
 [Content] = s.SavedPDF,
 IsTemporary = cast(0 as bit)
 FROM
	EXCENTO.Transform_Iep i JOIN
	EXCENTO.SC_EvalScheduleTbl s on i.GStudentID = s.GStudentID LEFT JOIN 
	EXCENTO.MAP_FileData_SC_EvalScheduleTbl m on s.EvalSchedSeqNum = m.EvalSchedSeqNum
 WHERE s.SavedPDF is not null AND
 	s.NoticeDate is not null
GO
