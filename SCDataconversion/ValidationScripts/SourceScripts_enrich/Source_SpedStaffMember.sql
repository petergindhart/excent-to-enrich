IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'dbo.SpedStaffMember_Enrich'))
DROP VIEW dbo.SpedStaffMember_Enrich
GO

CREATE VIEW dbo.SpedStaffMember_Enrich
AS
SELECT StaffEmail, Lastname, Firstname, EnrichRole 
FROM x_DATAVALIDATION.SpedStaffMember