/*
Note:  Had attempted to not create Lookups_LOCAL here but had to add the code back in because the FFETL does not run before upgrade_db

*/

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[AURORAX].[Lookups_LOCAL]') AND type in (N'U'))
DROP TABLE [AURORAX].[Lookups_LOCAL]
GO

CREATE TABLE [AURORAX].[Lookups_LOCAL](
Type    varchar(20) not null,
Code    varchar(150) not null,
StateCode varchar(150) not null,
Label    varchar(255) not null,
Sequence    int NULL
)
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[AURORAX].[Lookups]'))
DROP VIEW [AURORAX].[Lookups]
GO


CREATE VIEW [AURORAX].[Lookups]
AS
	SELECT * FROM [AURORAX].[Lookups_LOCAL]
GO
--