IF EXISTS (SELECT 1 FROM sys.schemas s join sys.objects o on s.schema_id = o.schema_id where s.name = 'Datavalidation' and o.name = 'Cleanup')
DROP PROC Datavalidation.Cleanup
GO

CREATE PROC Datavalidation.Cleanup 
AS
BEGIN

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