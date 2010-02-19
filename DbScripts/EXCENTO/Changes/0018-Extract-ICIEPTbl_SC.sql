IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[ICIEPTbl_SC]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[ICIEPTbl_SC]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[ICIEPTbl_SC_LOCAL]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [EXCENTO].[ICIEPTbl_SC_LOCAL]
GO

CREATE TABLE [EXCENTO].[ICIEPTbl_SC_LOCAL](
	[IEPComplSeqNum] [bigint] NOT NULL,
	[IEPSeqNum] [bigint] NOT NULL,
	[IEPPLSeqNum] [bigint] NULL,
	[ServSeqNum] [bigint] NULL,
	[SchoolYear] [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SummerMonths] [bit] NULL,
	[RevisedIEPDate] [datetime] NULL,
	[IEPInitDate] [datetime] NULL,
	[IEPEndDate] [datetime] NULL,
	[SpedTime] [int] NULL,
	[Strengths] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Involvement] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Preschool] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RelService] [int] NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NOT NULL DEFAULT (0),
	[IEPGrade] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IEPSchool] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TranServNeeds] [int] NULL,
	[Interests] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TransFocus] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Instruction] [int] NULL,
	[CourseofStudy] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CareerCluster] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CommExperiences] [bit] NULL,
	[Employment] [bit] NULL,
	[Rights] [int] NULL,
	[Diploma] [int] NULL,
	[AnticipatedYear] [int] NULL,
	[PrimaryDisabilityID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PrimaryDisabilityDesc] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Acquisition] [bit] NULL,
	[Functional] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE VIEW [EXCENTO].[ICIEPTbl_SC]
AS
	SELECT * FROM [EXCENTO].[ICIEPTbl_SC_LOCAL]
GO
