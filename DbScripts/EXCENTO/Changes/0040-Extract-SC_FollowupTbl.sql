IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[SC_FollowupTbl_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[SC_FollowupTbl_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[SC_FollowupTbl]'))
DROP VIEW [EXCENTO].[SC_FollowupTbl]
GO

CREATE TABLE [EXCENTO].[SC_FollowupTbl_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[FollowupSeqNum] [bigint] NOT NULL,
	[NoticeDate] [datetime] NULL,
	[Determination] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderTitle] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderPhone] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Enclosure1] [bit] NULL,
	[Enclosure2] [bit] NULL,
	[Enclosure3] [bit] NULL,
	[EnclosureOther] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NOT NULL DEFAULT (0),
	[SavedPDF] [image] NULL
 CONSTRAINT [PK_SC_FollowupTbl] PRIMARY KEY CLUSTERED(	[FollowupSeqNum] ASC)
 )
GO

CREATE VIEW [EXCENTO].[SC_FollowupTbl]
AS
	SELECT * FROM [EXCENTO].[SC_FollowupTbl_LOCAL]
GO

-- #############################################################################
-- SC_FollowupTbl
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[MAP_FileData_SC_FollowupTbl]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[MAP_FileData_SC_FollowupTbl]
GO
CREATE TABLE [EXCENTO].[MAP_FileData_SC_FollowupTbl]
	(
	FollowupSeqNum int NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO

ALTER TABLE [EXCENTO].[MAP_FileData_SC_FollowupTbl] ADD CONSTRAINT
	[PK_MAP_FileData_SC_FollowupTbl] PRIMARY KEY CLUSTERED
	(
	FollowupSeqNum
	) ON [PRIMARY]
GO

