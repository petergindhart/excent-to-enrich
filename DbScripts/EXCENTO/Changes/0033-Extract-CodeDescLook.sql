IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[CodeDescLook_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[CodeDescLook_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[CodeDescLook]'))
DROP VIEW [EXCENTO].[CodeDescLook]
GO

CREATE TABLE [EXCENTO].[CodeDescLook_LOCAL](
	[RecNum] [bigint] NOT NULL,
	[UsageID] [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LookDesc] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DistrictID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateCode] [nvarchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExtraData] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExtraData2] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Modifier] [nvarchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_CodeDescLook] PRIMARY KEY CLUSTERED 
(
	[RecNum] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE VIEW [EXCENTO].[CodeDescLook]
AS
	SELECT * FROM [EXCENTO].[CodeDescLook_LOCAL]
GO

-- #############################################################################
-- IepGoalAreaID
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'EXCENTO.MAP_IepGoalAreaID') AND type in (N'U'))
DROP TABLE EXCENTO.MAP_IepGoalAreaID
GO

CREATE TABLE EXCENTO.MAP_IepGoalAreaID (
-- BankCode	varchar(10)	not null,
BankDesc	varchar(80)	not null,
DestID		uniqueidentifier not null
)
ALTER TABLE EXCENTO.MAP_IepGoalAreaID 
	ADD CONSTRAINT PK_MAP_IepGoalAreaID 
		PRIMARY KEY CLUSTERED (BankDesc)
GO

