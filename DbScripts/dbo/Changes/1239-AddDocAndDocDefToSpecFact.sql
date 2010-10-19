-- Add Document Def --
----------------------
ALTER TABLE [dbo].[IepSpecialFactorDef]
ADD [DocumentDefId] UNIQUEIDENTIFIER NULL
GO

ALTER TABLE [dbo].[IepSpecialFactorDef]  WITH CHECK ADD  CONSTRAINT [FK_IepSpecialFactorDef#DocumentDef#] FOREIGN KEY([DocumentDefId])
REFERENCES [dbo].[PrgDocumentDef] ([ID])
GO

ALTER TABLE [dbo].[IepSpecialFactorDef] CHECK CONSTRAINT [FK_IepSpecialFactorDef#DocumentDef#]
GO

-- Add Document --
----------------------
ALTER TABLE [dbo].[IepSpecialFactor]
ADD [DocumentId] UNIQUEIDENTIFIER NULL
GO

ALTER TABLE [dbo].[IepSpecialFactor]  WITH CHECK ADD  CONSTRAINT [FK_IepSpecialFactor#Document#] FOREIGN KEY([DocumentId])
REFERENCES [dbo].[PrgDocument] ([ID])
GO

ALTER TABLE [dbo].[IepSpecialFactor] CHECK CONSTRAINT [FK_IepSpecialFactor#Document#]
GO
