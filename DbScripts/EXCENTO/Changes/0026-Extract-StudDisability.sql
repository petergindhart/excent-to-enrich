IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[StudDisability]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[StudDisability]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[StudDisability_LOCAL]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[StudDisability_LOCAL]
GO

CREATE TABLE [EXCENTO].[StudDisability_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[RecNum] [bigint] IDENTITY(1,1) NOT NULL,
	[DisabilityID] [nvarchar](10) NOT NULL,
	[DisOrder] [int] NULL,
	[DisabilityDesc] [nvarchar](80) NULL,
	[PrimaryDiasb] [bit] NULL,
	[CreateID] [nvarchar](20) NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NULL,
	[StudDisabilityGID] [char](32) NOT NULL) 
GO

CREATE VIEW [EXCENTO].[StudDisability]
AS
	SELECT * FROM [EXCENTO].[StudDisability_LOCAL]
GO


-- #############################################################################
-- Map Table
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[MAP_EligibilityActivityID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[MAP_EligibilityActivityID]
GO
CREATE TABLE [EXCENTO].[MAP_EligibilityActivityID]
	(
	GStudentID uniqueidentifier NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE [EXCENTO].[MAP_EligibilityActivityID] ADD CONSTRAINT
	[PK_MAP_EligibilityActivityID] PRIMARY KEY CLUSTERED 
	(
	GStudentID
	) ON [PRIMARY]
GO