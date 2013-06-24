IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'dbo.Student_Enrich'))
DROP VIEW dbo.Student_Enrich
GO

CREATE VIEW dbo.Student_Enrich
AS
SELECT 
	StudentRefID,
	StudentLocalID,
	StudentStateID , 
	Firstname,
	MiddleName ,
	LastName,
	Birthdate,
	Gender,
	MedicaidNumber ,
	GradeLevelCode , 
	ServiceDistrictCode ,
	ServiceSchoolCode,
	HomeDistrictCode,
	HomeSchoolCode ,
	IsHispanic,
	IsAmericanIndian,
	IsAsian ,
	IsBlackAfricanAmerican,
	IsHawaiianPacIslander ,
	IsWhite,
	Disability1Code,
	Disability2Code,
	Disability3Code,
	Disability4Code,
	Disability5Code,
	Disability6Code,
	Disability7Code,
	Disability8Code,
	Disability9Code,
	ESYElig,
	ESYTBDDate,
	ExitDate ,
	ExitCode ,
	SpecialEdStatus 
FROM Datavalidation.Student
