IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'SelectLists_ValidationSummaryReport') AND type in (N'U'))
DROP TABLE SelectLists_ValidationSummaryReport
GO

CREATE TABLE SelectLists_ValidationSummaryReport
( 
	Description VARCHAR(250),
	NoOfRecords INT
)
 
 
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'District_ValidationSummaryReport') AND type in (N'U'))
DROP TABLE District_ValidationSummaryReport
GO

CREATE TABLE District_ValidationSummaryReport
( 
	Description VARCHAR(250),
	NoOfRecords INT
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'School_ValidationSummaryReport') AND type in (N'U'))
DROP TABLE School_ValidationSummaryReport
GO

CREATE TABLE School_ValidationSummaryReport
( 
	Description VARCHAR(250),
	NoOfRecords INT
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Student_ValidationSummaryReport') AND type in (N'U'))
DROP TABLE Student_ValidationSummaryReport
GO

CREATE TABLE Student_ValidationSummaryReport
( 
	Description VARCHAR(250),
	NoOfRecords INT
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'IEP_ValidationSummaryReport') AND type in (N'U'))
DROP TABLE IEP_ValidationSummaryReport
GO

CREATE TABLE IEP_ValidationSummaryReport
( 
	Description VARCHAR(250),
	NoOfRecords INT
)


IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'SpedStaffMember_ValidationSummaryReport') AND type in (N'U'))
DROP TABLE SpedStaffMember_ValidationSummaryReport
GO

CREATE TABLE SpedStaffMember_ValidationSummaryReport
( 
	Description VARCHAR(250),
	NoOfRecords INT
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Service_ValidationSummaryReport') AND type in (N'U'))
DROP TABLE Service_ValidationSummaryReport
GO

CREATE TABLE Service_ValidationSummaryReport
( 
	Description VARCHAR(250),
	NoOfRecords INT
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Goal_ValidationSummaryReport') AND type in (N'U'))
DROP TABLE Goal_ValidationSummaryReport
GO

CREATE TABLE Goal_ValidationSummaryReport
( 
	Description VARCHAR(250),
	NoOfRecords INT
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Objective_ValidationSummaryReport') AND type in (N'U'))
DROP TABLE Objective_ValidationSummaryReport
GO

CREATE TABLE Objective_ValidationSummaryReport
( 
	Description VARCHAR(250),
	NoOfRecords INT
) 
GO 

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'TeamMember_ValidationSummaryReport') AND type in (N'U'))
DROP TABLE TeamMember_ValidationSummaryReport
GO

CREATE TABLE TeamMember_ValidationSummaryReport
( 
	Description VARCHAR(250),
	NoOfRecords INT
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'StaffSchool_ValidationSummaryReport') AND type in (N'U'))
DROP TABLE StaffSchool_ValidationSummaryReport
GO

CREATE TABLE StaffSchool_ValidationSummaryReport
( 
	Description VARCHAR(250),
	NoOfRecords INT
)
GO