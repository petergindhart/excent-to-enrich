IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[AURORAX].[ServiceLocationCode_LOCAL]') AND type in (N'U'))
DROP TABLE [AURORAX].[ServiceLocationCode_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[AURORAX].[ServiceLocationCode]'))
DROP VIEW [AURORAX].[ServiceLocationCode]
GO

CREATE TABLE [AURORAX].[ServiceLocationCode_LOCAL](
ServiceLocationCode    varchar(5), 
ServiceLocationDescription    varchar(100)
)
GO


CREATE VIEW [AURORAX].[ServiceLocationCode]
AS
	SELECT * FROM [AURORAX].[ServiceLocationCode_LOCAL]
GO
