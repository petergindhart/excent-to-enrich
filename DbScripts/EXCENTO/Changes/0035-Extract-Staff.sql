IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[Staff_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[Staff_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[Staff]'))
DROP VIEW [EXCENTO].[Staff]
GO

CREATE TABLE [EXCENTO].[Staff_LOCAL](
	[StaffGID] [uniqueidentifier] NOT NULL,
	[StaffID] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastName] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LoginPwd] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PlanPeriod] [int] NULL,
	[FTE] [numeric](18, 0) NULL,
	[Phone] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StaffMember] [bit] NULL,
	[Certificate] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LoginName] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RoleID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonCode] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DistrictID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Certified] [bit] NULL,
	[LastAccessedSchID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastAccessedStud] [uniqueidentifier] NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NOT NULL DEFAULT (0),
	[RoleLevel] [int] NULL,
	[SOF] [bit] NULL,
	[MedicaidCertified] [bit] NULL,
	[MedicaidCertNum] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SOFReceivedDate] [datetime] NULL,
	[Sex] [nvarchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ethnic] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Qualify] [bit] NULL,
	[HighQual] [bit] NULL,
	[Account] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Staf_SIFID] [char](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PasswordExpirationDate] [bit] NULL
)
GO


CREATE VIEW [EXCENTO].[Staff]
AS
	SELECT * FROM [EXCENTO].[Staff_LOCAL]
GO