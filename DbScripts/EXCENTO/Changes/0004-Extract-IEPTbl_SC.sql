IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[IEPTbl_SC]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [EXCENTO].[IEPTbl_SC]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[EXCENTO].[IEPTbl_SC_LOCAL]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [EXCENTO].[IEPTbl_SC_LOCAL]
GO

CREATE TABLE [EXCENTO].[IEPTbl_SC_LOCAL](
	[IEPSeqNum] [bigint] NOT NULL,
	[IEPPLSeqNum] [bigint] NULL,
	[ServSeqNum] [bigint] NULL,
	[SchoolYear] [nvarchar](40) NULL,
	[SummerMonths] [bit] NULL,
	[RevisedIEPDate] [datetime] NULL,
	[IEPInitDate] [datetime] NULL,
	[IEPEndDate] [datetime] NULL,
	[SpedTime] [int] NULL,
	[Strengths] [ntext] NULL,
	[Involvement] [ntext] NULL,
	[Preschool] [ntext] NULL,
	[RelService] [int] NULL,
	[CreateID] [nvarchar](20) NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NOT NULL,
	[IEPGrade] [ntext] NULL,
	[IEPSchool] [nvarchar](80) NULL,
	[TranServNeeds] [int] NULL,
	[Interests] [ntext] NULL,
	[TransFocus] [ntext] NULL,
	[Instruction] [int] NULL,
	[CourseofStudy] [ntext] NULL,
	[CareerCluster] [nvarchar](80) NULL,
	[CommExperiences] [bit] NULL,
	[Employment] [bit] NULL,
	[Rights] [int] NULL,
	[Diploma] [int] NULL,
	[AnticipatedYear] [int] NULL,
	[PrimaryDisabilityID] [nvarchar](10) NULL,
	[PrimaryDisabilityDesc] [nvarchar](80) NULL,
	[Acquisition] [bit] NULL,
	[Functional] [bit] NULL
) ON [PRIMARY]
GO

CREATE VIEW [EXCENTO].[IEPTbl_SC]
AS
	SELECT * FROM [EXCENTO].[IEPTbl_SC_LOCAL]
GO