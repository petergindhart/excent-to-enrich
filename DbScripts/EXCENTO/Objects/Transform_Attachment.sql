-- #############################################################################
-- This table will associate the Attachment with IepRefID.  IepRefId will be the primary Key.

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'EXCENTO.MAP_AttachmentID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)

BEGIN 
CREATE TABLE EXCENTO.MAP_AttachmentID
	(
	IepRefID varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	) 

ALTER TABLE EXCENTO.MAP_AttachmentID ADD CONSTRAINT
	PK_MAP_AttachmentID PRIMARY KEY CLUSTERED
	(
	IepRefID
	)
END
GO


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'EXCENTO.Transform_Attachment') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW EXCENTO.Transform_Attachment
GO

CREATE VIEW EXCENTO.Transform_Attachment 
AS
/*
	This view is used to retrieve data needed for Attachment table.  
	Here we are joining IEP table with LEGACYSPED.Transform_PrgIep & ExcentO.MAP_FileDataID tables.
*/

SELECT 
	IEP.IepRefId
	,DestID = null
	,TranPrgIEP.StudentID
	,TranPrgIEP.DestID AS ItemID
    ,TranPrgIEP.VersionDestID AS VersionID
    ,FileID = MapFile.DestID
    ,Label = 'EO PDF Report'
    ,TranPrgIEP.CreatedBy AS UploadedUserID
    
FROM LEGACYSPED.Transform_PrgIep TranPrgIEP
	JOIN LEGACYSPED.IEP IEP
		ON TranPrgIEP.IEPRefID = IEP.IepRefID AND TranPrgIEP.StudentRefID = IEP.StudentRefID
	JOIN ExcentO.MAP_FileDataID MapFile 
		ON MapFile.IepRefID = IEP.IepRefID

GO


