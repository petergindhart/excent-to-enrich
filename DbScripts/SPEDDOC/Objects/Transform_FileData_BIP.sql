-- #############################################################################
-- This table will associate the FileDataId with IepRefID.  IepRefId will be the primary Key.

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'SPEDDOC.MAP_FileDataID_BIP') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN 
CREATE TABLE SPEDDOC.MAP_FileDataID_BIP
	(
	IepRefID varchar(150) NOT NULL,
	DestID uniqueidentifier NOT NULL
	) 

ALTER TABLE SPEDDOC.MAP_FileDataID_BIP ADD CONSTRAINT
	PK_MAP_FileDataID_BIP PRIMARY KEY CLUSTERED
	(
	IepRefID
	)
END
GO



IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'SPEDDOC.Transform_FileData_BIP') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW SPEDDOC.Transform_FileData_BIP
GO

CREATE VIEW SPEDDoc.Transform_FileData_BIP
AS

/*
	This view will select PDF document from SPEDDOC.BIPDoc table by joining LEGACYSPED.IEP table on IepRefID.
*/
SELECT 
	BIPDoc.IepRefID as IepRefID,
	DestID = coalesce(FData.ID, MFData.DestID, NEWID()),
	OriginalName = 'Original BIP Document'
	,ReceivedDate = GETDATE()
	,'application/'+ BIPDoc.DocType as MimeType
	,BIPDoc.Content 
	,isTemporary = 0
FROM 
	SPEDDOC.BIPDoc BIPDoc 
	
	JOIN LEGACYSPED.IEP as LEGSIEP
		ON LEGSIEP.IepRefID  = BIPDoc.IEPRefID AND BIPDoc.StudentRefID = LEGSIEP.StudentRefID
	
	LEFT JOIN SPEDDOC.MAP_FileDataID_BIP as MFData
		ON MFData.IepRefID = BIPDoc.IepRefID
		
	LEFT JOIN dbo.FileData FData ON FData.ID = MFData.DestID
