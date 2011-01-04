IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[AURORAX].[PostSchoolAreaCode_LOCAL]') AND type in (N'U'))
DROP TABLE [AURORAX].[PostSchoolAreaCode_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[AURORAX].[PostSchoolAreaCode]'))
DROP VIEW [AURORAX].[PostSchoolAreaCode]
GO

CREATE TABLE [AURORAX].[PostSchoolAreaCode_LOCAL](
PostSchoolAreaCode    varchar(10) NOT NULL,
PostSchoolAreaDescription    varchar(100) NOT NULL,
Sequence					int				NULL
)
GO

CREATE VIEW [AURORAX].[PostSchoolAreaCode]
AS
	SELECT * FROM [AURORAX].[PostSchoolAreaCode_LOCAL]
GO
