IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'Datavalidation' and o.name = 'Summaryreport')
DROP PROC Datavalidation.Summaryreport
GO

CREATE PROC Datavalidation.Summaryreport 
AS
BEGIN

INSERT Datavalidation.ValidationSummaryReport (TableName,ErrorMessage,NumberOfRecords)
SELECT TableName,ErrorMessage,COUNT(*) as NoofRecords 
FROM Datavalidation.ValidationReport Group by TableName,ErrorMessage

END