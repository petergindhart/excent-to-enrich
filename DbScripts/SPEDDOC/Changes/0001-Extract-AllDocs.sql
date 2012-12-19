
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'SPEDDOC.AllDocs_LOCAL') AND type in (N'U'))
DROP TABLE SPEDDOC.AllDocs_LOCAL  
GO  

CREATE TABLE SPEDDOC.AllDocs_LOCAL(	
	DocumentRefID	varchar(150) not null, -- remember this might be a GUID or something else in some other environement
	DocumentType varchar(100) not null,
	DocumentDate datetime null,
	StudentRefID varchar(150) not null,
	MimeType varchar(25) not null,
	Content image not null
)
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'SPEDDOC.AllDocs'))
DROP VIEW SPEDDOC.AllDocs
GO

CREATE VIEW SPEDDOC.AllDocs
AS
 SELECT * FROM SPEDDOC.AllDocs_LOCAL
GO
--
