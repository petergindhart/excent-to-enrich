IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'SPEDDOC.IEPDoc_LOCAL') AND type in (N'U'))
DROP TABLE SPEDDOC.IEPDoc_LOCAL  
GO  
 
CREATE TABLE SPEDDOC.IEPDoc_LOCAL(	
	StudentRefID uniqueidentifier NOT NULL,
	IEPRefID varchar(150) NOT NULL, -- need to be able to use this schema for districts whose IEPRefID might be other than numeric
	DocType nvarchar(15) NULL,
	Content image NULL
)

--  IEPRefID will be the primary key.

GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'SPEDDOC.IEPDoc'))
DROP VIEW SPEDDOC.IEPDoc
GO

CREATE VIEW SPEDDOC.IEPDoc
AS
 SELECT * FROM SPEDDOC.IEPDoc_LOCAL
GO
--
