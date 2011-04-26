/*

*/
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[AURORAX].[School_LOCAL]') AND type in (N'U'))
DROP TABLE [AURORAX].[School_LOCAL]
GO

CREATE TABLE [AURORAX].[School_LOCAL](
SchoolRefID    varchar(150),
SchoolCode    varchar(10),
SchoolAbbreviation    varchar(10),
SchoolName    varchar(255),
DistrictRefID    varchar(150)
)
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[AURORAX].[School]'))
DROP VIEW [AURORAX].[School]
GO

CREATE VIEW [AURORAX].[School]  
AS
 SELECT * FROM [AURORAX].[School_LOCAL]  
GO  
--