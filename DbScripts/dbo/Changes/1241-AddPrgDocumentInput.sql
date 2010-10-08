-- create document input table --
--------------------------------
CREATE TABLE [dbo].[PrgDocumentInput]
(
	[ID] [uniqueidentifier] NOT NULL,
	[DefId] [uniqueidentifier] NOT NULL,
	[Path] [varchar](50) NOT NULL,
	CONSTRAINT [PK_PrgDocumentInput] 
	PRIMARY KEY CLUSTERED ([ID] ASC)
) ON [PRIMARY]
GO

-- set up foreign key --
------------------------
ALTER TABLE [dbo].[PrgDocumentInput] WITH CHECK
ADD CONSTRAINT [FK_PrgDocumentInput#Def#Inputs]
FOREIGN KEY([DefId]) REFERENCES [dbo].[PrgDocumentDef] ([ID])
GO
ALTER TABLE [dbo].[PrgDocumentInput]
CHECK CONSTRAINT [FK_PrgDocumentInput#Def#Inputs]
GO
