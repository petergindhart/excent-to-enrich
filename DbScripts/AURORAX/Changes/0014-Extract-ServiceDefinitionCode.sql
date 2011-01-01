IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'AURORAX.ServiceDefinitionCode_LOCAL') AND type in (N'U'))
DROP TABLE AURORAX.ServiceDefinitionCode_LOCAL
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'AURORAX.ServiceDefinitionCode'))
DROP VIEW AURORAX.ServiceDefinitionCode
GO

CREATE TABLE AURORAX.ServiceDefinitionCode_LOCAL(
ServiceDefinitionCode	varchar(10)		not null,
ServiceDefinitionDescription	varchar(100)	not null
)
GO


CREATE VIEW AURORAX.ServiceDefinitionCode
AS
	SELECT * FROM AURORAX.ServiceDefinitionCode_LOCAL
GO


-- #############################################################################
-- ServiceDefID -- probably not going to use the map table
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_ServiceDefID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_ServiceDefID
GO
CREATE TABLE AURORAX.MAP_ServiceDefID
	(
	ServiceDefinitionCode varchar(10) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  
GO
ALTER TABLE AURORAX.MAP_ServiceDefID ADD CONSTRAINT
	PK_MAP_ServiceDefID PRIMARY KEY CLUSTERED
	(
	ServiceDefinitionCode
	) 
GO
