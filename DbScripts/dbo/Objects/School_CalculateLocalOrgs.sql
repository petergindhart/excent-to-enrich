IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[School_CalculateLocalOrgs]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[School_CalculateLocalOrgs]
GO

CREATE PROCEDURE dbo.School_CalculateLocalOrgs
AS

-- Find the local org root (usually the district)
DECLARE @localOrgRoot uniqueidentifier
select 
	@localOrgRoot = LocalOrgRootID 
From 
	SystemSettings

-- If there is no existing OrgUnitID, then set it to the current local org from system settings (usually the District)
UPDATE School
SET 
	OrgUnitID = @localOrgRoot
WHERE
	OrgUnitID is null
	
-- Determine if the org unit of the school is a descendant of the local root (usually the district and usually it is)
UPDATE School
SET	IsLocalOrg = dbo.OrgUnit_IsChildOf(OrgUnitID, @localOrgRoot) 