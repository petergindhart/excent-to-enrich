
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYRTI.RTIStudent_LOCAL') AND type in (N'U'))
DROP TABLE x_LEGACYRTI.RTIStudent_LOCAL  
GO  

CREATE TABLE x_LEGACYRTI.RTIStudent_LOCAL (	
	StudentLocalID	varchar(20) not null, -- remember this might be a GUID or something else in some other environement
	StudentStateID varchar(20) not null,
	FirstName varchar(20) null,
	LastName varchar(20) null,
	StartDate	datetime  null,
	EndDate	datetime null,
	Area VARCHAR(150) null,
	Status VARCHAR(150) null
)
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'x_LEGACYRTI.RTIStudent'))
DROP VIEW x_LEGACYRTI.RTIStudent
GO

CREATE VIEW x_LEGACYRTI.RTIStudent
AS
 SELECT * FROM x_LEGACYRTI.RTIStudent_LOCAL
GO
--
