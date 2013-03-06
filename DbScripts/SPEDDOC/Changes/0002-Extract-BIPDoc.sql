IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'SPEDDOC.BIPDoc_LOCAL') AND type in (N'U'))
DROP TABLE SPEDDOC.BIPDoc_LOCAL
GO  
 
CREATE TABLE SPEDDOC.BIPDoc_LOCAL(	
	StudentRefID uniqueidentifier NOT NULL,
	IEPRefID varchar(150) NOT NULL, -- need to be able to use this schema for districts whose IEPRefID might be other than numeric
	DocType nvarchar(15) NULL,
	Content image NULL
)

--  IEPRefID will be the primary key.

GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'SPEDDOC.BIPDoc'))
DROP VIEW SPEDDOC.BIPDoc
GO

CREATE VIEW SPEDDOC.BIPDoc
AS
 SELECT * FROM SPEDDOC.BIPDoc_LOCAL