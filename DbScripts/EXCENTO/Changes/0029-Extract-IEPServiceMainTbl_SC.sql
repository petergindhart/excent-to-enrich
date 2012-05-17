IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[IEPServiceMainTbl_SC_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[IEPServiceMainTbl_SC_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[IEPServiceMainTbl_SC]'))
DROP VIEW [EXCENTO].[IEPServiceMainTbl_SC]
GO

CREATE TABLE [EXCENTO].[IEPServiceMainTbl_SC_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[RecNum] [int] IDENTITY(1,1) NOT NULL,
	[RelService] [bit] NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyId] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NULL,
	[DirHr] [numeric](9, 2) NULL,
	[IndirHr] [numeric](9, 2) NULL,
	[MinDesc] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_IEPServiceMainTbl_SC] PRIMARY KEY CLUSTERED 
(
	[RecNum] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


CREATE VIEW [EXCENTO].[IEPServiceMainTbl_SC]
AS
	SELECT * FROM [EXCENTO].[IEPServiceMainTbl_SC_LOCAL]
GO
