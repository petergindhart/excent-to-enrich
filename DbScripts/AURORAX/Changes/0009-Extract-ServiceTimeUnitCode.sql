IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[AURORAX].[ServiceTimeUnitCode_LOCAL]') AND type in (N'U'))
DROP TABLE [AURORAX].[ServiceTimeUnitCode_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[AURORAX].[ServiceTimeUnitCode]'))
DROP VIEW [AURORAX].[ServiceTimeUnitCode]
GO

CREATE TABLE [AURORAX].[ServiceTimeUnitCode_LOCAL](
ServiceTimeUnitCode    varchar(1), 
ServiceTimeUnitDescription    varchar(100)
)
GO


CREATE VIEW [AURORAX].[ServiceTimeUnitCode]
AS
	SELECT * FROM [AURORAX].[ServiceTimeUnitCode_LOCAL]
GO