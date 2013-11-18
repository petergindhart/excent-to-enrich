
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACYESOL.ESOLStudent_LOCAL') AND type in (N'U'))
DROP TABLE x_LEGACYESOL.ESOLStudent_LOCAL  
GO  

CREATE TABLE x_LEGACYESOL.ESOLStudent_LOCAL (	
	StudentLocalID	varchar(20) not null, -- remember this might be a GUID or something else in some other environement
	StudentStateID varchar(20) not null,
	FirstName varchar(20) null,
	LastName varchar(20) null ,
	StartDate	datetime  null,
	EndDate	datetime null
)
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'x_LEGACYESOL.ESOLStudent'))
DROP VIEW x_LEGACYESOL.ESOLStudent
GO

CREATE VIEW x_LEGACYESOL.ESOLStudent
AS
 SELECT * FROM x_LEGACYESOL.ESOLStudent_LOCAL
GO
--
