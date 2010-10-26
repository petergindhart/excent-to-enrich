if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetUserZoneForStudents]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetUserZoneForStudents]
GO

CREATE FUNCTION [dbo].[GetUserZoneForStudents](@userProfileId UNIQUEIDENTIFIER)  
RETURNS TABLE
AS
RETURN
(
	SELECT sz.ID
	FROM
		UserProfile up JOIN
		SecurityRole sr ON up.RoleID = sr.ID JOIN
		SecurityRoleZone srz ON sr.ID = srz.SecurityRoleID JOIN
		SecurityZone sz ON srz.SecurityZoneID = sz.ID
	WHERE
		up.ID = @userProfileId AND
		sz.ContextTypeID = 'F069CEA9-B0F4-44E2-AD7D-EE03E3F7C0D4'
)
GO
