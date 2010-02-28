IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[IEPModTbl_SC_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[IEPModTbl_SC_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[IEPModTbl_SC]'))
DROP VIEW [EXCENTO].[IEPModTbl_SC]
GO

CREATE TABLE [EXCENTO].[IEPModTbl_SC_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[IEPModSeq] [bigint] IDENTITY(1,1) NOT NULL,
	[SupplementAids] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Modifications] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProgramModify] [bit] NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DeleteDate] [datetime] NULL,
	[Del_Flag] [bit] NOT NULL,
 CONSTRAINT [PK_IEPModTbl_SC] PRIMARY KEY NONCLUSTERED 
(
	[IEPModSeq] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


CREATE VIEW [EXCENTO].[IEPModTbl_SC]
AS
	SELECT * FROM [EXCENTO].[IEPModTbl_SC_LOCAL]
GO
-- Last line