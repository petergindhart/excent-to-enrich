IF EXISTS(select * from sys.schemas where name = 'Datavalidation')
DROP SCHEMA Datavalidation
GO
CREATE SCHEMA Datavalidation
GO

/*
Staging tables to import the Source file data
*/
----------------------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.SelectLists_LOCAL') AND type in (N'U'))
DROP TABLE Datavalidation.SelectLists_LOCAL
GO

CREATE TABLE Datavalidation.SelectLists_LOCAL(
Line_No INT,
Type	varchar(20) not null,
SubType	varchar(20) null,
EnrichID varchar(150) null, 
StateCode	varchar(20) null,
LegacySpedCode	varchar(150) null,
EnrichLabel	varchar(254) not null
--Sequence	varchar(3),
--DisplayInUI char(1)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.District_LOCAL') AND type in (N'U'))
DROP TABLE Datavalidation.District_LOCAL
GO

CREATE TABLE Datavalidation.District_LOCAL(
Line_No INT,
DistrictCode    varchar(10) not null,
DistrictName    varchar(255) not null
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.School_LOCAL') AND type in (N'U'))
DROP TABLE Datavalidation.School_LOCAL
GO

CREATE TABLE Datavalidation.School_LOCAL(
Line_No INT,
SchoolCode    varchar(10) not null,
SchoolName    varchar(255) not null,
DistrictCode    varchar(10) not null,
MinutesPerWeek	int not null
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.Student_LOCAL') AND type in (N'U'))
DROP TABLE Datavalidation.Student_LOCAL  
GO  
  
CREATE TABLE Datavalidation.Student_LOCAL(
Line_No INT,
StudentRefID    varchar(150) not null,
StudentLocalID	varchar(50) not null,
StudentStateID    varchar(50) not null,
Firstname    varchar(50) not null,
MiddleName    varchar(50) null, 
LastName    varchar(50) not null,
Birthdate    datetime not null, 
Gender    varchar(150) not null, 
MedicaidNumber	varchar(50) null,
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

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.IEP_LOCAL') AND type in (N'U'))
DROP TABLE Datavalidation.IEP_LOCAL
GO

CREATE TABLE Datavalidation.IEP_LOCAL(
Line_No INT,
IepRefID	varchar(150) not null,
StudentRefID	varchar(150) not null,
IEPMeetDate	datetime not null,
IEPStartDate	datetime not null,
IEPEndDate	datetime not null,
NextReviewDate	datetime not null,
InitialEvaluationDate	datetime null,
LatestEvaluationDate	datetime not null,
NextEvaluationDate	datetime not null,
EligibilityDate datetime null,
ConsentForServicesDate	datetime not null,
ConsentForEvaluationDate	datetime null,
LREAgeGroup varchar(3) null,
LRECode	varchar(150) not null,
MinutesPerWeek	int not null,
ServiceDeliveryStatement	varchar(8000) null
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.SpedStaffMember_LOCAL') AND type in (N'U'))
DROP TABLE Datavalidation.SpedStaffMember_LOCAL  
GO  

CREATE TABLE Datavalidation.SpedStaffMember_LOCAL(  
Line_No INT,
StaffEmail		varchar(150) not null,
Firstname		varchar(50) not null, 
Lastname		varchar(50) not null, 
EnrichRole 		varchar(50) null
)  
GO  

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.Service_LOCAL') AND type in (N'U'))
DROP TABLE Datavalidation.Service_LOCAL  
GO  


CREATE TABLE Datavalidation.Service_LOCAL(  
Line_No INT,
ServiceType    varchar(20) not null, 
ServiceRefId    varchar(150) not null, 
IepRefId    varchar(150) not null,
ServiceDefinitionCode    varchar(150) null,
BeginDate    datetime not null, 
EndDate    datetime null, 
IsRelated    varchar(1) not null, 
IsDirect    varchar(1) not null, 
ExcludesFromGenEd    varchar(1) not null, 
ServiceLocationCode    varchar(150) not null, 
ServiceProviderTitleCode    varchar(150) not null,
Sequence    int null, 
IsESY    varchar(1) null,
ServiceTime    int not null, 
ServiceFrequencyCode    varchar(150) not null,
ServiceProviderSSN    varchar(11) null, 
StaffEmail varchar(150) null,
ServiceAreaText    varchar(254) null
)
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.Goal_LOCAL') AND type in (N'U'))
DROP TABLE Datavalidation.Goal_LOCAL
GO
CREATE TABLE Datavalidation.Goal_LOCAL(  
Line_No INT,
GoalRefID		  varchar(150), 
IepRefID		  varchar(150), 
Sequence		  varchar(3),
GoalAreaCode		varchar(150),
PSEducation	varchar(1),
PSEmployment	varchar(1),
PSIndependent	varchar(1),
IsEsy		  varchar(1),
UNITOFMEASUREMENT VARCHAR(100),
BASELINEDATAPOINT VARCHAR(100),
EVALUATIONMETHOD VARCHAR(100),
GoalStatement	 varchar(8000)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.Objective_LOCAL') AND type in (N'U'))
DROP TABLE Datavalidation.Objective_LOCAL  
GO  
  
CREATE TABLE Datavalidation.Objective_LOCAL( 
  Line_No INT, 
  ObjectiveRefID	varchar(150)	not null,
  GoalRefID	varchar(150)	not null,
  Sequence	int,
  ObjText	varchar(8000)
)  
GO  	

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.TeamMember_LOCAL') AND type in (N'U'))
DROP TABLE Datavalidation.TeamMember_LOCAL  
GO  
  
CREATE TABLE Datavalidation.TeamMember_LOCAL( 
  Line_No INT, 
  StaffEmail	varchar(150)	not null,
  StudentRefId	varchar(150)	not null,
  IsCaseManager	varchar(1)	not null
)  
GO 

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.StaffSchool_LOCAL') AND type in (N'U'))
DROP TABLE Datavalidation.StaffSchool_LOCAL  
GO  
  
CREATE TABLE Datavalidation.StaffSchool_LOCAL(  
  Line_No INT,
  StaffEmail	varchar(150)	not null,
  SchoolCode	varchar(10)     not null
)  
GO   

/*
Tables to store validated data
*/
----------------------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.SelectLists') AND type in (N'U'))
DROP TABLE Datavalidation.SelectLists
GO

CREATE TABLE Datavalidation.SelectLists(
Line_No INT,
Type	varchar(20) not null,
SubType	varchar(20) null,
EnrichID varchar(150) null, 
StateCode	varchar(10) null,   --Need to check dl 20 or 10
LegacySpedCode	varchar(150) null,
EnrichLabel	varchar(254) not null
--Sequence	varchar(3),
--DisplayInUI char(1)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.District') AND type in (N'U'))
DROP TABLE Datavalidation.District
GO

CREATE TABLE Datavalidation.District(
Line_No INT,
DistrictCode    varchar(10) not null,
DistrictName    varchar(255) not null
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.School') AND type in (N'U'))
DROP TABLE Datavalidation.School
GO

CREATE TABLE Datavalidation.School(
Line_No INT,
SchoolCode    varchar(10) not null,
SchoolName    varchar(254) not null,  --Need to check this
DistrictCode    varchar(10) not null,
MinutesPerWeek	int not null
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.Student') AND type in (N'U'))
DROP TABLE Datavalidation.Student  
GO  
  
CREATE TABLE Datavalidation.Student(
Line_No INT,
StudentRefID    varchar(150) not null,
StudentLocalID	varchar(50) not null,
StudentStateID    varchar(50) not null,
Firstname    varchar(50) not null,
MiddleName    varchar(50) null, 
LastName    varchar(50) not null,
Birthdate    datetime not null, 
Gender    varchar(150) not null, 
MedicaidNumber	varchar(50) null,
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

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.IEP') AND type in (N'U'))
DROP TABLE Datavalidation.IEP
GO

CREATE TABLE Datavalidation.IEP(
Line_No INT,
IepRefID	varchar(150) not null,
StudentRefID	varchar(150) not null,
IEPMeetDate	datetime not null,
IEPStartDate	datetime not null,
IEPEndDate	datetime not null,
NextReviewDate	datetime not null,
InitialEvaluationDate	datetime null,
LatestEvaluationDate	datetime not null,
NextEvaluationDate	datetime not null,
EligibilityDate datetime null,
ConsentForServicesDate	datetime not null,
ConsentForEvaluationDate	datetime null,
LREAgeGroup varchar(3) null,
LRECode	varchar(150) not null,
MinutesPerWeek	int not null,
ServiceDeliveryStatement	varchar(8000) null
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.SpedStaffMember') AND type in (N'U'))
DROP TABLE Datavalidation.SpedStaffMember  
GO  

CREATE TABLE Datavalidation.SpedStaffMember(
Line_No INT,  
StaffEmail		varchar(150) not null,
Firstname		varchar(50) not null, 
Lastname		varchar(50) not null, 
EnrichRole 		varchar(50) null
)  
GO  

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.Service') AND type in (N'U'))
DROP TABLE Datavalidation.Service  
GO  


CREATE TABLE Datavalidation.Service( 
Line_No INT, 
ServiceType    varchar(20) not null, 
ServiceRefId    varchar(150) not null, 
IepRefId    varchar(150) not null,
ServiceDefinitionCode    varchar(150) null,
BeginDate    datetime not null, 
EndDate    datetime null, 
IsRelated    varchar(1) not null, 
IsDirect    varchar(1) not null, 
ExcludesFromGenEd    varchar(1) not null, 
ServiceLocationCode    varchar(150) not null, 
ServiceProviderTitleCode    varchar(150) not null,
Sequence    int null, 
IsESY    varchar(1) null,
ServiceTime    int not null, 
ServiceFrequencyCode    varchar(150) not null,
ServiceProviderSSN    varchar(11) null, 
StaffEmail varchar(150) null,
ServiceAreaText    varchar(254) null
)
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.Goal') AND type in (N'U'))
DROP TABLE Datavalidation.Goal
GO
CREATE TABLE Datavalidation.Goal(
Line_No INT,  
GoalRefID		  varchar(150), 
IepRefID		  varchar(150), 
Sequence		  varchar(2),
GoalAreaCode		varchar(150),
PSEducation	varchar(1),
PSEmployment	varchar(1),
PSIndependent	varchar(1),
IsEsy		  varchar(1),
UNITOFMEASUREMENT VARCHAR(100),
BASELINEDATAPOINT VARCHAR(100),
EVALUATIONMETHOD VARCHAR(100),
GoalStatement	 varchar(8000)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.Objective') AND type in (N'U'))
DROP TABLE Datavalidation.Objective  
GO  
  
CREATE TABLE Datavalidation.Objective( 
  Line_No INT, 
  ObjectiveRefID	varchar(150)	not null,
  GoalRefID	varchar(150)	not null,
  Sequence	int,
  ObjText	varchar(8000)
)  
GO  	

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.TeamMember') AND type in (N'U'))
DROP TABLE Datavalidation.TeamMember  
GO  
  
CREATE TABLE Datavalidation.TeamMember( 
  Line_No INT, 
  StaffEmail	varchar(150)	not null,
  StudentRefId	varchar(150)	not null,
  IsCaseManager	varchar(1)	not null
)  
GO 

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.StaffSchool') AND type in (N'U'))
DROP TABLE Datavalidation.StaffSchool  
GO  
  
CREATE TABLE Datavalidation.StaffSchool(
  Line_No INT,  
  StaffEmail	varchar(150)	not null,
  SchoolCode	varchar(10)     not null
)  
GO  

--=========================================================================================================
--To store the validation reports of data files for that iteration
--=========================================================================================================
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.ValidationReport') AND type in (N'U'))
DROP TABLE Datavalidation.ValidationReport
GO

CREATE TABLE Datavalidation.ValidationReport
( 
	ID INT IDENTITY(1,1),
	TableName VARCHAR(50),
	ErrorMessage VARCHAR(500),
	LineNumber VARCHAR(5) ,  --Need to check this
	Line VARCHAR(MAX)
)
--=========================================================================================================
--To Store the valiation report history 
--=========================================================================================================

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.ValidationReportHistory') AND type in (N'U'))
DROP TABLE Datavalidation.ValidationReportHistory
GO

CREATE TABLE Datavalidation.ValidationReportHistory
( 
	IterationNumber INT,
    ValidatedDate	Datetime,
	TableName VARCHAR(50),
	ErrorMessage VARCHAR(500),
	LineNumber VARCHAR(5) ,  --Need to check this
	Line VARCHAR(MAX)
)
--=========================================================================================================
--To Store the  validation summary report for that iteration
--=========================================================================================================
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.ValidationSummaryReport') AND type in (N'U'))
DROP TABLE Datavalidation.ValidationSummaryReport
GO

CREATE TABLE Datavalidation.ValidationSummaryReport
( 
	TableName VARCHAR(50),
	ErrorMessage VARCHAR(500),
	NumberOfRecords INT
)	
--=========================================================================================================
--To Store the  validation rules (data specifications)
--=========================================================================================================

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Datavalidation.ValidationRules') AND type in (N'U'))
DROP TABLE Datavalidation.ValidationRules
GO

CREATE TABLE Datavalidation.ValidationRules
( 
	TableSchema VARCHAR(50),
	TableName VARCHAR(50),
	ColumnName VARCHAR(50),
	ColumnOrder INT,
	DataType VARCHAR(50),
	DataLength VARCHAR(50),
	IsRequired BIT,
	IsUniqueField BIT,
	IsFkRelation BIT,
	ParentTable VARCHAR(50),
	ParentColumn VARCHAR(50),	
	IsLookupColumn BIT,
	LookupTable VARCHAR(50),
	LookupColumn VARCHAR(50),
	LookUpType VARCHAR(50),
	IsFlagfield  BIT,
	FlagRecords VARCHAR(10)
)
GO