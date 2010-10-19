UPDATE VC3Reporting.ReportSchemaColumn
SET AllowedValuesExpression = 'select Id, Name from School WHERE IsLocalOrg = 1 order by Name'
WHERE AllowedValuesExpression = 'select Id, Name from School order by Name'

--School (current)
UPDATE VC3Reporting.ReportSchemaColumn
SET AllowedValuesExpression = 'select ID, Number from School WHERE IsLocalOrg = 1 order by Number'
WHERE ID ='D4F42F28-F7F2-48C4-BF99-B74E16FECBE9'

--AcademicPlanSubject
UPDATE VC3Reporting.ReportSchemaColumn
SET AllowedValuesExpression = 'select Id, Name from School WHERE IsLocalOrg = 1 order by Name desc'
WHERE ID ='7ED3B1CD-D10B-43D3-BADB-EF094409E632'

UPDATE VC3Reporting.ReportSchemaColumn
SET AllowedValuesExpression = '(SELECT ID, Name AS Name WHERE IsLocalOrg = 1 FROM School)'
WHERE ID ='0F35373C-3561-49B5-A0D9-EA5C9A1B1218'