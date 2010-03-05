IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[GoalTbl_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[GoalTbl_LOCAL]
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[GoalTbl]'))
DROP VIEW [EXCENTO].[GoalTbl]
GO

CREATE TABLE [EXCENTO].[GoalTbl_LOCAL](
	[GStudentID] [uniqueidentifier] NOT NULL,
	[GoalSeqNum] [bigint] NOT NULL,
	[GoalOrder] [int] NULL,
	[GoalCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GoalDesc] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BankDesc] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Standard] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Agency] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Domain1] [bit] NULL,
	[Domain2] [bit] NULL,
	[Domain3] [bit] NULL,
	[Domain4] [bit] NULL,
	[Domain5] [bit] NULL,
	[Domain6] [bit] NULL,
	[Domain7] [bit] NULL,
	[Domain8] [bit] NULL,
	[Domain9] [bit] NULL,
	[ESY] [bit] NULL,
	[Domain10] [bit] NULL,
	[Domain11] [bit] NULL,
	[Domain12] [bit] NULL,
	[IEPStatus] [tinyint] NULL,
	[IEPComplSeqNum] [bigint] NULL,
	[StartDate] [datetime] NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NULL,
	[InstructArea] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SDI] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RelatedServ] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SuppAides] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProgMods] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TitleRespond] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BankCode] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LinkToGoalSeqNum] [bigint] NULL,
 CONSTRAINT [PK_GoalTbl] PRIMARY KEY NONCLUSTERED 
(
	[GoalSeqNum] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


CREATE VIEW [EXCENTO].[GoalTbl]
AS
	SELECT * FROM [EXCENTO].[GoalTbl_LOCAL]
GO

