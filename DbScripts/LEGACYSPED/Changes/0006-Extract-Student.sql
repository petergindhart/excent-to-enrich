IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.Student_LOCAL') AND type in (N'U'))
DROP TABLE LEGACYSPED.Student_LOCAL  
GO  
  
CREATE TABLE LEGACYSPED.Student_LOCAL(
StudentRefID    varchar(150) not null,
StudentLocalID	varchar(50) not null,
StudentStateID    varchar(50) not null,
MedicaidNumber	varchar(50) null,
Firstname    varchar(50) not null,
MiddleName    varchar(50) null, 
LastName    varchar(50) not null,
Birthdate    datetime not null, 
Gender    varchar(150) not null, --changed column name sex to Gender
GradeLevelCode    varchar(150) not null,
ServiceDistrictCode    varchar(10) not null,
ServiceSchoolCode    varchar(10) not null,
HomeDistrictCode    varchar(10) not null,
HomeSchoolCode    varchar(10) not null,
IsHispanic    varchar(1) null,
IsAmericanIndian    varchar(1) null,
IsAsian    varchar(1) null,
IsBlackAfricanAmerican    varchar(1) null,
IsHawaiianPacIslander    varchar(1) null,
IsWhite    varchar(1) null, 
Disability1Code    varchar(150) not null,
Disability2Code    varchar(150) null,
Disability3Code    varchar(150) null,
Disability4Code    varchar(150) null,
Disability5Code    varchar(150) null,
Disability6Code    varchar(150) null,
Disability7Code    varchar(150) null,
Disability8Code    varchar(150) null,
Disability9Code    varchar(150) null,
EsyElig	varchar(1) null,
EsyTBDDate datetime null,
ExitDate datetime null,
ExitCode varchar(150) null,
SpecialEdStatus char(1) not null
)
GO
Alter table LEGACYSPED.Student_LOCAL
add constraint PK_LEGACYSPED_Student_LOCAL_StudentRefID primary key (StudentRefID)
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'LEGACYSPED.Student'))
DROP VIEW LEGACYSPED.Student
GO

CREATE VIEW LEGACYSPED.Student
AS
 SELECT * FROM LEGACYSPED.Student_LOCAL
GO
--
