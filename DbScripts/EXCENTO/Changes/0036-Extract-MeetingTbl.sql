IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[MeetingTbl_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[MeetingTbl_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[MeetingTbl]'))
DROP VIEW [EXCENTO].[MeetingTbl]
GO

CREATE TABLE [EXCENTO].[MeetingTbl_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[MeetSeqNum] [bigint] NOT NULL,
	[SafeGuarde] [bit] NULL,
	[LetterDate] [datetime] NULL,
	[MeetingDate] [datetime] NULL,
	[StartTime] [datetime] NULL,
	[Location] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DearField] [nvarchar](65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MeetPurpose] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderName] [nvarchar](65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderTitle] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderPhone] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Attempt1] [datetime] NULL,
	[Attempt2] [datetime] NULL,
	[Attempt3] [datetime] NULL,
	[ParResponse] [int] NULL,
	[MeetCode] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type1] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type2] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type3] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MeetPurCode] [nvarchar](65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NoticeDate] [datetime] NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NULL,
	[Email] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderFax] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ParRightsDate] [datetime] NULL,
	[ParRespDate] [datetime] NULL,
	[Room] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Purpose1] [bit] NULL,
	[Purpose2] [bit] NULL,
	[Purpose3] [bit] NULL,
	[Purpose4] [bit] NULL,
	[Purpose5] [bit] NULL,
	[Purpose6] [bit] NULL,
	[Purpose7] [bit] NULL,
	[Purpose8] [bit] NULL,
	[Purpose9] [bit] NULL,
	[Purpose10] [bit] NULL,
	[Purpose11] [bit] NULL,
	[Purpose12] [bit] NULL,
	[Purpose13] [bit] NULL,
	[EndTime] [datetime] NULL,
	[ParentTime] [bit] NULL,
	[Specify] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SavedPDF] [image] NULL
 CONSTRAINT [PK_MeetingTbl] PRIMARY KEY CLUSTERED (	[MeetSeqNum] ASC )
 )
GO


CREATE VIEW [EXCENTO].[MeetingTbl]
AS
	SELECT * FROM [EXCENTO].[MeetingTbl_LOCAL]
GO


-- #############################################################################
-- MeetingTbl
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[MAP_FileData_MeetingTbl]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[MAP_FileData_MeetingTbl]
GO
CREATE TABLE [EXCENTO].[MAP_FileData_MeetingTbl]
	(
	MeetSeqNum int NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO

ALTER TABLE [EXCENTO].[MAP_FileData_MeetingTbl] ADD CONSTRAINT
	[PK_MAP_FileData_MeetingTbl] PRIMARY KEY CLUSTERED
	(
	MeetSeqNum
	) ON [PRIMARY]
GO
