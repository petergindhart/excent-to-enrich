-- #############################################################################
-- This table will associate the FileDataId with IepRefID.  IepRefId will be the primary Key.

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'SPEDDOC.MAP_FileDataID_IEP') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN 
CREATE TABLE SPEDDOC.MAP_FileDataID_IEP
	(
	IepRefID varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	) 

ALTER TABLE SPEDDOC.MAP_FileDataID_IEP ADD CONSTRAINT
	PK_MAP_FileDataID_IEP PRIMARY KEY CLUSTERED
	(
	IepRefID
	)
END
GO



IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'SPEDDOC.Transform_FileData_IEP') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW SPEDDOC.Transform_FileData_IEP
GO

CREATE VIEW SPEDDoc.Transform_FileData_IEP
AS

/*
	This view will select PDF document from SPEDDOC.IEPDoc table by joining LEGACYSPED.IEP table on IepRefID.
*/
SELECT 
	IEPDoc.IepRefID as IepRefID,
	DestID = coalesce(FData.ID, MFData.DestID, NEWID()),
	OriginalName = 'Original IEP Document'
	,ReceivedDate = GETDATE()
	,'application/'+ IEPDoc.DocType as MimeType
	,IEPDoc.Content 
	,isTemporary = 0
FROM 
	SPEDDOC.IEPDoc IEPDoc 
	
	JOIN LEGACYSPED.IEP as LEGSIEP
		ON LEGSIEP.IepRefID  = IEPDoc.IEPRefID AND IEPDoc.StudentRefID = LEGSIEP.StudentRefID
	
	LEFT JOIN SPEDDOC.MAP_FileDataID_IEP as MFData
		ON MFData.IepRefID = IEPDoc.IepRefID
		
	LEFT JOIN dbo.FileData FData ON FData.ID = MFData.DestID
