-- create finalize type table --
--------------------------------
CREATE TABLE [dbo].[PrgDocumentFinalizeType]
(
	[ID] [char](1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	CONSTRAINT [PK_PrgDocumentFinalizeType] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)
) ON [PRIMARY]
GO

-- insert finalize type records --
----------------------------------
INSERT INTO PrgDocumentFinalizeType ([ID], [Name]) VALUES ('S', 'Every Save')
INSERT INTO PrgDocumentFinalizeType ([ID], [Name]) VALUES ('V', 'Version Finalized')
INSERT INTO PrgDocumentFinalizeType ([ID], [Name]) VALUES ('I', 'Item Finalized')
GO

-- add column to document def that references finalize type --
--------------------------------------------------------------
ALTER TABLE [dbo].[PrgDocumentDef]
ADD [FinalizeTypeId] [char](1) NULL
GO

-- set initial value --
-----------------------
UPDATE PrgDocumentDef SET FinalizeTypeId = 'S'
GO

-- make column required --
--------------------------
ALTER TABLE [dbo].[PrgDocumentDef]
ALTER COLUMN [FinalizeTypeId] [char](1) NOT NULL
GO

-- set up foreign key --
------------------------
ALTER TABLE [dbo].[PrgDocumentDef] WITH CHECK 
ADD CONSTRAINT [FK_PrgDocumentDef#FinalizeType#DocumentDefs]
FOREIGN KEY([FinalizeTypeId]) REFERENCES [dbo].[PrgDocumentFinalizeType] ([ID])
GO
ALTER TABLE [dbo].[PrgDocumentDef] 
CHECK CONSTRAINT [FK_PrgDocumentDef#FinalizeType#DocumentDefs]
GO
