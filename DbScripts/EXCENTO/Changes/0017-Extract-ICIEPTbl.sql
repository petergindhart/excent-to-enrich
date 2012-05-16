IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[ICIEPTbl]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[ICIEPTbl]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[ICIEPTbl_LOCAL]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [EXCENTO].[ICIEPTbl_LOCAL]
GO

CREATE TABLE [EXCENTO].[ICIEPTbl_LOCAL](
	[IEPComplSeqNum] [bigint] NOT NULL,
	[GStudentID] [uniqueidentifier] NOT NULL,
	[IEPSeqNum] [bigint] NOT NULL,
	[MeetDate] [datetime] NULL,
	[IEPAppDate] [datetime] NULL,
	[ReviewDate] [datetime] NULL,
	[CurrEvalDate] [datetime] NULL,
	[ReEvalDate] [datetime] NULL,
	[LastIEPDate] [datetime] NULL,
	[IEPType] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CaseMgr] [nvarchar](65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CaseMgrTitle] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CaseMgrPhone] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IEPComplete] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DeleteDate] [datetime] NULL,
	[Del_Flag] [bit] NULL,
	[ImplDate] [datetime] NULL,
	[ParentParticipated] [bit] NULL,
	[SpecRevMeetDate] [datetime] NULL
) ON [PRIMARY]
GO


CREATE VIEW [EXCENTO].[ICIEPTbl]
AS
	SELECT * FROM [EXCENTO].[ICIEPTbl_LOCAL]
GO
