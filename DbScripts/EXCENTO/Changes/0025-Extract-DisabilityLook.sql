IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[DisabilityLook]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[DisabilityLook]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[DisabilityLook_LOCAL]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[DisabilityLook_LOCAL]
GO

CREATE TABLE [EXCENTO].[DisabilityLook_LOCAL](
	[DisabilityID] [nvarchar](10) NOT NULL,
	[DisabDesc] [nvarchar](80) NULL,
	[DistrictID] [nvarchar](10) NULL,
	[StateCode] [nvarchar](5) NULL,
	[DisabType] [nvarchar](10) NULL)
GO

CREATE VIEW [EXCENTO].[DisabilityLook]
AS
	SELECT * FROM [EXCENTO].[DisabilityLook_LOCAL]
GO

-- #############################################################################
-- Map Table
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[MAP_IepDisabilityID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[MAP_IepDisabilityID]
GO
CREATE TABLE [EXCENTO].[MAP_IepDisabilityID]
	(
	[DisabilityID] [nvarchar](10) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE [EXCENTO].[MAP_IepDisabilityID] ADD CONSTRAINT
	[PK_MAP_IepDisabilityID] PRIMARY KEY CLUSTERED 
	(
	DisabilityID
	) ON [PRIMARY]
GO
