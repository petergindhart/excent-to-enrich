IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[ServiceTbl_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[ServiceTbl_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[ServiceTbl]'))
DROP VIEW [EXCENTO].[ServiceTbl]
GO

CREATE TABLE [EXCENTO].[ServiceTbl_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[ServCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServDesc] [nvarchar](120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProvCode] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProvDesc] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LocationCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LocationDesc] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Frequency] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InitDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[DirHr] [numeric](18, 2) NULL,
	[IndirHr] [numeric](18, 2) NULL,
	[TotalHr] [numeric](18, 0) NULL,
	[ESY] [bit] NULL,
	[Type] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Subject] [nvarchar](160) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Teacher] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Linkages] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TimeServiced] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Duration] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServSeqNum] [bigint] NOT NULL,
	[GenEdMin] [numeric](18, 0) NULL,
	[Position1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Position2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServType] [bit] NULL,
	[Resource] [bit] NULL,
	[Setting] [bit] NULL,
	[Include1] [bit] NULL,
	[Include2] [bit] NULL,
	[TotalMin] [numeric](18, 0) NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NULL,
	[ServOrder] [int] NULL,
	[RelServDesc] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Length] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_ServiceTbl] PRIMARY KEY NONCLUSTERED 
(
	[ServSeqNum] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


CREATE VIEW [EXCENTO].[ServiceTbl]
AS
	SELECT * FROM [EXCENTO].[ServiceTbl_LOCAL]
GO

