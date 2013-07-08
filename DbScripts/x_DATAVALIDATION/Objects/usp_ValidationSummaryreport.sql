IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'x_DATAVALIDATION' and o.name = 'Summaryreport')
DROP PROC x_DATAVALIDATION.Summaryreport
GO

CREATE PROC x_DATAVALIDATION.Summaryreport 
AS
BEGIN

INSERT x_DATAVALIDATION.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT TableName,ErrorMessage,COUNT(*) as NoofRecords 
FROM x_DATAVALIDATION.ValidationReport Group by TableName,ErrorMessage

END