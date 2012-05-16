IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'EXCENTO.Transform_FileData_SC_PlaceChangeTbl') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW EXCENTO.Transform_FileData_SC_PlaceChangeTbl
GO

CREATE VIEW EXCENTO.Transform_FileData_SC_PlaceChangeTbl
AS
 SELECT
 s.PlaceChangeSeqNum,
 m.DestID,
 OriginalName = 'Proposal To Change Identification Or Placement \',
 ReceivedDate = s.[Date],
 MimeType = 'document\pdf', 
 [Content] = s.SavedPDF,
 IsTemporary = cast(0 as bit)
 FROM
	EXCENTO.Transform_Iep i JOIN
	EXCENTO.SC_PlaceChangeTbl s on i.GStudentID = s.GStudentID LEFT JOIN 
	EXCENTO.MAP_FileData_SC_PlaceChangeTbl m on s.PlaceChangeSeqNum = m.PlaceChangeSeqNum
 WHERE s.SavedPDF is not null AND
 	s.[Date] is not null
GO
