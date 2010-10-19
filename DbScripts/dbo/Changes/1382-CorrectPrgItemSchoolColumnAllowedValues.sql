UPDATE VC3Reporting.ReportSchemaColumn
SET AllowedValuesExpression = 'SELECT ID, Name AS Name FROM School WHERE IsLocalOrg = 1 ORDER BY Name'
WHERE Id = '0F35373C-3561-49B5-A0D9-EA5C9A1B1218'