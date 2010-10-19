INSERT PrgItemFormType VALUES ( 'A32E68FE-B548-422F-ADFB-15B780B04BF9', 'Disability Determination' )

ALTER TABLE dbo.IepDisabilityEligibility ADD
	FormInstanceID uniqueidentifier NULL
GO
ALTER TABLE dbo.IepDisabilityEligibility ADD CONSTRAINT
	FK_IepDisabilityEligibility#FormInstance# FOREIGN KEY
	(
	FormInstanceID
	) REFERENCES dbo.PrgItemForm
	(
	ID
	) 
GO
ALTER TABLE dbo.IepDisability ADD CONSTRAINT
	FK_IepDisability#DeterminationFormTemplate# FOREIGN KEY
	(
	DeterminationFormTemplateID
	) REFERENCES dbo.FormTemplate
	(
	Id
	) 
GO
