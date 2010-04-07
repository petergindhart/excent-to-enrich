IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[SC_PermEvalTbl_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[SC_PermEvalTbl_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[SC_PermEvalTbl]'))
DROP VIEW [EXCENTO].[SC_PermEvalTbl]
GO

CREATE TABLE [EXCENTO].[SC_PermEvalTbl_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[PermEvalSeqNum] [bigint] NOT NULL,
	[ReferPerson] [nvarchar](65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReferTitle] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReferDate] [datetime] NULL,
	[LetterDate] [datetime] NULL,
	[ReferReason] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OptionsConsidered] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EvalProcedure] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OtherFactors] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SpecificTests] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderName] [nvarchar](65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderTitle] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderPhone] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Enclosure1] [bit] NULL,
	[Enclosure2] [bit] NULL,
	[Enclosure3] [bit] NULL,
	[Enclosure4] [bit] NULL,
	[EnclosureOther] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReceiveDate] [datetime] NULL,
	[ParentResponse] [int] NULL,
	[PermissionEye] [bit] NULL,
	[PermissionAgency] [bit] NULL,
	[PermissionMedicaid] [bit] NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NOT NULL DEFAULT (0),
	[SavedPDF] [image] NULL
 CONSTRAINT [PK_SC_PermEvalTbl] PRIMARY KEY CLUSTERED (	[PermEvalSeqNum] ASC )
 )
GO


CREATE VIEW [EXCENTO].[SC_PermEvalTbl]
AS
	SELECT * FROM [EXCENTO].[SC_PermEvalTbl_LOCAL]
GO


-- #############################################################################
-- SC_PermEvalTbl
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[MAP_FileData_SC_PermEvalTbl]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[MAP_FileData_SC_PermEvalTbl]
GO
CREATE TABLE [EXCENTO].[MAP_FileData_SC_PermEvalTbl]
	(
	PermEvalSeqNum int NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO

ALTER TABLE [EXCENTO].[MAP_FileData_SC_PermEvalTbl] ADD CONSTRAINT
	[PK_MAP_FileData_SC_PermEvalTbl] PRIMARY KEY CLUSTERED
	(
	PermEvalSeqNum
	) ON [PRIMARY]
GO
