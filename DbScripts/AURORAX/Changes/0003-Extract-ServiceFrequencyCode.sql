IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[AURORAX].[ServiceFrequencyCode_LOCAL]') AND type in (N'U'))
DROP TABLE [AURORAX].[ServiceFrequencyCode_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[AURORAX].[ServiceFrequencyCode]'))
DROP VIEW [AURORAX].[ServiceFrequencyCode]
GO

CREATE TABLE [AURORAX].[ServiceFrequencyCode_LOCAL](
ServiceFrequencyCode	int		not null,
ServiceFrequencyDescription	varchar(100)	not null
)
GO


CREATE VIEW [AURORAX].[ServiceFrequencyCode]
AS
	SELECT * FROM [AURORAX].[ServiceFrequencyCode_LOCAL]
GO
