--#include Transform_FileData.sql

-- #############################################################################
-- This table will associate the Attachment with IepRefID.  IepRefId will be the primary Key.

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'SPEDDOC.MAP_AttachmentID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)

BEGIN 
CREATE TABLE SPEDDOC.MAP_AttachmentID
	(
	IepRefID varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	) 

ALTER TABLE SPEDDOC.MAP_AttachmentID ADD CONSTRAINT
	PK_MAP_AttachmentID PRIMARY KEY CLUSTERED
	(
	IepRefID
	)
END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'SPEDDOC.Transform_Attachment') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW SPEDDOC.Transform_Attachment
GO

CREATE VIEW SPEDDOC.Transform_Attachment 
AS
/*
	This view is used to retrieve data needed for Attachment table.  
	Here we are joining LEGACYSPED.IEP table with LEGACYSPED.Transform_PrgIep & SPEDDOC.MAP_FileDataID tables.
*/


SELECT TOP 100
	IEPDoc.IepRefId
	,DestID = coalesce(Attach.ID, MAttachment.DestID, NEWID())
	,TranPrgIEP.StudentID
	,TranPrgIEP.DestID AS ItemID
    ,TranPrgIEP.VersionDestID AS VersionID
    ,FileID = MapFile.DestID
    ,Label = 'IEP PDF Report'
    ,UploadUserID = ISNULL(TranPrgIEP.CreatedBy, 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB')
    
FROM  SPEDDOC.IEPDoc IEPDoc 
	 JOIN LEGACYSPED.IEP IEP 
		ON IEP.IepRefID = IEPDoc.IEPRefID AND IEP.StudentRefID = IEPDoc.StudentRefID
     JOIN LEGACYSPED.Transform_PrgIep TranPrgIEP
		ON IEPDoc.IepRefID = TranPrgIEP.IepRefID AND IEPDoc.StudentRefID = TranPrgIEP.StudentRefID
	
	LEFT JOIN SPEDDOC.Transform_FileData MapFile 
		ON MapFile.IepRefID = IEPDoc.IepRefID
		
	LEFT JOIN  SPEDDOC.MAP_AttachmentID MAttachment
		ON MAttachment.IepRefID = IEPDoc.IepRefID
		
	LEFT JOIN dbo.Attachment Attach
		ON Attach.ID = MAttachment.DestID
	ORDER BY FileID DESC
	 
