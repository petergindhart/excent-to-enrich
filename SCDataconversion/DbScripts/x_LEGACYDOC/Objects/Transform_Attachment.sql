--#include Transform_FileData.sql

-- #############################################################################
-- This table will associate the Attachment.  

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYDOC.MAP_AttachmentID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1) 
BEGIN 
CREATE TABLE x_LEGACYDOC.MAP_AttachmentID
(
	DocumentRefID varchar(150) not null,
	StudentRefID varchar(150) NOT NULL,
	DocumentType varchar(100) not null,
	DestID uniqueidentifier NOT NULL
) 

ALTER TABLE x_LEGACYDOC.MAP_AttachmentID ADD CONSTRAINT
	PK_MAP_AttachmentID PRIMARY KEY CLUSTERED
(
	DocumentRefID, DocumentType
)
END
GO

if not exists (select 1 from sys.indexes where name = 'IX_x_LEGACYDOC_MAP_AttachmentID_StudentRefID')
create index IX_x_LEGACYDOC_MAP_AttachmentID_StudentRefID on x_LEGACYDOC.MAP_AttachmentID (StudentRefID)
go


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYDOC.Transform_Attachment') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW x_LEGACYDOC.Transform_Attachment
GO

CREATE VIEW x_LEGACYDOC.Transform_Attachment
AS
/*
	This view is used to retrieve data needed for Attachment table.  
	Here we are joining LEGACYSPED.IEP table with LEGACYSPED.Transform_PrgIep & x_LEGACYDOC.MAP_FileDataID tables.
	By using the DocumentRefID and the DocumentType as primary key, we would get duplicates if a student were in 2 programs,
	so we will arbitrarily chools one program as the primary (docs attached here) where the student is involved in more than 1 program.

	Order of precedence:
	1.  Sped
	2.  Gifted
	3.  504

*/
-- SPED
with CTE_ProgramDocs 
as
(
SELECT 
	ProgramIndex = cast(0 as int),
	f.DocumentRefID,
	f.DocumentType,
	f.StudentRefID,
	DestID = coalesce(t.ID, ma.DestID),
	f.StudentID,
	ItemID = ms.DestID,
    VersionID = v.ID,
    FileID = f.DestID,
    Label = f.Label,
    UploadUserID = ISNULL(i.CreatedBy, 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB') 
FROM  
	x_LEGACYDOC.Transform_FileData f JOIN
	--LEGACYSPED.Transform_PrgIep i on f.StudentRefID = i.StudentRefID LEFT JOIN -- we are now taking care of this in Transform_FileData 
	------- not useing the transform is a lot faster
	LEGACYSPED.MAP_IEPStudentRefID ms on f.StudentRefID = ms.StudentRefID left join  
	dbo.PrgItem i on ms.DestID = i.ID left join
	dbo.PrgVersion v on ms.DestID = v.ItemID left join
	x_LEGACYDOC.MAP_AttachmentID ma	on f.DocumentRefID = ma.DocumentRefID and f.DocumentType = ma.DocumentType LEFT JOIN	
	dbo.Attachment t ON ma.DestID = t.ID
)  

select a.*
from CTE_ProgramDocs a 
where a.ProgramIndex = (
	select min(b.ProgramIndex)
	from CTE_ProgramDocs b 
	where a.DocumentRefID = b.DocumentRefID and a.DocumentType = b.DocumentType 
	)
and exists (select 1 from PrgItem xi where a.ItemID = xi.ID)
go
