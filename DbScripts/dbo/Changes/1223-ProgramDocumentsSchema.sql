-- Create Document Definition Entity --
--########################--
	CREATE TABLE [dbo].[PrgDocumentDef]
	(
		[ID] [uniqueidentifier] NOT NULL,
		[ProgramId] [uniqueidentifier] NOT NULL,
		[Name] [varchar](100) NOT NULL,
		[TemplateFileId] [uniqueidentifier] NOT NULL,
		[Description] [varchar](4000) NULL,
		CONSTRAINT PK_PrgDocumentDef
			PRIMARY KEY CLUSTERED([ID] ASC) ON [PRIMARY]
	) ON [PRIMARY]
	GO

	ALTER TABLE [dbo].[PrgDocumentDef] WITH CHECK 
	ADD CONSTRAINT [FK_PrgDocumentDef#TemplateFile#]
	FOREIGN KEY([TemplateFileId]) REFERENCES [dbo].[FileData] ([ID])
	GO
	ALTER TABLE [dbo].[PrgDocumentDef]
	CHECK CONSTRAINT [FK_PrgDocumentDef#TemplateFile#]
	GO

	ALTER TABLE [dbo].[PrgDocumentDef] WITH CHECK 
	ADD CONSTRAINT [FK_PrgDocumentDef#Program#DocumentDefinitions]
	FOREIGN KEY([ProgramId]) REFERENCES [dbo].[Program] ([ID])
	GO
	ALTER TABLE [dbo].[PrgDocumentDef]
	CHECK CONSTRAINT [FK_PrgDocumentDef#Program#DocumentDefinitions]
	GO

-- Create Document Entity --
--########################--
	CREATE TABLE [dbo].[PrgDocument]
	(
		[ID] [uniqueidentifier] NOT NULL,
		[DefId] [uniqueidentifier] NOT NULL,
		[ItemId] [uniqueidentifier] NOT NULL,
		[ContentFileId] [uniqueidentifier] NOT NULL,
		[CreatedBy] [uniqueidentifier] NOT NULL,
		[CreatedDate] [datetime] NOT NULL,
		CONSTRAINT PK_PrgDocument
			PRIMARY KEY CLUSTERED([ID] ASC) ON [PRIMARY]
	) ON [PRIMARY]
	GO

	ALTER TABLE [dbo].[PrgDocument] WITH CHECK 
	ADD CONSTRAINT [FK_PrgDocument#Definition#Documents]
	FOREIGN KEY([DefId]) REFERENCES [dbo].[PrgDocumentDef] ([ID])
	GO
	ALTER TABLE [dbo].[PrgDocument]
	CHECK CONSTRAINT [FK_PrgDocument#Definition#Documents]
	GO

	ALTER TABLE [dbo].[PrgDocument] WITH CHECK 
	ADD CONSTRAINT [FK_PrgDocument#Item#Documents]
	FOREIGN KEY([ItemId]) REFERENCES [dbo].[PrgItem] ([ID])
	GO
	ALTER TABLE [dbo].[PrgDocument]
	CHECK CONSTRAINT [FK_PrgDocument#Item#Documents]
	GO

	ALTER TABLE [dbo].[PrgDocument] WITH CHECK 
	ADD CONSTRAINT [FK_PrgDocument#ContentFile#]
	FOREIGN KEY([ContentFileId]) REFERENCES [dbo].[FileData] ([ID])
	GO
	ALTER TABLE [dbo].[PrgDocument]
	CHECK CONSTRAINT [FK_PrgDocument#ContentFile#]
	GO

	ALTER TABLE [dbo].[PrgDocument] WITH CHECK 
	ADD CONSTRAINT [FK_PrgDocument#CreatedBy#Documents]
	FOREIGN KEY([CreatedBy]) REFERENCES [dbo].[UserProfile] ([ID])
	GO
	ALTER TABLE [dbo].[PrgDocument]
	CHECK CONSTRAINT [FK_PrgDocument#CreatedBy#Documents]
	GO
