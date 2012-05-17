IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[SC_ConsentReEvalTbl_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[SC_ConsentReEvalTbl_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[SC_ConsentReEvalTbl]'))
DROP VIEW [EXCENTO].[SC_ConsentReEvalTbl]
GO

CREATE TABLE [EXCENTO].[SC_ConsentReEvalTbl_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[ConsentReevalSeqNum] [bigint] NOT NULL,
	[NoticeDate] [datetime] NULL,
	[ReevalDate] [datetime] NULL,
	[LastEvalDate] [datetime] NULL,
	[SpecificTest] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderName] [nvarchar](65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderTitle] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderPhone] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Enclosure1] [bit] NULL,
	[Enclosure2] [bit] NULL,
	[Enclosure3] [bit] NULL,
	[Enclosure4] [bit] NULL,
	[Enclosure5] [bit] NULL,
	[EnclosureOther] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReceiveDate] [datetime] NULL,
	[ParentResponse] [int] NULL,
	[PermissionEye] [bit] NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NOT NULL DEFAULT (0),
	[SavedPDF] [image] NULL
 CONSTRAINT [PK_SC_ConsentReEvalTbl] PRIMARY KEY CLUSTERED ([ConsentReevalSeqNum] ASC)
 )
GO
-- #############################################################################
-- SC_ConsentReEvalTbl
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[MAP_FileData_SC_ConsentReEvalTbl]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[MAP_FileData_SC_ConsentReEvalTbl]
GO
CREATE TABLE [EXCENTO].[MAP_FileData_SC_ConsentReEvalTbl]
	(
	ConsentReevalSeqNum int NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO

ALTER TABLE [EXCENTO].[MAP_FileData_SC_ConsentReEvalTbl] ADD CONSTRAINT
	[PK_MAP_FileData_SC_ConsentReEvalTbl] PRIMARY KEY CLUSTERED
	(
	ConsentReevalSeqNum
	) ON [PRIMARY]
GO

