CREATE TABLE dbo.IepEsyCriterionDef
	(
	ID uniqueidentifier NOT NULL,
	QuestionText varchar(255) NOT NULL,
	Sequence int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepEsyCriterionDef ADD CONSTRAINT
	PK_IepEsyCriterionDef PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
CREATE TABLE dbo.IepEsy
	(
	ID uniqueidentifier NOT NULL,
	DecisionID uniqueidentifier NULL,
	TbdDate datetime NULL,
	TbdNeededInformation text NULL,
	Explanation text NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.IepEsy ADD CONSTRAINT
	PK_IepEsy PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepEsy ADD CONSTRAINT
	FK_IepEsy#Decision# FOREIGN KEY
	(
	DecisionID
	) REFERENCES dbo.EnumValue
	(
	ID
	)  
GO
ALTER TABLE dbo.IepEsy ADD CONSTRAINT
	FK_IepEsy_PrgSection FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgSection
	(
	ID
	)  
GO
CREATE TABLE dbo.IepEsyCriterion
	(
	ID uniqueidentifier NOT NULL,
	InstanceID uniqueidentifier NOT NULL,
	IepEsyCriterionDefID uniqueidentifier NOT NULL,
	AnswerID uniqueidentifier NULL,
	Explanation text NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.IepEsyCriterion ADD CONSTRAINT
	PK_IepEsyCriterion PRIMARY KEY CLUSTERED 
	(
	ID
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepEsyCriterion ADD CONSTRAINT
	FK_IepEsyCriterion#Esy#Criteria FOREIGN KEY
	(
	InstanceID
	) REFERENCES dbo.IepEsy
	(
	ID
	)  ON DELETE CASCADE
GO
ALTER TABLE dbo.IepEsyCriterion ADD CONSTRAINT
	FK_IepEsyCriterion#Answer# FOREIGN KEY
	(
	AnswerID
	) REFERENCES dbo.EnumValue
	(
	ID
	)  
GO
ALTER TABLE dbo.IepEsyCriterion ADD CONSTRAINT
	FK_IepEsyCriterion#Def# FOREIGN KEY
	(
	IepEsyCriterionDefID
	) REFERENCES dbo.IepEsyCriterionDef
	(
	ID
	)  ON DELETE CASCADE
GO




INSERT INTO [PrgSectionType]
           ([ID]
           ,[Name]
           ,[Code]
           ,[Title]
           ,[UserControlPath])
     VALUES
           ('9B10DCDE-15CC-4AA3-808A-DFD51CE91079'
           ,'IEP ESY'
           ,'iepesy'
           ,'Extended School Year'
           ,'~/SpecEd/SectionEsy.ascx')
GO
