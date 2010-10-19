ALTER TABLE [dbo].[PrgDocumentInput]
DROP CONSTRAINT [FK_PrgDocumentInput#Def#Inputs]
GO

ALTER TABLE [dbo].[PrgDocumentInput] WITH CHECK
ADD CONSTRAINT [FK_PrgDocumentInput#Def#Inputs]
FOREIGN KEY([DefId]) REFERENCES [dbo].[PrgDocumentDef] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PrgDocumentInput]
CHECK CONSTRAINT [FK_PrgDocumentInput#Def#Inputs]
GO
