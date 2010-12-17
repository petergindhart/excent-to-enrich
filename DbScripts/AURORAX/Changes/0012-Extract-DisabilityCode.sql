IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.DisabilityCode') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW AURORAX.DisabilityCode
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.DisabilityCode_LOCAL') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.DisabilityCode_LOCAL
GO

CREATE TABLE AURORAX.DisabilityCode_LOCAL (
	DisabilityCode nvarchar(10) NOT NULL,
	DisabilityDesc nvarchar(100) NULL
)
GO

CREATE VIEW AURORAX.DisabilityCode
AS
	SELECT * FROM AURORAX.DisabilityCode_LOCAL
GO

-- #############################################################################
-- Map Table
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'AURORAX.MAP_IepDisabilityID') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE AURORAX.MAP_IepDisabilityID
GO
CREATE TABLE AURORAX.MAP_IepDisabilityID
	(
	DisabilityCode nvarchar(10) NOT NULL,
	DestID uniqueidentifier NOT NULL
	) 
GO
ALTER TABLE AURORAX.MAP_IepDisabilityID ADD CONSTRAINT
	PK_MAP_IepDisabilityID PRIMARY KEY CLUSTERED
	(
	DisabilityCode
	) 
GO
