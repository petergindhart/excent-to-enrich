IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[IEPCompleteTbl_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[IEPCompleteTbl_LOCAL]
GO

CREATE TABLE [EXCENTO].[IEPCompleteTbl_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[IEPSeqNum] [bigint] IDENTITY(1,1) NOT NULL,
	[RecNum] [bigint] NOT NULL,
	[MeetDate] [datetime] NULL,
	[IEPAppDate] [datetime] NULL,
	[ReviewDate] [datetime] NULL,
	[CurrEvalDate] [datetime] NULL,
	[ReEvalDate] [datetime] NULL,
	[LastIEPDate] [datetime] NULL,
	[IEPType] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CaseMgr] [nvarchar](65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CaseMgrTitle] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IEPComplete] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IEPCompleteDate] [datetime] NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NULL,
	[CaseMgrPhone] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ParentParticipated] [bit] NULL,
	[SpecRevMeetDate] [datetime] NULL,
 CONSTRAINT [PK_IEPCompleteTbl] PRIMARY KEY NONCLUSTERED
(
	[IEPSeqNum] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE VIEW [EXCENTO].[IEPCompleteTbl]
AS
	SELECT * FROM [EXCENTO].[IEPCompleteTbl_LOCAL]
GO
