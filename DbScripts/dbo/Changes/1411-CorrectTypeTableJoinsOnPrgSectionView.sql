--In order for the sections to be properly filtered, the section itself must be the root element.
--Otherwise PrgSectionView is only joined in  when the item is used.

DECLARE @prgSectionSchemaTableID uniqueidentifier
SET @prgSectionSchemaTableID = 'B348B796-FE8A-45B8-99EC-6F1D8F4034E6'

--UPDATE Original Root Table
UPDATE p
SET JoinTable = c.Id, JoinMultiplicity = 'I', JoinExpression = '{left}.ID = {right}.InstanceID', MergeColumnsIntoJoinTable = 1
FROM VC3Reporting.ReportTypeTable c JOIN
VC3Reporting.ReportTypeTable p on p.Id = c.JoinTable
WHERE c.SchemaTable = @prgSectionSchemaTableID AND p.Id IN
(
	'24B9BEB7-7245-4803-8838-E7CB4BD3B7B6',
	'A0253EB7-3165-4CD9-910B-68338A935759',
	'546B7DD0-F8FE-44FB-9FBF-DBE6AA7675E9'
)

--Set section to be new root table
UPDATE c
SET Name = p.Name, JoinTable = NULL, JoinMultiplicity = NULL, JoinExpression = NULL, MergeColumnsIntoJoinTable = 0
FROM VC3Reporting.ReportTypeTable c JOIN
VC3Reporting.ReportTypeTable p on p.Id = c.JoinTable
WHERE c.SchemaTable = @prgSectionSchemaTableID AND c.Id IN
(
	'4F0EB58E-2712-46E2-918B-68360EC66B60',
	'9BD537D4-1C78-4204-A197-749F59096CAC',
	'0F5D0002-5D9F-4074-9B06-89A020C7F9C1'
)

--Update Column Prefixes
UPDATE VC3Reporting.ReportTypeTable
SET ColumnPrefix = Name + ' >'
WHERE Id IN
(
	'4F0EB58E-2712-46E2-918B-68360EC66B60',
	'9BD537D4-1C78-4204-A197-749F59096CAC',
	'0F5D0002-5D9F-4074-9B06-89A020C7F9C1'
) OR Id IN
(
	'24B9BEB7-7245-4803-8838-E7CB4BD3B7B6',
	'A0253EB7-3165-4CD9-910B-68338A935759',
	'546B7DD0-F8FE-44FB-9FBF-DBE6AA7675E9'
)

UPDATE VC3Reporting.ReportTypeTable 
SET ColumnPrefix = 'Assessment Participation >' 
WHERE Id = '7B73CC53-9AEA-44E4-9A37-DC0848A1F119'