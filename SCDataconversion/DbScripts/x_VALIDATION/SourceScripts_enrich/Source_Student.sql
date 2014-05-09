IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'dbo.Student_Enrich'))
DROP VIEW dbo.Student_Enrich
GO

CREATE VIEW dbo.Student_Enrich
AS
SELECT StudentRefID, StudentLocalID, StudentStateID, MedicaidNumber, Firstname, MiddleName, LastName, Birthdate, Gender, GradeLevelCode, ServiceDistrictCode, ServiceSchoolCode, HomeDistrictCode, HomeSchoolCode, IsHispanic, IsAmericanIndian, IsAsian, IsBlackAfricanAmerican, IsHawaiianPacIslander, IsWhite, Disability1Code, Disability2Code, Disability3Code, Disability4Code, Disability5Code, Disability6Code, Disability7Code, Disability8Code, Disability9Code, EsyElig, EsyTBDDate, ExitDate, ExitCode, SpecialEdStatus 
FROM x_DATAVALIDATION.Student
