-- When a form template is deleted a custom form section using the form template is also deleted.

ALTER TABLE dbo.PrgSectionDef DROP CONSTRAINT FK_PrgSectionDef#FormTemplate#

ALTER TABLE dbo.PrgSectionDef
ADD CONSTRAINT FK_PrgSectionDef#FormTemplate# 
FOREIGN KEY (FormTemplateID) REFERENCES dbo.FormTemplate (Id) ON DELETE CASCADE
GO
