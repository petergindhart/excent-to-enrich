-- Extend PrgSectionDef for IepPostSchoolConsiderations
CREATE TABLE dbo.IepPostSchoolConsiderationsSectionDef
	(
	ID uniqueidentifier NOT NULL,
	PerAreaFormTemplateID uniqueidentifier NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolConsiderationsSectionDef ADD CONSTRAINT
	PK_IepPostSchoolConsiderationsSectionDef PRIMARY KEY CLUSTERED 
	(
	ID
	) ON [PRIMARY]
GO
ALTER TABLE dbo.IepPostSchoolConsiderationsSectionDef ADD CONSTRAINT
	FK_IepPostSchoolConsiderationsSectionDef_PrgSectionDef FOREIGN KEY
	(
	ID
	) REFERENCES dbo.PrgSectionDef
	(
	ID
	) ON DELETE  CASCADE	
GO
ALTER TABLE dbo.IepPostSchoolConsiderationsSectionDef ADD CONSTRAINT
	FK_IepPostSchoolConsiderationsSectionDef#PerAreaFormTemplate# FOREIGN KEY
	(
	PerAreaFormTemplateID
	) REFERENCES dbo.FormTemplate
	(
	Id
	)
GO


ALTER TABLE dbo.IepPostSchoolArea ADD
	FormInstanceID uniqueidentifier NULL
GO
ALTER TABLE dbo.IepPostSchoolArea ADD CONSTRAINT
	FK_IepPostSchoolArea#FormInstance# FOREIGN KEY
	(
	FormInstanceID
	) REFERENCES dbo.PrgItemForm
	(
	ID
	)
GO

-- insert subclassed record for any existing post school area PrgSectionDefs.
INSERT IepPostSchoolConsiderationsSectionDef
SELECT sd.ID, NULL
FROM PrgSectionDef sd
WHERE sd.TypeID = '3B28AFDE-CAE9-4BFB-B010-535E1A8D68CA'

insert PrgItemFormType values( 'CB6CEB6B-033A-4504-BC4F-C66C56F623EF', 'PostSchoolArea' )
GO

-- add nullable code field for consistent handling of requiredness if name/sequence changes
ALTER TABLE dbo.IepPostSchoolAreaDef ADD
	Code varchar(10) NULL
GO
update IepPostSchoolAreaDef set Code = 'IndLiving' where ID = '2B5D9C8A-7FA7-4E74-9F0C-53327209E751'
update IepPostSchoolAreaDef set Code = 'EdTraining' where ID = 'ADB5C7FD-C09F-41E3-9C0E-9AF403C741D1'
update IepPostSchoolAreaDef set Code = 'Employment' where ID = '823BA9DB-AF13-42BD-9CC2-EAA884701523'
GO
