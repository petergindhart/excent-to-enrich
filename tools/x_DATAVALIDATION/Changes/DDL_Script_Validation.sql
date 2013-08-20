
----------------------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.SelectLists_LOCAL') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.SelectLists_LOCAL
GO

CREATE TABLE x_DATAVALIDATION.SelectLists_LOCAL(
Line_No INT,
Type	varchar(max) null,
SubType	varchar(max) null,
EnrichID varchar(max) null, 
StateCode	varchar(max) null,
LegacySpedCode	varchar(max) null,
EnrichLabel	varchar(max) not null
--Sequence	varchar(max),
--DisplayInUI char(1)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.District_LOCAL') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.District_LOCAL
GO

CREATE TABLE x_DATAVALIDATION.District_LOCAL(
Line_No INT,
DistrictCode    varchar(max)  null,
DistrictName    varchar(max) null
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.School_LOCAL') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.School_LOCAL
GO

CREATE TABLE x_DATAVALIDATION.School_LOCAL(
Line_No INT,
SchoolCode    varchar(max),
SchoolName    varchar(max),
DistrictCode   varchar(max),
MinutesPerWeek	varchar(max)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.Student_LOCAL') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.Student_LOCAL  
GO  
  
CREATE TABLE x_DATAVALIDATION.Student_LOCAL(
Line_No INT,
StudentRefID    varchar(max),
StudentLocalID	varchar(max),
StudentStateID    varchar(max),
Firstname    varchar(max),
MiddleName    varchar(max),
LastName    varchar(max),
Birthdate   varchar(max),
Gender    varchar(max),
MedicaidNumber	varchar(max),
GradeLevelCode    varchar(max),
ServiceDistrictCode   varchar(max),
ServiceSchoolCode    varchar(max),
HomeDistrictCode    varchar(max),
HomeSchoolCode    varchar(max),
IsHispanic    varchar(max),
IsAmericanIndian    varchar(max),
IsAsian    varchar(max),
IsBlackAfricanAmerican    varchar(max),
IsHawaiianPacIslander    varchar(max),
IsWhite    varchar(max),
Disability1Code    varchar(max),
Disability2Code    varchar(max),
Disability3Code    varchar(max),
Disability4Code    varchar(max),
Disability5Code    varchar(max),
Disability6Code    varchar(max),
Disability7Code    varchar(max),
Disability8Code    varchar(max),
Disability9Code    varchar(max),
EsyElig	varchar(max),
EsyTBDDate varchar(max),
ExitDate varchar(max),
ExitCode varchar(max),
SpecialEdStatus varchar(max)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.IEP_LOCAL') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.IEP_LOCAL
GO

CREATE TABLE x_DATAVALIDATION.IEP_LOCAL(
Line_No INT,
IepRefID	varchar(max),
StudentRefID	varchar(max),
IEPMeetDate	varchar(max),
IEPStartDate	varchar(max),
IEPEndDate	varchar(max),
NextReviewDate	varchar(max),
InitialEvaluationDate	varchar(max),
LatestEvaluationDate	varchar(max),
NextEvaluationDate	varchar(max),
EligibilityDate varchar(max),
ConsentForServicesDate	varchar(max),
ConsentForEvaluationDate	varchar(max),
LREAgeGroup varchar(max),
LRECode	varchar(max),
MinutesPerWeek	varchar(max),
ServiceDeliveryStatement	varchar(max)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.SpedStaffMember_LOCAL') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.SpedStaffMember_LOCAL  
GO  

CREATE TABLE x_DATAVALIDATION.SpedStaffMember_LOCAL(  
Line_No INT,
StaffEmail		varchar(max),
Firstname		varchar(max), 
Lastname		varchar(max), 
EnrichRole 		varchar(max)
)  
GO  

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.Service_LOCAL') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.Service_LOCAL  
GO  


CREATE TABLE x_DATAVALIDATION.Service_LOCAL(  
Line_No INT,
ServiceType    varchar(max),
ServiceRefId    varchar(max),
IepRefId    varchar(max),
ServiceDefinitionCode    varchar(max),
BeginDate    varchar(max), 
EndDate    varchar(max),
IsRelated   varchar(max),
IsDirect    varchar(max),
ExcludesFromGenEd    varchar(max), 
ServiceLocationCode   varchar(max),
ServiceProviderTitleCode   varchar(max),
Sequence   varchar(max),
IsESY   varchar(max),
ServiceTime   varchar(max),
ServiceFrequencyCode   varchar(max),
ServiceProviderSSN   varchar(max),
StaffEmail varchar(max),
ServiceAreaText    varchar(max)
)
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.Goal_LOCAL') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.Goal_LOCAL
GO
CREATE TABLE x_DATAVALIDATION.Goal_LOCAL(  
Line_No INT,
GoalRefID		  varchar(max),
IepRefID		  varchar(max),
Sequence		 varchar(max),
GoalAreaCode	varchar(max),
PSEducation	varchar(max),
PSEmployment	varchar(max),
PSIndependent	varchar(max),
IsEsy		  varchar(max),
UNITOFMEASUREMENT varchar(max),
BASELINEDATAPOINT varchar(max),
EVALUATIONMETHOD varchar(max),
GoalStatement	varchar(max)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.Objective_LOCAL') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.Objective_LOCAL  
GO  
  
CREATE TABLE x_DATAVALIDATION.Objective_LOCAL( 
  Line_No INT, 
  ObjectiveRefID	varchar(max),
  GoalRefID	varchar(max),
  Sequence	varchar(max),
  ObjText	varchar(max)
)  
GO  	

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.TeamMember_LOCAL') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.TeamMember_LOCAL  
GO  
  
CREATE TABLE x_DATAVALIDATION.TeamMember_LOCAL( 
  Line_No INT, 
  StaffEmail	varchar(max),
  StudentRefId	varchar(max),
  IsCaseManager	varchar(max)
)  
GO 

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.StaffSchool_LOCAL') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.StaffSchool_LOCAL  
GO  
  
CREATE TABLE x_DATAVALIDATION.StaffSchool_LOCAL(  
  Line_No INT,
  StaffEmail	varchar(max),
  SchoolCode	varchar(max)
)  
GO   

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.AccomMod_LOCAL') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.AccomMod_LOCAL  
GO  
  
CREATE TABLE x_DATAVALIDATION.AccomMod_LOCAL(
  Line_No INT,  
  IEPRefID	varchar(150)	not null,
  AccomStatement	varchar(8000)   null,
  ModStatement	varchar(8000)   null
)  
GO


IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.SchoolProgressFrequency_LOCAL') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.SchoolProgressFrequency_LOCAL  
GO  
  
CREATE TABLE x_DATAVALIDATION.SchoolProgressFrequency_LOCAL(
  Line_No INT,  
  SchoolCode	varchar(10)	not null,
  FrequencyName	varchar(50)   null
)  
GO  
  

/*
Tables to store validated data
*/
----------------------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.SelectLists') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.SelectLists
GO

CREATE TABLE x_DATAVALIDATION.SelectLists(
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

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.District') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.District
GO

CREATE TABLE x_DATAVALIDATION.District(
Line_No INT,
DistrictCode    varchar(10) not null,
DistrictName    varchar(255) not null
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.School') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.School
GO

CREATE TABLE x_DATAVALIDATION.School(
Line_No INT,
SchoolCode    varchar(10) not null,
SchoolName    varchar(254) not null,  --Need to check this
DistrictCode    varchar(10) not null,
MinutesPerWeek	int not null
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.Student') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.Student  
GO  
  
CREATE TABLE x_DATAVALIDATION.Student(
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

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.IEP') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.IEP
GO

CREATE TABLE x_DATAVALIDATION.IEP(
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

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.SpedStaffMember') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.SpedStaffMember  
GO  

CREATE TABLE x_DATAVALIDATION.SpedStaffMember(
Line_No INT,  
StaffEmail		varchar(150) not null,
Firstname		varchar(50) not null, 
Lastname		varchar(50) not null, 
EnrichRole 		varchar(50) null
)  
GO  

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.Service') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.Service  
GO  


CREATE TABLE x_DATAVALIDATION.Service( 
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

IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.Goal') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.Goal
GO
CREATE TABLE x_DATAVALIDATION.Goal(
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

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.Objective') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.Objective  
GO  
  
CREATE TABLE x_DATAVALIDATION.Objective( 
  Line_No INT, 
  ObjectiveRefID	varchar(150)	not null,
  GoalRefID	varchar(150)	not null,
  Sequence	int,
  ObjText	varchar(8000)
)  
GO  	

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.TeamMember') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.TeamMember  
GO  
  
CREATE TABLE x_DATAVALIDATION.TeamMember( 
  Line_No INT, 
  StaffEmail	varchar(150)	not null,
  StudentRefId	varchar(150)	not null,
  IsCaseManager	varchar(1)	not null
)  
GO 

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.StaffSchool') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.StaffSchool  
GO  
  
CREATE TABLE x_DATAVALIDATION.StaffSchool(
  Line_No INT,  
  StaffEmail	varchar(150)	not null,
  SchoolCode	varchar(10)     not null
)  
GO  

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.AccomMod') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.AccomMod  
GO  
  
CREATE TABLE x_DATAVALIDATION.AccomMod(
  Line_No INT,  
  IEPRefID	varchar(150)	not null,
  AccomStatement	varchar(8000)   null,
  ModStatement	varchar(8000)   null
)  
GO  

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.SchoolProgressFrequency') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.SchoolProgressFrequency  
GO  
  
CREATE TABLE x_DATAVALIDATION.SchoolProgressFrequency(
  Line_No INT,  
  SchoolCode	varchar(10)	not null,
  FrequencyName	varchar(50)  null
)  
GO 

--=========================================================================================================
--To store the validation reports of data files for that iteration
--=========================================================================================================
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.ValidationReport') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.ValidationReport
GO

CREATE TABLE x_DATAVALIDATION.ValidationReport
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

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.ValidationReportHistory') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.ValidationReportHistory
GO

CREATE TABLE x_DATAVALIDATION.ValidationReportHistory
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
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.ValidationSummaryReport') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.ValidationSummaryReport
GO

CREATE TABLE x_DATAVALIDATION.ValidationSummaryReport
( 
	TableName VARCHAR(50),
	ErrorMessage VARCHAR(500),
	NumberOfRecords INT
)	
--=========================================================================================================
--To Store the  validation rules (data specifications)
--=========================================================================================================

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.ValidationRules') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.ValidationRules
GO

CREATE TABLE x_DATAVALIDATION.ValidationRules
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

--=========================================================================================================
--To Store the  Datafiles order (data specifications)
--=========================================================================================================

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_DATAVALIDATION.TableOrder') AND type in (N'U'))
DROP TABLE x_DATAVALIDATION.TableOrder
GO

CREATE TABLE x_DATAVALIDATION.TableOrder 
(
Sequence INT NOT NULL,
Tablename varchar(100) NOT NULL
)