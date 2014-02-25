IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'dbo.StaffSchool_Enrich'))
DROP VIEW dbo.StaffSchool_Enrich
GO

CREATE VIEW dbo.StaffSchool_Enrich
AS
SELECT StaffEmail, SchoolCode 
FROM x_DATAVALIDATION.StaffSchool