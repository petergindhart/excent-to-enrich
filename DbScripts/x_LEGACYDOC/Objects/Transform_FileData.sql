-- #############################################################################
-- This table will associate the FileDataId with IepRefID.  IepRefId will be the primary Key.

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYDOC.MAP_FileDataID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1) -- drop table x_LEGACYDOC.MAP_FileDataID
BEGIN 
CREATE TABLE x_LEGACYDOC.MAP_FileDataID
	(
	DocumentRefID varchar(150) not null,
	StudentRefID varchar(150) not null,
	DocumentType varchar(100) not null,
	DestID uniqueidentifier NOT NULL
	) 

ALTER TABLE x_LEGACYDOC.MAP_FileDataID ADD CONSTRAINT
	PK_MAP_FileDataID_IEP PRIMARY KEY CLUSTERED
	(
	DocumentRefID, DocumentType
	)
END
GO

if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYDOC_MAP_FileDataID_StudentRefID')
create index IX_x_LEGACYDOC_MAP_FileDataID_StudentRefID on x_LEGACYDOC.MAP_FileDataID (StudentRefID)

--select * from x_LEGACYDOC.dbo.alldocs
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYDOC.Transform_FileData') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYDOC.Transform_FileData
GO

CREATE VIEW x_LEGACYDOC.Transform_FileData
AS

/*
	This view will select PDF document from x_LEGACYDOC.IEPDoc table by joining LEGACYSPED.IEP table on IepRefID.
*/
SELECT 
	d.DocumentRefID,
	d.DocumentType,
	d.StudentRefID,
	DestID = coalesce(t.ID, m.DestID),
	OriginalName = d.DocumentType+' - '+isnull(convert(varchar, d.DocumentDate,101), ''),
	ReceivedDate = GETDATE(),
	d.MimeType,
	d.Content,
	isTemporary = 0
FROM 
	x_LEGACYDOC.AllDocs d JOIN
	LEGACYSPED.IEP s ON d.StudentRefID = s.StudentRefID LEFT JOIN 
	x_LEGACYDOC.MAP_FileDataID m ON d.DocumentRefID = m.DocumentRefID and d.DocumentType = m.DocumentType left join
	dbo.FileData t ON m.DestID = t.ID
union all
SELECT 
	d.DocumentRefID,
	d.DocumentType,
	d.StudentRefID,
	DestID = coalesce(t.ID, m.DestID),
	OriginalName = d.DocumentType+' - '+isnull(convert(varchar, d.DocumentDate,101), ''),
	ReceivedDate = GETDATE(),
	d.MimeType,
	d.Content,
	isTemporary = 0 
FROM 
	x_LEGACYDOC.AllDocs d JOIN 
	x_LEGACY504.Student504Dates s on d.StudentLocalID = s.StudentNumber JOIN 
	dbo.Student stu on s.StudentNumber = stu.Number JOIN
	x_LEGACYDOC.MAP_FileDataID m ON d.DocumentRefID = m.DocumentRefID and d.DocumentType = m.DocumentType left join
	dbo.FileData t ON m.DestID = t.ID
go

--select * from VC3Deployment.Version where Module = 'SPEDDOC'
--select * from VC3Deployment.Version where Module = 'x_LEGACYDOC'

--insert VC3Deployment.Version (Module, ScriptNumber, ScriptName, DateApplied) values ('x_LEGACYDOC', 0, '0000-RegisterModule.sql', getdate())
--insert VC3Deployment.Version (Module, ScriptNumber, ScriptName, DateApplied) values ('x_LEGACYDOC', 0, '0001-Extract-AllDocs.sql', getdate())




