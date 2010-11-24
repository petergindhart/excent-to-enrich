IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[AURORAX].[LeastRestrictiveEnvironmentCode_LOCAL]') AND type in (N'U'))
DROP TABLE [AURORAX].[LeastRestrictiveEnvironmentCode_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[AURORAX].[LeastRestrictiveEnvironmentCode]'))
DROP VIEW [AURORAX].[LeastRestrictiveEnvironmentCode]
GO

CREATE TABLE [AURORAX].[LeastRestrictiveEnvironmentCode_LOCAL](
LeastRestrictiveEnvironmentCode    varchar(5), 
LeastRestrictiveEnvironmentDescription    varchar(255)
)
GO


CREATE VIEW [AURORAX].[LeastRestrictiveEnvironmentCode]
AS
	SELECT * FROM [AURORAX].[LeastRestrictiveEnvironmentCode_LOCAL]
GO
