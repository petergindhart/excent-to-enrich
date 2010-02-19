IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[ICIEPSpecialFactorTbl]'))
DROP VIEW [EXCENTO].[ICIEPSpecialFactorTbl]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[ICIEPSpecialFactorTbl_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[ICIEPSpecialFactorTbl_LOCAL]
GO

CREATE TABLE [EXCENTO].[ICIEPSpecialFactorTbl_LOCAL](
	[IEPComplSeqNum] [bigint] NOT NULL,
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
	[RecNum] [int] NOT NULL,
	[Considered8NA] [bit] NULL
) ON [PRIMARY]
GO


CREATE VIEW [EXCENTO].[ICIEPSpecialFactorTbl]
AS
	SELECT * FROM [EXCENTO].[ICIEPSpecialFactorTbl_LOCAL]
GO
