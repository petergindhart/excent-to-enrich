UPDATE VC3Reporting.ReportSchemaColumn
SET ValueExpression = 'CAST({this}.' + ValueExpression + ' AS VARCHAR(MAX))'
WHERE Id IN
(
	'899486FF-220C-4AF6-BC1B-D21E18F53647',
	'9E437BBA-8A3F-431C-8A6C-8CCBFB66FE3E'
)