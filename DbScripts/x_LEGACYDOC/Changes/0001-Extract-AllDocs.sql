
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYDOC.AllDocs_LOCAL') AND type in (N'U'))
DROP TABLE x_LEGACYDOC.AllDocs_LOCAL  
GO  

CREATE TABLE x_LEGACYDOC.AllDocs_LOCAL(	
	DocumentRefID	varchar(150) not null, -- remember this might be a GUID or something else in some other environement
	DocumentType varchar(100) not null,
	DocumentDate datetime null,
	StudentRefID varchar(150) not null,
	StudentLocalID varchar(20) not null,
	MimeType varchar(25) not null,
	Content image not null
)
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'x_LEGACYDOC.AllDocs'))
DROP VIEW x_LEGACYDOC.AllDocs
GO

CREATE VIEW x_LEGACYDOC.AllDocs
AS
 SELECT * FROM x_LEGACYDOC.AllDocs_LOCAL
GO
--
