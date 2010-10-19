/*
	Schema changes adding support for feature licensing of
	1) Programs
	2) PrgItemTypes
	3) PrgSectionTypes
*/
ALTER TABLE dbo.PrgItemType ADD
	FeatureID uniqueidentifier NULL
GO
ALTER TABLE dbo.PrgItemType ADD CONSTRAINT
	FK_PrgItemType#Feature# FOREIGN KEY
	(
	FeatureID
	) REFERENCES dbo.Feature
	(
	ID
	)
GO
ALTER TABLE dbo.Program ADD
	FeatureID uniqueidentifier NULL
GO
ALTER TABLE dbo.Program ADD CONSTRAINT
	FK_Program#Feature# FOREIGN KEY
	(
	FeatureID
	) REFERENCES dbo.Feature
	(
	ID
	)
GO

ALTER TABLE dbo.PrgSectionType ADD
	FeatureID uniqueidentifier NULL
GO
ALTER TABLE dbo.PrgSectionType ADD CONSTRAINT
	FK_PrgSectionType#Feature# FOREIGN KEY
	(
	FeatureID
	) REFERENCES dbo.Feature
	(
	ID
	)
GO

ALTER TABLE dbo.Report ADD
	ViewFeatureID uniqueidentifier NULL
GO
ALTER TABLE dbo.Report ADD CONSTRAINT
	FK_Report#ViewFeature# FOREIGN KEY
	(
	ViewFeatureID
	) REFERENCES dbo.Feature
	(
	ID
	)
GO

ALTER TABLE dbo.ReportType ADD
	ViewFeatureId uniqueidentifier NULL
GO

ALTER TABLE dbo.ReportType ADD CONSTRAINT
	FK_ReportType#ViewFeature# FOREIGN KEY
	(
	ViewFeatureId
	) REFERENCES dbo.Feature
	(
	ID
	)	
GO

/*
	Program feature configuration
*/
declare @feaGeneral uniqueidentifier, @feaRTI uniqueidentifier, @feaSpecEd uniqueidentifier, @feaCustomUse uniqueidentifier, @feaCustomCreate uniqueidentifier
select
	@feaGeneral = '375CA1CA-D0E1-4768-A84E-680BBBC2D7E5',
	@feaRTI = '2A516452-E8D4-43CA-880F-C8CF0006E47E',
	@feaSpecEd = '426D5613-B398-4556-BF3F-765040E5617F',
	@feaCustomUse = 'F98E0762-0935-48CA-A3A6-F0609DF9692A',
	@feaCustomCreate = '38863934-0048-4A2E-8363-3558731A24C9'
	
insert Feature values(@feaGeneral,		'Programs.General')
insert Feature values(@feaSpecEd,		'Programs.SpecEd')
insert Feature values(@feaCustomUse,	'Programs.CustomUse')

update Feature set Name = 'Programs.RTI' where ID = @feaRTI -- formerly 'Students.Interventions'
update Feature set Name = 'Programs.CustomCreate' where ID = @feaCustomCreate -- formerly 'District.CreateCustomPrograms'

update SecurityTaskCategory
set FeatureID = @feaGeneral
where ID in (
	'64EC7291-1B71-4268-AB01-14410587F727',	--District>Programs
	'4380ACF5-3ABE-40C2-B724-2A43970BC81E',	--Classroom>Schools>Programs
	'07D4ED6A-0CFF-4FD0-B03F-E22D51940CDD'	--Classroom>Students>Programs
	)

-- actually set the feature permissions
update Program set FeatureID = @feaRTI			where ID = '7DE3B3D7-B60F-48AC-9681-78D46A5E74D4' -- Response to Intervention
update Program set FeatureID = @feaCustomUse	where ID = 'D3AB11A2-96C0-4BA5-914A-C250EDDEA995' -- Individual Literacy Plan
update Program set FeatureID = @feaSpecEd		where ID = 'F98A8EF2-98E2-4CAC-95AF-D7D89EF7F80C' -- Special Education
update Program set FeatureID = @feaCustomUse	where FeatureID is null

update PrgItemType set FeatureID = @feaGeneral	where ID = 'D7B183D8-5BBD-4471-8829-3C8D82A92478' -- Custom Plan
update PrgItemType set FeatureID = @feaRTI		where ID = '03670605-58B2-40B2-99D5-4A1A70156C73' -- Intervention Plan
update PrgItemType set FeatureID = @feaGeneral	where ID = '2A37FB49-1977-48C7-9031-56148AEE8328' -- Program Action
update PrgItemType set FeatureID = @feaRTI		where ID = '1511F713-B210-40BB-ACCA-624212BB38F4' -- Plan Action
update PrgItemType set FeatureID = @feaRTI		where ID = '6002D022-4D8F-48A9-A0B7-918863631B13' -- Tool Action
update PrgItemType set FeatureID = @feaGeneral	where ID = 'B1B9173E-C987-4752-82DE-D7237A2BC060' -- Meeting
update PrgItemType set FeatureID = @feaSpecEd	where ID = 'A5990B5E-AFAD-4EF0-9CCA-DC3685296870' -- IEP

update PrgSectionType set FeatureID = @feaGeneral	where ID = '77C55154-06B5-476D-A15B-02EC0B5165F2' -- Custom Form
update PrgSectionType set FeatureID = @feaSpecEd	where ID = '6F3F1C06-64C6-4C70-A834-0941ACCD0F62' -- IEP Assessments
update PrgSectionType set FeatureID = @feaSpecEd	where ID = '469601E0-B8E6-483A-9CE7-2A88DE0EAB78' -- IEP Goals
update PrgSectionType set FeatureID = @feaSpecEd	where ID = 'FAAC8057-2256-456A-A441-3391C2F1BEF7' -- Sped Consent Services
update PrgSectionType set FeatureID = @feaSpecEd	where ID = '31A1AE20-5F63-47FD-852A-4801595033ED' -- Sped Consent Evaluation
update PrgSectionType set FeatureID = @feaSpecEd	where ID = '7E6F8640-DEB8-441F-BD3A-4B2E96EAA6B4' -- IEP Dates
update PrgSectionType set FeatureID = @feaSpecEd	where ID = '3B28AFDE-CAE9-4BFB-B010-535E1A8D68CA' -- IEP Post-School Considerations
update PrgSectionType set FeatureID = @feaSpecEd	where ID = '265AC4EC-2325-4CA8-A428-5361DC7F83F0' -- Accommodations & Modifications
update PrgSectionType set FeatureID = @feaSpecEd	where ID = '65C743AB-40C7-4DEA-AB8D-5CCF01097DE9' -- Sped Suspected Disabilities
update PrgSectionType set FeatureID = @feaSpecEd	where ID = 'F65AEF7A-5EF8-46DD-B207-ADA61CD3A4CB' -- Sped Eligibility Determination
update PrgSectionType set FeatureID = @feaSpecEd	where ID = 'E4302232-FFC9-423F-A332-AE5E56C76A09' -- Sped Milestones
update PrgSectionType set FeatureID = @feaSpecEd	where ID = 'B2E99B75-1E6A-4A93-A6B0-BBE0074A2917' -- IEP Procedural Safeguards
update PrgSectionType set FeatureID = @feaSpecEd	where ID = 'F2A1374B-46D6-4E25-9733-D7F3256369ED' -- IEP Demographics
update PrgSectionType set FeatureID = @feaSpecEd	where ID = '54228EE4-3A8C-4544-9216-D842BE7B0A3B' -- IEP Services
update PrgSectionType set FeatureID = @feaSpecEd	where ID = 'D1C4004B-EF82-4E8F-BA12-D8F086EB9BBE' -- IEP LRE
update PrgSectionType set FeatureID = @feaSpecEd	where ID = '9B10DCDE-15CC-4AA3-808A-DFD51CE91079' -- IEP ESY
update PrgSectionType set FeatureID = @feaSpecEd	where ID = '5647C4E2-D9C7-4737-B982-E641FB10B79F' -- IEP Special Factors
update PrgSectionType set FeatureID = @feaSpecEd	where ID = '2DFA76AD-9139-4129-A1B2-EB19E0190B5A' -- IEP Present Levels

update ReportType set ViewFeatureID = @feaGeneral where ID = 'M' -- Meetings
update ReportType set ViewFeatureID = @feaRTI where ID = 'N' -- Intervention Tools
update ReportType set ViewFeatureID = @feaGeneral where ID = 'P' -- Plans
update ReportType set ViewFeatureID = @feaGeneral where ID = 'T' -- Actions

-- update ReportSchemaColumns to accept FeatureIds from ReportContext
-- Program Item.Program	
update VC3Reporting.ReportSchemaColumn
set AllowedValuesExpression = 'SELECT p.ID, ISNULL(p.Name + '' (Inactive as of '' + CONVERT(VARCHAR(100),p.DeletedDate,101) + '')'', p.Name) FROM Program p WHERE p.FeatureID is null or p.FeatureID in (select id from GetUniqueIdentifiers(<%=FeatureIds%>)) ORDER BY p.Name'
where ID = 'DF3187AA-320E-4BFA-A2FE-6159ADEA9522'

-- Program Item.Name	
update VC3Reporting.ReportSchemaColumn
set AllowedValuesExpression = 'SELECT d.ID, ISNULL(d.Name + '' (Inactive as of '' + CONVERT(VARCHAR(100),d.DeletedDate,101) + '')'', d.Name) AS Name, ISNULL(p.Name + '' (Inactive as of '' + CONVERT(VARCHAR(100),p.DeletedDate,101) + '')'', p.Name) AS Program FROM PrgItemDef d JOIN Program p ON p.ID = d.ProgramID WHERE p.FeatureID is null or p.FeatureID in (select id from GetUniqueIdentifiers(<%=FeatureIds%>)) ORDER BY Program, Name'
where ID = 'D3DF497E-E9BB-4860-A6D2-D19049BCECC6'

-- Program Item.Outcome	
update VC3Reporting.ReportSchemaColumn
set AllowedValuesExpression = 'SELECT o.ID, o.Text AS Name FROM PrgItemOutcome o JOIN PrgItemDef d on o.CurrentDefID = d.ID JOIN Program p on d.ProgramID = p.ID WHERE p.FeatureID is null or p.FeatureID in (select id from GetUniqueIdentifiers(<%=FeatureIds%>)) ORDER BY o.Text'
where ID = '8D007416-D37C-4F07-9893-154C31ADE2E4'

-- Populate Report Features
update r
set ViewFeatureID = @feaRTI
from
	Report r join
	ReportAreaReport ar on ar.ReportID = r.Id
where ar.ReportAreaID in (
	'66474355-2DD2-4515-81A8-7E890E188ADF', -- RTI Program History
	'B269FB8B-E67B-4DE4-A796-2E6F8B0A94D3', -- RTI Progress Monitoring
	'1A5E2B3E-D3E3-4C1B-B502-81120CE5F878', -- RTI Scheduling and Mgmt
	'0609C598-0466-4E9F-8413-9DEC50CFD8E9') -- RTI Strategy Effectiveness

update r
set ViewFeatureID = @feaSpecEd
from
	Report r join
	ReportAreaReport ar on ar.ReportID = r.Id
where ar.ReportAreaID in (
	'808D7789-2B13-4A82-992B-C949D68EB1D1') -- Special Ed Program History


GO
