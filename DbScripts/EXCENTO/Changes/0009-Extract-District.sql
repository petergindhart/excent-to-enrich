IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[District]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[District]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[District_LOCAL]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [EXCENTO].[District_LOCAL]
GO

CREATE TABLE [EXCENTO].[District_LOCAL](
	[DistrictID] [nvarchar](10) NOT NULL,
	[DistrictName] [nvarchar](50) NULL,
	[StateCode] [nvarchar](4) NULL,
	[DistrictGID] [char](32) NOT NULL,
	[SchoolType] [nvarchar](80) NULL
) ON [PRIMARY]
GO

CREATE VIEW [EXCENTO].[District]
AS
	SELECT * FROM [EXCENTO].[District_LOCAL]
GO

-- #############################################################################
-- District
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[MAP_DistrictID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[MAP_DistrictID]
GO
CREATE TABLE [EXCENTO].[MAP_DistrictID]
	(
	GDistrictID [nvarchar](10) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE [EXCENTO].[MAP_DistrictID] ADD CONSTRAINT
	[PK_MAP_DistrictID] PRIMARY KEY CLUSTERED 
	(
	GDistrictID
	) ON [PRIMARY]
GO
