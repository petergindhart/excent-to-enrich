IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[ICIEPModTbl_SC_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[ICIEPModTbl_SC_LOCAL]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[ICIEPModTbl_SC]'))
DROP VIEW [EXCENTO].[ICIEPModTbl_SC]
GO

CREATE TABLE [EXCENTO].[ICIEPModTbl_SC](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[IEPComplSeqNum] [bigint] NULL,
	[IEPModSeq] [bigint] NOT NULL,
	[SupplementAids] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Modifications] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProgramModify] [bit] NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DeleteDate] [datetime] NULL,
	[Del_Flag] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


CREATE VIEW [EXCENTO].[ICIEPModTbl_SC]
AS
	SELECT * FROM [EXCENTO].[ICIEPModTbl_SC_LOCAL]
GO

