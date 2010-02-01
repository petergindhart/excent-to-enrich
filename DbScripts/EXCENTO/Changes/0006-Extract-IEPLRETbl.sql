IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[IEPLRETbl]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[IEPLRETbl]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[IEPLRETbl_LOCAL]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [EXCENTO].[IEPLRETbl_LOCAL]
GO

CREATE TABLE [EXCENTO].[IEPLRETbl_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[IEPLRESeqNum] [bigint] NOT NULL,
	[LRECode] [nvarchar] NULL,
	[CreateID] [nvarchar] NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar] NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar] NULL,
	[DeleteDate] [datetime] NULL,
	[Del_Flag] [bit] NULL
) ON [PRIMARY]
GO

CREATE VIEW [EXCENTO].[IEPLRETbl]
AS
	SELECT * FROM [EXCENTO].[IEPLRETbl_LOCAL]
GO