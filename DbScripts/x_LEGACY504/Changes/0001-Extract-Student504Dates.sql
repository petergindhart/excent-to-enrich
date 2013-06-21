
IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'x_LEGACY504.Student504Dates_LOCAL') AND type in (N'U'))
DROP TABLE x_LEGACY504.Student504Dates_LOCAL  
GO  

CREATE TABLE x_LEGACY504.Student504Dates_LOCAL(	
	StudentNumber	varchar(20) not null, -- remember this might be a GUID or something else in some other environement
	StartDate	datetime not null,
	EndDate	datetime	not null
)
GO

IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'x_LEGACY504.Student504Dates'))
DROP VIEW x_LEGACY504.Student504Dates
GO

CREATE VIEW x_LEGACY504.Student504Dates
AS
 SELECT * FROM x_LEGACY504.Student504Dates_LOCAL
GO
--
