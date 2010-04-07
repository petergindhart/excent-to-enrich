IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[PriorNoticeTbl_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[PriorNoticeTbl_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[PriorNoticeTbl]'))
DROP VIEW [EXCENTO].[PriorNoticeTbl]
GO

CREATE TABLE [EXCENTO].[PriorNoticeTbl_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[NoticeDate] [datetime] NULL,
	[PropActions] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderName] [varchar](65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MeetPurpose] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActionRefused] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReasonRejected] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DeterBase] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OtherInfo] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProcSafe] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactAssist] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InitDate] [datetime] NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[MeetingDate] [datetime] NULL,
	[PriorSeqNum] [bigint] NOT NULL,
	[DocReturn] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [int] NULL,
	[Question1] [bit] NULL,
	[Question2] [bit] NULL,
	[Question3] [bit] NULL,
	[Question4] [bit] NULL,
	[Question5] [bit] NULL,
	[Question6] [bit] NULL,
	[OtherDesc] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Sender] [nvarchar](65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Fax] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NULL,
	[PropRefuse] [bit] NULL,
	[Location] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SavedPDF] [image] NULL
 CONSTRAINT [PK_PriorNoticeTbl] PRIMARY KEY NONCLUSTERED(	[PriorSeqNum] ASC)
 )
GO


CREATE VIEW [EXCENTO].[PriorNoticeTbl]
AS
	SELECT * FROM [EXCENTO].[PriorNoticeTbl_LOCAL]
GO

-- #############################################################################
-- PriorNoticeTbl
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[MAP_FileData_PriorNoticeTbl]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[MAP_FileData_PriorNoticeTbl]
GO
CREATE TABLE [EXCENTO].[MAP_FileData_PriorNoticeTbl]
	(
	PriorSeqNum int NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO

ALTER TABLE [EXCENTO].[MAP_FileData_PriorNoticeTbl] ADD CONSTRAINT
	[PK_MAP_FileData_PriorNoticeTbl] PRIMARY KEY CLUSTERED
	(
	PriorSeqNum
	) ON [PRIMARY]
GO
