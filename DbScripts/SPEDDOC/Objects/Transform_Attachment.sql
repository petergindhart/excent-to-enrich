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

SELECT 
	IEP.IepRefId
	,DestID = null
	,TranPrgIEP.StudentID
	,TranPrgIEP.DestID AS ItemID
    ,TranPrgIEP.VersionDestID AS VersionID
    ,FileID = MapFile.DestID
    ,Label = 'IEP PDF Report'
    ,TranPrgIEP.CreatedBy AS UploadedUserID
    
FROM LEGACYSPED.Transform_PrgIep TranPrgIEP
	JOIN LEGACYSPED.IEP IEP
		ON TranPrgIEP.IEPRefID = IEP.IepRefID AND TranPrgIEP.StudentRefID = IEP.StudentRefID
	JOIN SPEDDOC.MAP_FileDataID MapFile 
		ON MapFile.IepRefID = IEP.IepRefID

GO


