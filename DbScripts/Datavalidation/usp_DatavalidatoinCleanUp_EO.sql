IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'Datavalidation' and o.name = 'Cleanup_EO')
DROP PROC Datavalidation.Cleanup_EO
GO

CREATE PROC Datavalidation.Cleanup_EO 
AS
BEGIN
/*
IF Object_id('Datavalidation.SelectLists_LOCAL') IS NOT NULL
DROP TABLE Datavalidation.SelectLists_LOCAL

IF Object_id('Datavalidation.District_LOCAL') IS NOT NULL
DROP TABLE Datavalidation.District_LOCAL

IF Object_id('Datavalidation.School_LOCAL') IS NOT NULL
DROP TABLE Datavalidation.School_LOCAL

IF Object_id('Datavalidation.Student_LOCAL') IS NOT NULL
DROP TABLE Datavalidation.Student_LOCAL

IF Object_id('Datavalidation.IEP_LOCAL') IS NOT NULL
DROP TABLE Datavalidation.IEP_LOCAL

IF Object_id('Datavalidation.SpedStaffMember_LOCAL') IS NOT NULL
DROP TABLE Datavalidation.SpedStaffMember_LOCAL

IF Object_id('Datavalidation.Service_LOCAL') IS NOT NULL
DROP TABLE Datavalidation.Service_LOCAL

IF Object_id('Datavalidation.Goal_LOCAL') IS NOT NULL
DROP TABLE Datavalidation.Goal_LOCAL

IF Object_id('Datavalidation.Objective_LOCAL') IS NOT NULL
DROP TABLE Datavalidation.Objective_LOCAL

IF Object_id('Datavalidation.TeamMember_LOCAL') IS NOT NULL
DROP TABLE Datavalidation.TeamMember_LOCAL

IF Object_id('Datavalidation.StaffSchool_LOCAL') IS NOT NULL
DROP TABLE Datavalidation.StaffSchool_LOCAL
*/
/*
DELETE  Datavalidation.SelectLists_LOCAL
DELETE  Datavalidation.District_LOCAL
DELETE  Datavalidation.School_LOCAL
DELETE  Datavalidation.Student_LOCAL
DELETE  Datavalidation.IEP_LOCAL
DELETE  Datavalidation.SpedStaffMember_LOCAL
DELETE  Datavalidation.Service_LOCAL
DELETE  Datavalidation.Goal_LOCAL
DELETE  Datavalidation.Objective_LOCAL
DELETE  Datavalidation.TeamMember_LOCAL
DELETE  Datavalidation.StaffSchool_LOCAL
*/
DECLARE @sql nVARCHAR(MAX)

SET @sql  = 'DELETE Datavalidation.ValidationReport'
EXEC sp_executesql @stmt=@sql

SET @sql  = 'DELETE vh FROM Datavalidation.ValidationReportHistory vh WHERE ValidatedDate < (DATEADD(DD,-60,ValidatedDate))'
EXEC sp_executesql @stmt=@sql

SET @sql = 'DELETE Datavalidation.ValidationSummaryReport'
EXEC sp_executesql @stmt = @sql

DELETE  Datavalidation.SelectLists
DELETE  Datavalidation.District
DELETE  Datavalidation.School
DELETE  Datavalidation.Student
DELETE  Datavalidation.IEP
DELETE  Datavalidation.SpedStaffMember
DELETE  Datavalidation.Service
DELETE  Datavalidation.Goal
DELETE  Datavalidation.Objective
DELETE  Datavalidation.TeamMember
DELETE  Datavalidation.StaffSchool


END