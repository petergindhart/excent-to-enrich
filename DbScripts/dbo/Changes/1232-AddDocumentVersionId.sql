ALTER TABLE [dbo].[PrgDocument]
ADD [VersionId] UNIQUEIDENTIFIER NULL
GO

ALTER TABLE [dbo].[PrgDocument]  WITH CHECK ADD  CONSTRAINT [FK_PrgDocument#Version#Documents] FOREIGN KEY([VersionId])
REFERENCES [dbo].[PrgVersion] ([ID])
GO

ALTER TABLE [dbo].[PrgDocument] CHECK CONSTRAINT [FK_PrgDocument#Version#Documents]
GO
