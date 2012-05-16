IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[ICIEPAccomModTbl]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[ICIEPAccomModTbl]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[ICIEPAccomModTbl_LOCAL]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [EXCENTO].[ICIEPAccomModTbl_LOCAL]
GO

CREATE TABLE [EXCENTO].[ICIEPAccomModTbl_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[IEPComplSeqNum] [bigint] NOT NULL,
	[IEPAccomSeq] [bigint] NOT NULL,
	[Code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccomDesc] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccomLevel] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccomType] [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SubType] [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Date01] [datetime] NULL,
	[Pass] [bit] NULL,
	[PartAccom] [bit] NULL,
	[NotPart] [bit] NULL,
	[NA] [bit] NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE VIEW [EXCENTO].[ICIEPAccomModTbl]
AS
	SELECT * FROM [EXCENTO].[IEPAccomModTbl_LOCAL]
GO
