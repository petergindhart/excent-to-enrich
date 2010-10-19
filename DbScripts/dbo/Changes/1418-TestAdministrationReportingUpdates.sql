UPDATE VC3Reporting.ReportSchemaTable
SET TableExpression =
'(SELECT ta.Id AdministrationID, ta.TestDefinitionID, StudentID FROM 
TestAdministration ta, TestViewStudentEnrollmentView glh 
WHERE dbo.DateRangesOverlap(ta.StartDate, ta.EndDate, glh.StartDate, glh.EndDate, NULL) = 1)'
where Id ='6e45cff3-aa20-4b13-be65-93328f030f48'

----Enrollment--------------------------------------------------------------------------
DECLARE @enrollmentSchemaTableID uniqueidentifier
SET @enrollmentSchemaTableID = '6e45cff3-aa20-4b13-be65-93328f030f48'

--Test Definition
DECLARE @eTestDefinitionIdColumnID uniqueidentifier
SET @eTestDefinitionIdColumnID = '2CAEACBE-1F2A-4C06-8995-395AC4D2C1A8'

INSERT INTO VC3Reporting.ReportSchemaColumn
VALUES (@eTestDefinitionIdColumnID, 'Test Definition', @enrollmentSchemaTableID, 'G', '(SELECT Name FROM TestDefinition WHERE ID={this}.TestDefinitionID)', '{this}.TestDefinitionID', '(SELECT Name FROM TestDefinition WHERE ID={this}.TestDefinitionID)', NULL, NULL, 0, 0, 0, 0, 0, 0, 'SELECT ID, Name AS Name FROM TestDefinition ORDER BY Name', 0, NULL, NULL, NULL)

INSERT INTO ReportSchemaColumn
VALUES (@eTestDefinitionIdColumnID, NULL)

INSERT INTO VC3Reporting.ReportTypeColumn
VALUES ('2CAEACBE-1F2A-4C06-8995-395AC4D2C1A8','BA314C08-7D2C-456F-AFBD-AD1E67911618', NULL, 1)

exec sp_rename 'FK_TestDefinition#ReportTable#', 'FK_TestDefinition#ReportTable#TestDefinitions', 'OBJECT'