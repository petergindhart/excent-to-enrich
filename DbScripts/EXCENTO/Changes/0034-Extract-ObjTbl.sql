IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[EXCENTO].[ObjTbl]'))
DROP VIEW [EXCENTO].[ObjTbl]
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[EXCENTO].[ObjTbl_LOCAL]') AND type in (N'U'))
DROP TABLE [EXCENTO].[ObjTbl_LOCAL]
GO

CREATE TABLE [EXCENTO].[ObjTbl_LOCAL](
	[GoalSeqNum] [bigint] NOT NULL,
	[ObjSeqNum] [bigint] NOT NULL,
	[ObjOrder] [int] NULL,
	[ObjCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ObjDesc] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GStudentID] [uniqueidentifier] NOT NULL,
	[Criteria] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Evaluation] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartDate] [datetime] NULL,
	[ObjDone] [bit] NULL,
	[Schedule] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[ModifyID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ModifyDate] [datetime] NULL,
	[DeleteID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Deletedate] [datetime] NULL,
	[Del_Flag] [bit] NULL,
	[IEPStatus] [tinyint] NULL,
	[LinkToObjSeqNum] [bigint] NULL,
 CONSTRAINT [PK_ObjTbl] PRIMARY KEY NONCLUSTERED 
(
	[ObjSeqNum] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [EXCENTO].[ObjTbl_LOCAL]  WITH CHECK ADD  CONSTRAINT [FK_ObjTbl_GoalTbl] FOREIGN KEY([GoalSeqNum])
REFERENCES [EXCENTO].[GoalTbl_LOCAL] ([GoalSeqNum])
GO

ALTER TABLE [EXCENTO].[ObjTbl_LOCAL] CHECK CONSTRAINT [FK_ObjTbl_GoalTbl]
GO


CREATE VIEW [EXCENTO].[ObjTbl]
AS
	SELECT * FROM [EXCENTO].[ObjTbl_LOCAL]
GO
