ALTER TABLE PrgDocument ALTER COLUMN ContentFileId UNIQUEIDENTIFIER NULL
GO

ALTER TABLE PrgDocument ALTER COLUMN FinalizedBy UNIQUEIDENTIFIER NULL
GO

ALTER TABLE PrgDocument ALTER COLUMN FinalizedDate DATETIME NULL
GO

ALTER TABLE [dbo].[PrgDocument] DROP CONSTRAINT [FK_PrgDocument#Definition#Documents]
GO

ALTER TABLE [dbo].[PrgDocument]  WITH CHECK ADD  CONSTRAINT [FK_PrgDocument#Def#Documents] FOREIGN KEY([DefId])
REFERENCES [dbo].[PrgDocumentDef] ([ID])
GO

ALTER TABLE [dbo].[PrgDocument] CHECK CONSTRAINT [FK_PrgDocument#Def#Documents]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgDocument_GetRecordsByDefinition]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgDocument_GetRecordsByDefinition]
GO
