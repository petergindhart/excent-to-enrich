IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[School]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[School]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[School_LOCAL]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [EXCENTO].[School_LOCAL]
GO

CREATE TABLE [EXCENTO].[School_LOCAL](
	[SchoolID] [nvarchar](10) NOT NULL,
	[SchoolName] [nvarchar](50) NULL,
	[DistrictID] [nvarchar](10) NULL,
	[SchPhone] [nvarchar](25) NULL,
	[Email] [nvarchar](50) NULL,
	[ReportHeader1] [nvarchar](160) NULL,
	[ReportHeader2] [nvarchar](160) NULL,
	[MinPerWeek] [numeric](18, 0) NULL,
	[CreateID] [nvarchar](20) NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NULL,
	[SchoolRegion] [nvarchar](80) NULL,
	[SchoolType] [nvarchar](80) NULL,
	[SchoolGID] [char](32) NOT NULL,
	[SchoolSIFID] [char](32) NULL
) ON [PRIMARY]
GO

CREATE VIEW [EXCENTO].[School]
AS
	SELECT * FROM [EXCENTO].[School_LOCAL]
GO

-- #############################################################################
-- School
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[MAP_SchoolID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[MAP_SchoolID]
GO
CREATE TABLE [EXCENTO].[MAP_SchoolID]
	(
	SchoolID [nvarchar](10) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE [EXCENTO].[MAP_SchoolID] ADD CONSTRAINT
	[PK_MAP_SchoolID] PRIMARY KEY CLUSTERED 
	(
	SchoolID
	) ON [PRIMARY]
GO