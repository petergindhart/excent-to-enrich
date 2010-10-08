IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[MemoLook_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[MemoLook_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[MemoLook]'))
DROP VIEW [EXCENTO].[MemoLook]
GO

CREATE TABLE [EXCENTO].[MemoLook_LOCAL](
	[RecNum] [bigint] NOT NULL,
	[UsageID] [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Memo] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DistrictID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateCode] [nvarchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_MemoLook] PRIMARY KEY CLUSTERED 
(
	[RecNum] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


CREATE VIEW [EXCENTO].[MemoLook]
AS
	SELECT * FROM [EXCENTO].[MemoLook_LOCAL]
GO


-- #############################################################################
-- ServiceDefID
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[MAP_ServiceDefID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[MAP_ServiceDefID]
GO
CREATE TABLE [EXCENTO].[MAP_ServiceDefID]
	(
	[Memo] [nvarchar](100) NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE [EXCENTO].[MAP_ServiceDefID] ADD CONSTRAINT
	[PK_MAP_ServiceDefID] PRIMARY KEY CLUSTERED
	(
	[Memo]
	) ON [PRIMARY]
GO

