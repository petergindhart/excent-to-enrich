ALTER TABLE [dbo].[IepSpecialFactor] DROP CONSTRAINT [FK_IepSpecialFactor#FormInstance#]
GO

ALTER TABLE [dbo].[IepSpecialFactor]  WITH CHECK ADD  CONSTRAINT [FK_IepSpecialFactor#FormInstance#] FOREIGN KEY([FormInstanceId])
REFERENCES [dbo].[PrgItemForm] ([ID])
GO

ALTER TABLE [dbo].[IepSpecialFactor] CHECK CONSTRAINT [FK_IepSpecialFactor#FormInstance#]
GO
