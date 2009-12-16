IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[IEPTbl]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[IEPTbl]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[IEPTbl_LOCAL]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [EXCENTO].[IEPTbl_LOCAL]
GO

CREATE TABLE [EXCENTO].[IEPTbl_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[IEPSeqNum] [bigint] NOT NULL,
	[MeetDate] [datetime] NULL,
	[IEPAppDate] [datetime] NULL,
	[ReviewDate] [datetime] NULL,
	[CurrEvalDate] [datetime] NULL,
	[ReEvalDate] [datetime] NULL,
	[LastIEPDate] [datetime] NULL,
	[IEPType] [nvarchar](80) NULL,
	[CaseMgr] [nvarchar](65) NULL,
	[CaseMgrTitle] [nvarchar](60) NULL,
	[CaseMgrPhone] [nvarchar](20) NULL,
	[IEPComplete] [nvarchar](15) NULL,
	[CreateID] [nvarchar](20) NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) NULL,
	[DeleteDate] [datetime] NULL,
	[Del_Flag] [bit] NULL,
	[ImplDate] [datetime] NULL,
	[ParentParticipated] [bit] NULL,
	[SpecRevMeetDate] [datetime] NULL
) ON [PRIMARY]
GO

CREATE VIEW [EXCENTO].[IEPTbl]
AS
	SELECT * FROM [EXCENTO].[IEPTbl_LOCAL]
GO