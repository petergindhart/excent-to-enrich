IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.Student_LOCAL') AND type in (N'U'))
DROP TABLE LEGACYSPED.Student_LOCAL  
GO  
  
CREATE TABLE LEGACYSPED.Student_LOCAL(
StudentRefID    varchar(150),
StudentLocalID	varchar(50),
StudentStateID    varchar(50),
MedicaidNumber	varchar(50),
Firstname    varchar(50),
MiddleName    varchar(50), 
LastName    varchar(50),
Birthdate    datetime, 
Gender    varchar(1), --changed column name sex to Gender
GradeLevelCode    varchar(150),
ServiceDistrictCode    varchar(10),
ServiceSchoolCode    varchar(10),
HomeDistrictCode    varchar(10),
HomeSchoolCode    varchar(10),
EthnicityCode    varchar(150),
IsHispanic    varchar(1),
IsAmericanIndian    varchar(1),
IsAsian    varchar(1),
IsBlackAfricanAmerican    varchar(1),
IsHawaiianPacIslander    varchar(1),
IsWhite    varchar(1), 
Disability1Code    varchar(150),
Disability2Code    varchar(150),
Disability3Code    varchar(150),
Disability4Code    varchar(150),
Disability5Code    varchar(150),
Disability6Code    varchar(150),
Disability7Code    varchar(150),
Disability8Code    varchar(150),
Disability9Code    varchar(150),
EsyElig	varchar(1),
EsyTBDDate varchar(10),
ExitDate datetime,
ExitCode varchar(150),
SpecialEdStatus char(1)
)
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'LEGACYSPED.Student'))
DROP VIEW LEGACYSPED.Student
GO

CREATE VIEW LEGACYSPED.Student
AS
 SELECT * FROM LEGACYSPED.Student_LOCAL
GO
--
