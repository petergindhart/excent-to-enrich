ALTER TABLE [dbo].[PrgDocumentDef] DROP CONSTRAINT [FK_PrgDocumentDef#Program#DocumentDefinitions]
GO

EXEC sp_rename 'PrgDocumentDef.ProgramId', 'ItemDefId', 'COLUMN'
GO

ALTER TABLE [dbo].[PrgDocumentDef]  WITH CHECK ADD  CONSTRAINT [FK_PrgDocumentDef#ItemDef#DocumentDefinitions] FOREIGN KEY([ItemDefId])
REFERENCES [dbo].[PrgItemDef] ([ID])
GO

ALTER TABLE [dbo].[PrgDocumentDef] CHECK CONSTRAINT [FK_PrgDocumentDef#ItemDef#DocumentDefinitions]
GO
