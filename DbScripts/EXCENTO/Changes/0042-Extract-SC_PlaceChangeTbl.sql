IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[SC_PlaceChangeTbl_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[SC_PlaceChangeTbl_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[SC_PlaceChangeTbl]'))
DROP VIEW [EXCENTO].[SC_PlaceChangeTbl]
GO

CREATE TABLE [EXCENTO].[SC_PlaceChangeTbl_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[PlaceChangeSeqNum] [bigint] NOT NULL,
	[Date] [datetime] NULL,
	[ProposedAction] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProposalReason] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProcedureTest] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OtherOptions] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OtherFactors] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NOT NULL DEFAULT (0),
	[SavedPDF] [image] NULL
 CONSTRAINT [PK_SC_PLaceChangeTbl] PRIMARY KEY CLUSTERED(	[PlaceChangeSeqNum] ASC)
 )
GO


CREATE VIEW [EXCENTO].[SC_PlaceChangeTbl]
AS
	SELECT * FROM [EXCENTO].[SC_PlaceChangeTbl_LOCAL]
GO

-- #############################################################################
-- SC_PlaceChangeTbl
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[MAP_FileData_SC_PlaceChangeTbl]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[MAP_FileData_SC_PlaceChangeTbl]
GO
CREATE TABLE [EXCENTO].[MAP_FileData_SC_PlaceChangeTbl]
	(
	PlaceChangeSeqNum int NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO

ALTER TABLE [EXCENTO].[MAP_FileData_SC_PlaceChangeTbl] ADD CONSTRAINT
	[PK_MAP_FileData_SC_PlaceChangeTbl] PRIMARY KEY CLUSTERED
	(
	PlaceChangeSeqNum
	) ON [PRIMARY]
GO
