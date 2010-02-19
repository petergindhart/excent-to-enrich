IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[IEPArchiveDocTbl_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[IEPArchiveDocTbl_LOCAL]
GO

CREATE TABLE [EXCENTO].[IEPArchiveDocTbl_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[IEPCompletedate] [datetime] NOT NULL,
	[DocType] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PdfXmlFile] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecNum] [bigint] NOT NULL,
	[SeqNum] [bigint] NOT NULL,
	[PDFImage] [image] NULL
CONSTRAINT [PK_IEPArchiveDocTbl] PRIMARY KEY CLUSTERED
(
	[RecNum] ASC
) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[IEPArchiveDocTbl]'))
DROP VIEW [EXCENTO].[IEPArchiveDocTbl]
GO

CREATE VIEW EXCENTO.IEPArchiveDocTbl
AS
	SELECT * FROM EXCENTO.IEPArchiveDocTbl_LOCAL
GO

-- #############################################################################
-- IEPArchiveDocTbl
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[MAP_FileDataID]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [EXCENTO].[MAP_FileDataID]
GO
CREATE TABLE [EXCENTO].[MAP_FileDataID]
	(
	RecNum int NOT NULL,
	DestID uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO

ALTER TABLE [EXCENTO].[MAP_FileDataID] ADD CONSTRAINT
	[PK_MAP_FileDataID] PRIMARY KEY CLUSTERED
	(
	RecNum
	) ON [PRIMARY]
GO
