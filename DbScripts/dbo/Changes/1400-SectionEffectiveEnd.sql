INSERT INTO EnumType
VALUES ('95CF82F4-9211-4EFE-B2DD-A7E39D19C1E5','SectionEffectiveEnd',0,0,'Section Effective End')

INSERT INTO EnumValue
VALUES ('364E5196-810F-46D2-ABF5-2BC62FCCC5D9','95CF82F4-9211-4EFE-B2DD-A7E39D19C1E5', 'Item End', NULL, 1, 0)

INSERT INTO EnumValue
VALUES ('48604F5D-D24E-4B21-AD0C-859C04706733','95CF82F4-9211-4EFE-B2DD-A7E39D19C1E5', 'Involvement End', NULL, 1, 1)

ALTER TABLE PrgSectionType
ADD EffectiveEndId uniqueidentifier
GO 

--All section types by default should have their data lose effectiveness at item end.
UPDATE PrgSectionType
SET EffectiveEndId = '364E5196-810F-46D2-ABF5-2BC62FCCC5D9'

--Set specific sections to Involvement end
UPDATE PrgSectionType
SET EffectiveEndId = '48604F5D-D24E-4B21-AD0C-859C04706733'
WHERE ID IN
(
	'31A1AE20-5F63-47FD-852A-4801595033ED',	--Sped Consent Evaluation
	'FAAC8057-2256-456A-A441-3391C2F1BEF7',	--Sped Consent Services
	'F65AEF7A-5EF8-46DD-B207-ADA61CD3A4CB',	--Sped Eligibility Determination
	'E4302232-FFC9-423F-A332-AE5E56C76A09',	--Sped Milestones
	'65C743AB-40C7-4DEA-AB8D-5CCF01097DE9'	--Sped Suspected Disabilities
)

ALTER TABLE PrgSectionType
ALTER COLUMN EffectiveEndId uniqueidentifier NOT NULL
GO