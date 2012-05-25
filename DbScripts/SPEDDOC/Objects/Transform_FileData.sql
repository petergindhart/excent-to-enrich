-- #############################################################################
-- This table will associate the FileDataId with IepRefID.  IepRefId will be the primary Key.

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'SPEDDOC.MAP_FileDataID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN 
CREATE TABLE SPEDDOC.MAP_FileDataID
	(
	IepRefID varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	) 

ALTER TABLE SPEDDOC.MAP_FileDataID ADD CONSTRAINT
	PK_MAP_FileDataID PRIMARY KEY CLUSTERED
	(
	IepRefID
	)
END
GO



IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'SPEDDOC.Transform_FileData') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW SPEDDOC.Transform_FileData
GO

CREATE VIEW SPEDDoc.Transform_FileData 
AS

/*
	This view will select PDF document from SPEDDOC.IEPDoc table by joining LEGACYSPED.IEP table on IepRefID.
*/
SELECT 
	LEGSIEP.IepRefID as IepRefID,
	DestID = null,
	OriginalName = 'IEP PDF Document'
	,ReceivedDate = GETDATE()
	,'application/pdf' as MimeType
	,Content 
	,isTemporary = 0
FROM SPEDDOC.IEPDoc IEPPDF 
	JOIN LEGACYSPED.IEP as LEGSIEP
		ON LEGSIEP.IepRefID  = IEPPDF.IEPRefID
		

/*
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'SPEDDOC.Transform_FileData') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW SPEDDOC.Transform_FileData
--GO

CREATE VIEW EXCENTO.Transform_FileData 
AS

--	This view will select PDF document from ExcentOnlineFL.dbo.IEPArchiveDocTbl table.
--	Here we are joining ExcentOnlineFL.dbo.IEPArchiveDocTbl with Enrich_DCB1_FL_Lee.LEGACYSPED.IEP via 
--	ExcentOnlineFL.dbo.IEPCompleteTbl.	


SELECT 
	LEGSIEP.IepRefID,
	DestID = null,
	OriginalName = 'IEP PDF Document'
	,ReceivedDate = GETDATE()
	,MimeType = DocType 
	,Content = PDFImage 
	,isTemporary = 0
FROM ExcentOnlineFL.dbo.IEPArchiveDocTbl as EOIEArcDoc
	JOIN IEPCompleteTbl as EOIEPCompl
		ON EOIEPCompl.RecNum = EOIEArcDoc.RecNum AND EOIEArcDoc.GStudentID = EOIEPCompl.GStudentID
	JOIN Enrich_DCB1_FL_Lee.LEGACYSPED.IEP as LEGSIEP
		ON LEGSIEP.IepRefID = EOIEPCompl.IEPSeqNum AND LEGSIEP.StudentRefID = EOIEPCompl.GStudentID

--GO
*/		