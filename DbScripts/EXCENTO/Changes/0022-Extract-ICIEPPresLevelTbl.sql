IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[ICIEPPresLevelTbl]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[ICIEPPresLevelTbl]
GO

IF EXISTS (select 1 from dbo.sysobjects where id = OBJECT_ID(N'[EXCENTO].[ICIEPPresLevelTbl_LOCAL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [EXCENTO].[ICIEPPresLevelTbl_LOCAL]
GO

CREATE TABLE [EXCENTO].[ICIEPPresLevelTbl_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[IEPComplSeqNum] [bigint] NOT NULL,
	[IEPPLSeqNum] [bigint] NOT NULL,
	[AreaID] [bigint] NULL,
	[PresentLvl] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EduNeed] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DomainDesc] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NULL,
	[RelData] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Strength] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Diagnosis] [bit] NULL,
	[DiagnosisTxt] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Physician] [nvarchar](65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VisionDate] [datetime] NULL,
	[VisionResult] [int] NULL,
	[HearDate] [datetime] NULL,
	[HearResult] [int] NULL,
	[Corrected] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Sender] [nvarchar](65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FBABIP] [int] NULL,
	[Active] [bit] NULL,
	[Servtype] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE VIEW [EXCENTO].[ICIEPPresLevelTbl]
AS
	SELECT * FROM [EXCENTO].ICIEPPresLevelTbl_LOCAL
GO
