IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[IEPSpecialFactorTbl_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[IEPSpecialFactorTbl_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[IEPSpecialFactorTbl]'))
DROP VIEW [EXCENTO].[IEPSpecialFactorTbl]
GO

CREATE TABLE [EXCENTO].[IEPSpecialFactorTbl_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[Considered1] [bit] NULL,
	[Considered2] [bit] NULL,
	[Considered3] [bit] NULL,
	[Considered4] [bit] NULL,
	[Considered5] [bit] NULL,
	[Considered6] [bit] NULL,
	[Considered7] [bit] NULL,
	[Considered8] [bit] NULL,
	[Braille] [int] NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NULL DEFAULT (0),
	[LEP] [bit] NULL,
	[StrengthConc] [bit] NULL,
	[ESYDeter] [datetime] NULL,
	[RecNum] [int] IDENTITY(1,1) NOT NULL,
	[Considered8NA] [bit] NULL,
 CONSTRAINT [PK_RecNum] PRIMARY KEY CLUSTERED 
(
	[RecNum] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE VIEW [EXCENTO].[IEPSpecialFactorTbl]
AS
	SELECT * FROM [EXCENTO].[IEPSpecialFactorTbl_LOCAL]
GO
