-- #############################################################################

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

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYDOC.Transform_FileData') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYDOC.Transform_FileData
GO

CREATE VIEW x_LEGACYDOC.Transform_FileData
AS
/*

	Students may be involved in more than one program.  Currently there is no distinction between documents for one program or another (though IEPs are obviously sped).
	All documents of certain types are exported from source database, regardless of the program the document was created for.  Here we ensure that if a student is involved
	in 504, Gifted or Sped, we attach documents for them.

*/
select x.*, a.Content
from (
	-- SPED
	SELECT 
		d.DocumentRefID,
		d.DocumentType,
		d.StudentRefID,
		d.StudentLocalID,
		DestID = coalesce(t.ID, m.DestID),
		OriginalName = d.DocumentType+' - '+isnull(convert(varchar, d.DocumentDate,101), '') + '.' + replace(d.MimeType, 'document/', ''),
		Label = d.DocumentType+' - '+isnull(convert(varchar, d.DocumentDate,101), ''),
		ReceivedDate = GETDATE(),
		d.MimeType,
	-- 	d.Content,
		isTemporary = 0
	FROM 
		x_LEGACYDOC.AllDocs d JOIN
		LEGACYSPED.IEP s ON d.StudentRefID = s.StudentRefID LEFT JOIN 
		x_LEGACYDOC.MAP_FileDataID m ON d.DocumentRefID = m.DocumentRefID and d.DocumentType = m.DocumentType left join
		dbo.FileData t ON m.DestID = t.ID
	union 
	-- 504
	SELECT 
		d.DocumentRefID,
		d.DocumentType,
		d.StudentRefID,
		d.StudentLocalID,
		DestID = coalesce(t.ID, m.DestID),
		OriginalName = d.DocumentType+' - '+isnull(convert(varchar, d.DocumentDate,101), '') + '.' + replace(d.MimeType, 'document/', ''),
		Label = d.DocumentType+' - '+isnull(convert(varchar, d.DocumentDate,101), ''),
		ReceivedDate = GETDATE(),
		d.MimeType,
	--	d.Content,
		isTemporary = 0 
	FROM 
		x_LEGACYDOC.AllDocs d JOIN 
		x_LEGACY504.Student504Dates s on d.StudentLocalID = s.StudentNumber JOIN 
		dbo.Student stu on s.StudentNumber = stu.Number JOIN
		x_LEGACYDOC.MAP_FileDataID m ON d.DocumentRefID = m.DocumentRefID and d.DocumentType = m.DocumentType left join
		dbo.FileData t ON m.DestID = t.ID
	union 
	-- GIFTED
	SELECT 
		d.DocumentRefID,
		d.DocumentType,
		d.StudentRefID,
		d.StudentLocalID,
		DestID = coalesce(t.ID, m.DestID),
		OriginalName = d.DocumentType+' - '+isnull(convert(varchar, d.DocumentDate,101), '') + '.' + replace(d.MimeType, 'document/', ''),
		Label = d.DocumentType+' - '+isnull(convert(varchar, d.DocumentDate,101), ''),
		ReceivedDate = GETDATE(),
		d.MimeType,
	-- 	d.Content,
		isTemporary = 0
	FROM 
		x_LEGACYDOC.AllDocs d JOIN
		x_LEGACYGIFT.GiftedStudent s ON d.StudentRefID = s.StudentRefID LEFT JOIN 
		x_LEGACYDOC.MAP_FileDataID m ON d.DocumentRefID = m.DocumentRefID and d.DocumentType = m.DocumentType left join
		dbo.FileData t ON m.DestID = t.ID
) x join 
x_LEGACYDOC.AllDocs a on
	x.DocumentRefID = a.DocumentRefID and
	x.DocumentType = a.DocumentType and
	x.Label = a.DocumentType+' - '+isnull(convert(varchar, a.DocumentDate,101), '') 
go






