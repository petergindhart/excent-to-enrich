IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[AURORAX].[PositionId_LOCAL]') AND type in (N'U'))
DROP TABLE [AURORAX].[PositionId_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[AURORAX].[PositionId]'))
DROP VIEW [AURORAX].[PositionId]
GO

CREATE TABLE [AURORAX].[PositionId_LOCAL](
PositionId    varchar(10), 
PositionDescription    varchar(100)
)
GO

CREATE VIEW [AURORAX].[PositionId]
AS
	SELECT * FROM [AURORAX].[PositionId_LOCAL]
GO
