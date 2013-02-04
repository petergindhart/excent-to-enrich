IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'SelectLists_ValidationReport_History') AND type in (N'U'))
DROP TABLE SelectLists_ValidationReport_History
GO

CREATE TABLE SelectLists_ValidationReport_History
( 
	IterationNo INT,
	ValidatedDate DATETIME,
	LineNumber INT,
	Result VARCHAR(MAX)
)
 
 
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'District_ValidationReport_History') AND type in (N'U'))
DROP TABLE District_ValidationReport_History
GO

CREATE TABLE District_ValidationReport_History
( 
	IterationNo INT,
	ValidatedDate DATETIME,
	LineNumber INT,
	Result VARCHAR(MAX)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'School_ValidationReport_History') AND type in (N'U'))
DROP TABLE School_ValidationReport_History
GO

CREATE TABLE School_ValidationReport_History
( 
	IterationNo INT,
	ValidatedDate DATETIME,
	LineNumber INT,
	Result VARCHAR(MAX)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Student_ValidationReport_History') AND type in (N'U'))
DROP TABLE Student_ValidationReport_History
GO

CREATE TABLE Student_ValidationReport_History
( 
	IterationNo INT,
	ValidatedDate DATETIME,
	LineNumber INT,
	Result VARCHAR(MAX)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'IEP_ValidationReport_History') AND type in (N'U'))
DROP TABLE IEP_ValidationReport_HIstory
GO

CREATE TABLE IEP_ValidationReport_History
( 
	IterationNo INT,
	ValidatedDate DATETIME,
	LineNumber INT,
	Result VARCHAR(MAX)
)


IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'SpedStaffMember_ValidationReport_History') AND type in (N'U'))
DROP TABLE SpedStaffMember_ValidationReport_History
GO

CREATE TABLE SpedStaffMember_ValidationReport_History
( 
	IterationNo INT,
	ValidatedDate DATETIME,
	LineNumber INT,
	Result VARCHAR(MAX)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Service_ValidationReport_History') AND type in (N'U'))
DROP TABLE Service_ValidationReport_History
GO

CREATE TABLE Service_ValidationReport_History
( 
	IterationNo INT,
	ValidatedDate DATETIME,
	LineNumber INT,
	Result VARCHAR(MAX)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Goal_ValidationReport_History') AND type in (N'U'))
DROP TABLE Goal_ValidationReport_History
GO

CREATE TABLE Goal_ValidationReport_History
( 
	IterationNo INT,
	ValidatedDate DATETIME,
	LineNumber INT,
	Result VARCHAR(MAX)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Objective_ValidationReport_History') AND type in (N'U'))
DROP TABLE Objective_ValidationReport_History
GO

CREATE TABLE Objective_ValidationReport_History
( 
	IterationNo INT,
	ValidatedDate DATETIME,
	LineNumber INT,
	Result VARCHAR(MAX)
) 
GO 

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'TeamMember_ValidationReport_History') AND type in (N'U'))
DROP TABLE TeamMember_ValidationReport_History
GO

CREATE TABLE TeamMember_ValidationReport_History
( 
	IterationNo INT,
	ValidatedDate DATETIME,
	LineNumber INT,
	Result VARCHAR(MAX)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'StaffSchool_ValidationReport_History') AND type in (N'U'))
DROP TABLE StaffSchool_ValidationReport_History
GO

CREATE TABLE StaffSchool_ValidationReport_History
( 
	IterationNo INT,
	ValidatedDate DATETIME,
	LineNumber INT,
	Result VARCHAR(MAX)
)
GO