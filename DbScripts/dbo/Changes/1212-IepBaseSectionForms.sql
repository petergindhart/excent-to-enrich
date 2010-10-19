-- Allow association of PrgItemForm with PrgSection
ALTER TABLE dbo.PrgItemForm ADD
	SectionID uniqueidentifier NULL
GO
ALTER TABLE dbo.PrgItemForm ADD CONSTRAINT
	FK_PrgItemForm#Section#SectionForms FOREIGN KEY
	(
	SectionID
	) REFERENCES dbo.PrgSection
	(
	ID
	)
GO
ALTER TABLE dbo.PrgSectionDef ADD
	FormTemplateID uniqueidentifier NULL
GO
ALTER TABLE dbo.PrgSectionDef ADD CONSTRAINT
	FK_PrgSectionDef#FormTemplate# FOREIGN KEY
	(
	FormTemplateID
	) REFERENCES dbo.FormTemplate
	(
	Id
	)  
GO

INSERT FormTemplateType VALUES ( '54BBC38E-9C1D-42CA-8ECE-20C8A72CBBE1', 'Program SectionForm' )
GO
