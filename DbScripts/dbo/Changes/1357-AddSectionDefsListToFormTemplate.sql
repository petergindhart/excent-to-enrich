ALTER TABLE [dbo].[PrgSectionDef] DROP CONSTRAINT [FK_PrgSectionDef#FormTemplate#]
GO

ALTER TABLE [dbo].[PrgSectionDef]
WITH CHECK ADD CONSTRAINT [FK_PrgSectionDef#FormTemplate#SectionDefs]
FOREIGN KEY([FormTemplateID])
REFERENCES [dbo].[FormTemplate] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[PrgSectionDef] CHECK CONSTRAINT [FK_PrgSectionDef#FormTemplate#SectionDefs]
GO
