/**/
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[AURORAX].[District_LOCAL]') AND type in (N'U'))
DROP TABLE [AURORAX].[District_LOCAL]
GO

CREATE TABLE [AURORAX].[District_LOCAL](
DistrictRefID    varchar(150),
DistrictCode    varchar(10),
DistrictName    varchar(255)
)
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[AURORAX].[District]'))
DROP VIEW [AURORAX].[District]
GO  

CREATE VIEW [AURORAX].[District]
AS
 SELECT * FROM [AURORAX].[District_LOCAL]
GO
