--#include Transform_FileData.sql

-- #############################################################################
-- This table will associate the Attachment.  

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'x_LEGACYDOC.MAP_AttachmentID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1) -- drop table x_LEGACYDOC.MAP_AttachmentID

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
*/
-- SPED
SELECT 
	f.DocumentRefID,
	f.DocumentType,
	f.StudentRefID,
	DestID = coalesce(t.ID, ma.DestID),
	i.StudentID,
	ItemID = i.DestID,
    VersionID = i.VersionDestID,
    FileID = f.DestID,
    Label = f.Label,
    UploadUserID = ISNULL(i.CreatedBy, 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB') 
FROM  
	x_LEGACYDOC.Transform_FileData f JOIN
	LEGACYSPED.Transform_PrgIep i on f.StudentRefID = i.StudentRefID LEFT JOIN
	x_LEGACYDOC.MAP_AttachmentID ma	on f.DocumentRefID = ma.DocumentRefID and f.DocumentType = ma.DocumentType LEFT JOIN	
	dbo.Attachment t ON ma.DestID = t.ID
union
-- GIFTED		2FF58E06-9E4A-4BE5-8274-E0FDE0012D4E
SELECT 
	f.DocumentRefID,
	f.DocumentType,
	f.StudentRefID,
	DestID = coalesce(t.ID, ma.DestID),
	i.StudentID,
	ItemID = i.ItemDestID,
    VersionID = i.VersionDestID,
    FileID = f.DestID,
    Label = f.Label,
    UploadUserID = ISNULL(i.CreatedBy, 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB') 
FROM  
	x_LEGACYDOC.Transform_FileData f JOIN
	x_LEGACYGIFT.Transform_PrgItem i on f.StudentRefID = i.StudentRefID LEFT JOIN
	x_LEGACYDOC.MAP_AttachmentID ma	on f.DocumentRefID = ma.DocumentRefID and f.DocumentType = ma.DocumentType LEFT JOIN	
	dbo.Attachment t ON ma.DestID = t.ID
union
-- 504		A1F33015-4D93-4768-B273-EA0CA77274BE
SELECT 
	f.DocumentRefID,
	f.DocumentType,
	f.StudentRefID,
	DestID = coalesce(t.ID, ma.DestID),
	i.StudentID,
	ItemID = i.ItemDestID,
    VersionID = i.VersionDestID,
    FileID = f.DestID,
    Label = f.Label,
    UploadUserID = cast('EEE133BD-C557-47E1-AB67-EE413DD3D1AB' as uniqueidentifier)
FROM  
	x_LEGACYDOC.Transform_FileData f JOIN
	x_LEGACY504.Transform_504Data i on f.StudentlocalID = i.StudentNumber LEFT JOIN
	x_LEGACYDOC.MAP_AttachmentID ma	on f.DocumentRefID = ma.DocumentRefID and f.DocumentType = ma.DocumentType LEFT JOIN	
	dbo.Attachment t ON ma.DestID = t.ID
	where i.ItemDestID = 'BA9F9637-E5FC-4156-9098-571C2F579EF0' -- student has 9 documents A3E27CA5-6C5D-4D30-9BA0-A32BBA6747C9
go
