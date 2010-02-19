IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].Transform_IEPArchiveDocTbl') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].Transform_IEPArchiveDocTbl
GO

CREATE VIEW EXCENTO.Transform_IEPArchiveDocTbl
AS
	select
		d.RecNum,
		m.DestID,
		OriginalName = 'C:\Blah.pdf', 
		ReceivedDate = IEPCompleteDate, 
		MimeType = 'document\pdf', 
		[Content] =  d.PDFImage, 
		IsTemporary = 0
	from
		EXCENTO.IEPArchiveDocTbl d left join
		EXCENTO.MAP_FileDataID m on d.RecNum = m.RecNum
GO
