IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[SC_PlaceConsentTbl_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[SC_PlaceConsentTbl_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[SC_PlaceConsentTbl]'))
DROP VIEW [EXCENTO].[SC_PlaceConsentTbl]
GO

CREATE TABLE [EXCENTO].[SC_PlaceConsentTbl_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[PlaceConsentSeqNum] [bigint] NOT NULL,
	[InitialDate] [datetime] NULL,
	[FollowDate] [datetime] NULL,
	[Category] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Model] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReturnForm] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderName] [nvarchar](65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderTitle] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SenderPhone] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReceiveDate] [datetime] NULL,
	[ParentResponse] [int] NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NOT NULL DEFAULT (0),
	[SavedPDF] [image] NULL
 CONSTRAINT [PK_SC_PlaceConsentTbl] PRIMARY KEY CLUSTERED(	[PlaceConsentSeqNum] ASC)
 )
 GO


CREATE VIEW [EXCENTO].[SC_PlaceConsentTbl]
AS
	SELECT * FROM [EXCENTO].[SC_PlaceConsentTbl_LOCAL]
GO

-- #############################################################################
-- SC_PlaceConsentTbl
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[MAP_FileData_SC_PlaceConsentTbl]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[MAP_FileData_SC_PlaceConsentTbl]
GO
CREATE TABLE [EXCENTO].[MAP_FileData_SC_PlaceConsentTbl]
	(
	PlaceConsentSeqNum int NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO

ALTER TABLE [EXCENTO].[MAP_FileData_SC_PlaceConsentTbl] ADD CONSTRAINT
	[PK_MAP_FileData_SC_PlaceConsentTbl] PRIMARY KEY CLUSTERED
	(
	PlaceConsentSeqNum
	) ON [PRIMARY]
GO

