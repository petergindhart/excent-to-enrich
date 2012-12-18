-- #############################################################################
-- This table will associate the FileDataId with IepRefID.  IepRefId will be the primary Key.

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'SPEDDOC.MAP_FileDataID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1) -- drop table SPEDDOC.MAP_FileDataID
BEGIN 
CREATE TABLE SPEDDOC.MAP_FileDataID
	(
	PKSeq varchar(150) not null,
	StudentRefID varchar(150) not null,
	DocumentType varchar(100) not null,
	DestID uniqueidentifier NOT NULL
	) 

ALTER TABLE SPEDDOC.MAP_FileDataID ADD CONSTRAINT
	PK_MAP_FileDataID_IEP PRIMARY KEY CLUSTERED
	(
	PKSeq, DocumentType
	)
END
GO

if not exists (select 1 from sys.indexes where name = 'IX_SPEDDOC_MAP_FileDataID_StudentRefID')
create index IX_SPEDDOC_MAP_FileDataID_StudentRefID on SPEDDOC.MAP_FileDataID (StudentRefID)


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'SPEDDOC.Transform_FileData') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW SPEDDOC.Transform_FileData
GO

CREATE VIEW SPEDDOC.Transform_FileData
AS

/*
	This view will select PDF document from SPEDDOC.IEPDoc table by joining LEGACYSPED.IEP table on IepRefID.
*/
SELECT 
	d.PKSeq,
	d.DocumentType,
	d.StudentRefID,
	DestID = coalesce(t.ID, m.DestID),
	OriginalName = d.DocumentType+' - '+isnull(convert(varchar, d.DocumentDate,101), ''),
	ReceivedDate = GETDATE(),
	MimeType = 'document/pdf',
	d.Content,
	isTemporary = 0
FROM 
	SPEDDOC.AllDocs d JOIN
	LEGACYSPED.Student s ON d.StudentRefID = s.StudentRefID LEFT JOIN 
	SPEDDOC.MAP_FileDataID m ON d.PKSeq = m.PKSeq and d.DocumentType = m.DocumentType left join
	dbo.FileData t ON m.DestID = t.ID
go

