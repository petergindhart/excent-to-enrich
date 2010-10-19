EXEC sp_rename 'PrgDocument.CreatedBy', 'FinalizedBy', 'COLUMN'
GO

EXEC sp_rename 'PrgDocument.CreatedDate', 'FinalizedDate', 'COLUMN'
GO

ALTER TABLE [dbo].[PrgDocument] DROP CONSTRAINT [FK_PrgDocument#CreatedBy#Documents]
GO

ALTER TABLE [dbo].[PrgDocument]  WITH CHECK ADD  CONSTRAINT [FK_PrgDocument#FinalizedBy#Documents] FOREIGN KEY([FinalizedBy])
REFERENCES [dbo].[UserProfile] ([ID])
GO

ALTER TABLE [dbo].[PrgDocument] CHECK CONSTRAINT [FK_PrgDocument#FinalizedBy#Documents]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgDocument_GetRecordsByCreatedBy]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[PrgDocument_GetRecordsByCreatedBy]
GO
