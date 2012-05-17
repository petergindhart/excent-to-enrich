IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'EXCENTO.Transform_FileData_SC_PlaceConsentTbl') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW EXCENTO.Transform_FileData_SC_PlaceConsentTbl
GO

CREATE VIEW EXCENTO.Transform_FileData_SC_PlaceConsentTbl
AS
 SELECT
 s.PlaceConsentSeqNum,
 m.DestID,
 OriginalName = 'Parental Consent for Placement',
 ReceivedDate = s.InitialDate,
 MimeType = 'document\pdf',
 [Content] = s.SavedPDF,
 IsTemporary = cast(0 as bit)
 FROM
	EXCENTO.Transform_Iep i JOIN
	EXCENTO.SC_PlaceConsentTbl s on i.GStudentID = s.GStudentID LEFT JOIN
	EXCENTO.MAP_FileData_SC_PlaceConsentTbl m on s.PlaceConsentSeqNum = m.PlaceConsentSeqNum
 WHERE s.SavedPDF is not null AND
 	s.InitialDate is not null
GO
