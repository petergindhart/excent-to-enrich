IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[AURORAX].[Student_LOCAL]') AND type in (N'U'))
DROP TABLE [AURORAX].[Student_LOCAL]  
GO  
  
CREATE TABLE [AURORAX].[Student_LOCAL](
StudentRefID    varchar(150),
StudentLocalID	varchar(50),
StudentStateID    varchar(50),
MedicaidNumber	varchar(50),
Firstname    varchar(50),
MiddleName    varchar(50), 
LastName    varchar(50),
Birthdate    datetime, 
Sex    varchar(1), 
GradeLevelCode    varchar(150),
ServiceDistrictRefID    varchar(150),
ServiceSchoolRefID    varchar(150),
HomeDistrictRefID    varchar(150),
HomeSchoolRefID    varchar(150),
EthnicityCode    varchar(150),
IsHispanic    varchar(1),
IsAmericanIndian    varchar(1),
IsAsian    varchar(1),
IsBlackAfricanAmerican    varchar(1), 
IsHawaiianPacIslander    varchar(1),
IsWhite    varchar(1), 
Disability1Code    varchar(150), 
Disability2Code    varchar(150),
ExitDate datetime,
ExitCode varchar(150),
SpecialEdStatus char(1)
)
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[AURORAX].[Student]'))
DROP VIEW [AURORAX].[Student]
GO

CREATE VIEW [AURORAX].[Student]
AS
 SELECT * FROM [AURORAX].[Student_LOCAL]
GO
--