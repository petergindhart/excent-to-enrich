IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'dbo.TeamMember_Enrich'))
DROP VIEW dbo.TeamMember_Enrich
GO

CREATE VIEW dbo.TeamMember_Enrich
AS
SELECT StaffEmail, StudentRefId, IsCaseManager 
FROM x_DATAVALIDATION.TeamMember