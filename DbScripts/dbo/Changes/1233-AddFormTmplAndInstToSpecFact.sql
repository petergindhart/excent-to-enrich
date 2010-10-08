-- Ad Form Template --
----------------------
ALTER TABLE [dbo].[IepSpecialFactorDef]
ADD [FormTemplateId] UNIQUEIDENTIFIER NULL
GO

ALTER TABLE [dbo].[IepSpecialFactorDef]  WITH CHECK ADD  CONSTRAINT [FK_IepSpecialFactorDef#FormTemplate#] FOREIGN KEY([FormTemplateId])
REFERENCES [dbo].[FormTemplate] ([ID])
GO

ALTER TABLE [dbo].[IepSpecialFactorDef] CHECK CONSTRAINT [FK_IepSpecialFactorDef#FormTemplate#]
GO

-- Ad Form Instance --
----------------------
ALTER TABLE [dbo].[IepSpecialFactor]
ADD [FormInstanceId] UNIQUEIDENTIFIER NULL
GO

ALTER TABLE [dbo].[IepSpecialFactor]  WITH CHECK ADD  CONSTRAINT [FK_IepSpecialFactor#FormInstance#] FOREIGN KEY([FormInstanceId])
REFERENCES [dbo].[FormInstance] ([ID])
GO

ALTER TABLE [dbo].[IepSpecialFactor] CHECK CONSTRAINT [FK_IepSpecialFactor#FormInstance#]
GO
