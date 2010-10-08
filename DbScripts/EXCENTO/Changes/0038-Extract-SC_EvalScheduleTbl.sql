IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[SC_EvalScheduleTbl_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[SC_EvalScheduleTbl_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[SC_EvalScheduleTbl]'))
DROP VIEW [EXCENTO].[SC_EvalScheduleTbl]
GO

CREATE TABLE [EXCENTO].[SC_EvalScheduleTbl_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[EvalSchedSeqNum] [bigint] NOT NULL,
	[NoticeDate] [datetime] NULL,
	[EvaluationDate] [datetime] NULL,
	[SenderName] [nvarchar](65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderTitle] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderPhone] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClosingParagraph] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Enclosures] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NOT NULL DEFAULT (0),
	[EvaluationLatestDate] [datetime] NULL,
	[SavedPDF] [image] NULL
 CONSTRAINT [PK_SC_EvalScheduleTbl] PRIMARY KEY CLUSTERED (	[EvalSchedSeqNum] ASC )
 )
GO


CREATE VIEW [EXCENTO].[SC_EvalScheduleTbl]
AS
	SELECT * FROM [EXCENTO].[SC_EvalScheduleTbl_LOCAL]
GO

-- #############################################################################
-- SC_EvalScheduleTbl
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[MAP_FileData_SC_EvalScheduleTbl]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[MAP_FileData_SC_EvalScheduleTbl]
GO
CREATE TABLE [EXCENTO].[MAP_FileData_SC_EvalScheduleTbl]
	(
	EvalSchedSeqNum int NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO

ALTER TABLE [EXCENTO].[MAP_FileData_SC_EvalScheduleTbl] ADD CONSTRAINT
	[PK_MAP_FileData_SC_EvalScheduleTbl] PRIMARY KEY CLUSTERED
	(
	EvalSchedSeqNum
	) ON [PRIMARY]
GO
