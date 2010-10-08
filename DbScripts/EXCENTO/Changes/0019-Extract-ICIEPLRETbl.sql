IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[ICIEPLRETbl]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[ICIEPLRETbl]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[ICIEPLRETbl_LOCAL]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [EXCENTO].[ICIEPLRETbl_LOCAL]
GO

CREATE TABLE [EXCENTO].[ICIEPLRETbl_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[IEPComplSeqNum] [bigint] NOT NULL,
	[IEPLRESeqNum] [bigint] NOT NULL,
	[LRECode] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LRESetting1] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LRESetting2] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LRESetting3] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LRESetting4] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FedSet01] [bit] NULL,
	[FedSet02] [bit] NULL,
	[FedSet03] [bit] NULL,
	[FedSet04] [bit] NULL,
	[FedSet05] [bit] NULL,
	[FedSet06] [bit] NULL,
	[FedSet07] [bit] NULL,
	[FedSet08] [bit] NULL,
	[FedSet09] [bit] NULL,
	[FedSet10] [bit] NULL,
	[FedSet11] [bit] NULL,
	[FedSet12] [bit] NULL,
	[Method] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Consider1] [int] NULL,
	[Consider2] [int] NULL,
	[Consider3] [int] NULL,
	[Consider4] [int] NULL,
	[LRESettings08] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LRESettings09] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LRESettings10] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LRESettings11] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LRESettings12] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LRESettings13] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LRESettings14] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LRESettings15] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConsiderExp1] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConsiderExp2] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConsiderExp3] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConsiderExp4] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FedSet13] [bit] NULL,
	[FedSet14] [bit] NULL,
	[FedSet15] [bit] NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NULL,
	[LREType] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE VIEW [EXCENTO].[ICIEPLRETbl]
AS
	SELECT * FROM [EXCENTO].[ICIEPLRETbl_LOCAL]
GO
