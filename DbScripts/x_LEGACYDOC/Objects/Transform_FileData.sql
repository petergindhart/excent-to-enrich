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
go

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

with CTE_ProgramDocs 
as
(
	-- SPED
	SELECT 
		ProgramIndex = cast(0 as int),
		d.DocumentRefID,
		d.DocumentType,
		d.StudentRefID,
		d.StudentLocalID,
		StudentID = s.DestID,
		DestID = coalesce(t.ID, m.DestID),
		Label = d.DocumentType+' - '+isnull(convert(varchar, d.DocumentDate,101), ''),
		OriginalName = d.DocumentType+' - '+isnull(convert(varchar, d.DocumentDate,101), '')+ '.'+replace(d.MimeType, 'document/',''),
		ReceivedDate = GETDATE(),
		d.MimeType,
	-- 	d.Content,
		isTemporary = 0
	FROM 
		x_LEGACYDOC.AllDocs d JOIN
		LEGACYSPED.MAP_StudentRefIDAll s ON d.StudentRefID = s.StudentRefID LEFT JOIN 
		dbo.Student stu on s.DestID = stu.ID LEFT JOIN -- ensure the student still exists
		x_LEGACYDOC.MAP_FileDataID m ON d.DocumentRefID = m.DocumentRefID and d.DocumentType = m.DocumentType left join
		dbo.FileData t ON m.DestID = t.ID
	union all
	-- GIFTED
	SELECT 
		ProgramIndex = cast(1 as int),
		d.DocumentRefID,
		d.DocumentType,
		d.StudentRefID,
		d.StudentLocalID,
		i.StudentID,
		DestID = coalesce(t.ID, m.DestID),
		Label = d.DocumentType+' - '+isnull(convert(varchar, d.DocumentDate,101), ''),
		OriginalName = d.DocumentType+' - '+isnull(convert(varchar, d.DocumentDate,101), '')+ '.'+replace(d.MimeType, 'document/',''),
		ReceivedDate = GETDATE(),
		d.MimeType,
	-- 	d.Content,
		isTemporary = 0
	FROM 
		x_LEGACYDOC.AllDocs d JOIN
--		x_LEGACYGIFT.GiftedStudent s ON d.StudentRefID = s.StudentRefID LEFT JOIN 
		x_LEGACYGIFT.MAP_EPStudentRefID s ON d.StudentRefID = s.StudentRefID JOIN 
		dbo.PrgItem i on s.DestID = i.id left join -- this will be the gifted plan
		x_LEGACYDOC.MAP_FileDataID m ON d.DocumentRefID = m.DocumentRefID and d.DocumentType = m.DocumentType left join
		dbo.FileData t ON m.DestID = t.ID
--where d.StudentRefID = 'D22C016A-E44E-44C8-BB6B-F63A966CBF9B' -- select * from Student where ID = '32CF0AC0-58DA-4DD0-AD1C-FE32006FF016'
	union all
	-- 504
	SELECT 
		ProgramIndex = cast(2 as int),
		d.DocumentRefID,
		d.DocumentType,
		d.StudentRefID,
		d.StudentLocalID,
		StudentID = stu.ID, -- see note in the FROM clause
		DestID = coalesce(t.ID, m.DestID),
		Label = d.DocumentType+' - '+isnull(convert(varchar, d.DocumentDate,101), ''),
		OriginalName = d.DocumentType+' - '+isnull(convert(varchar, d.DocumentDate,101), '')+ '.'+replace(d.MimeType, 'document/',''),
		ReceivedDate = GETDATE(),
		d.MimeType,
	--	d.Content,
		isTemporary = 0 
	FROM 
		x_LEGACYDOC.AllDocs d JOIN 
--		x_LEGACY504.Student504Dates s on d.StudentLocalID = s.StudentNumber JOIN 
		x_LEGACY504.MAP_504data s on d.StudentLocalID = s.StudentNumber JOIN ------------------------- note:  RETHINK THIS - when a BOCES (or any other) type district has repeated LocalIDs, this will not work
		dbo.Student stu on s.StudentNumber = stu.Number JOIN
		x_LEGACYDOC.MAP_FileDataID m ON d.DocumentRefID = m.DocumentRefID and d.DocumentType = m.DocumentType left join
		dbo.FileData t ON m.DestID = t.ID
)

select pd.*, a.Content
from CTE_ProgramDocs pd
join x_LEGACYDOC.AllDocs a on 
	pd.DocumentRefID = a.DocumentRefID and
	pd.DocumentType = a.DocumentType and
	pd.OriginalName = a.DocumentType+' - '+isnull(convert(varchar, a.DocumentDate,101), '')+ '.'+replace(a.MimeType, 'document/','')
where pd.ProgramIndex = (
	select min(b.ProgramIndex)
	from CTE_ProgramDocs b 
	where pd.DocumentRefID = b.DocumentRefID and pd.DocumentType = b.DocumentType 
	)
go

