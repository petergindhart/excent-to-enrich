IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'SelectLists_ValidationReport') AND type in (N'U'))
DROP TABLE SelectLists_ValidationReport
GO

CREATE TABLE SelectLists_ValidationReport
( 
	ID INT IDENTITY(1,1),
	Result VARCHAR(MAX)
)
 
 
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'District_ValidationReport') AND type in (N'U'))
DROP TABLE District_ValidationReport
GO

CREATE TABLE District_ValidationReport
( 
	ID INT IDENTITY(1,1),
	Result VARCHAR(MAX)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'School_ValidationReport') AND type in (N'U'))
DROP TABLE School_ValidationReport
GO

CREATE TABLE School_ValidationReport
( 
	ID INT IDENTITY(1,1),
	Result VARCHAR(MAX)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Student_ValidationReport') AND type in (N'U'))
DROP TABLE Student_ValidationReport
GO

CREATE TABLE Student_ValidationReport
( 
	ID INT IDENTITY(1,1),
	Result VARCHAR(MAX)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'IEP_ValidationReport') AND type in (N'U'))
DROP TABLE IEP_ValidationReport
GO

CREATE TABLE IEP_ValidationReport
( 
	ID INT IDENTITY(1,1),
	Result VARCHAR(MAX)
)


IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'SpedStaffMember_ValidationReport') AND type in (N'U'))
DROP TABLE SpedStaffMember_ValidationReport
GO

CREATE TABLE SpedStaffMember_ValidationReport
( 
	ID INT IDENTITY(1,1),
	Result VARCHAR(MAX)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Service_ValidationReport') AND type in (N'U'))
DROP TABLE Service_ValidationReport
GO

CREATE TABLE Service_ValidationReport
( 
	ID INT IDENTITY(1,1),
	Result VARCHAR(MAX)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Goal_ValidationReport') AND type in (N'U'))
DROP TABLE Goal_ValidationReport
GO

CREATE TABLE Goal_ValidationReport
( 
	ID INT IDENTITY(1,1),
	Result VARCHAR(MAX)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'Objective_ValidationReport') AND type in (N'U'))
DROP TABLE Objective_ValidationReport
GO

CREATE TABLE Objective_ValidationReport
( 
	ID INT IDENTITY(1,1),
	Result VARCHAR(MAX)
) 
GO 

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'TeamMember_ValidationReport') AND type in (N'U'))
DROP TABLE TeamMember_ValidationReport
GO

CREATE TABLE TeamMember_ValidationReport
( 
	ID INT IDENTITY(1,1),
	Result VARCHAR(MAX)
)
GO

IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'StaffSchool_ValidationReport') AND type in (N'U'))
DROP TABLE StaffSchool_ValidationReport
GO

CREATE TABLE StaffSchool_ValidationReport
( 
	ID INT IDENTITY(1,1),
	Result VARCHAR(MAX)
)
GO