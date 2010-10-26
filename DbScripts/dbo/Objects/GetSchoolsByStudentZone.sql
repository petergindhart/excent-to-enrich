SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetSchoolsByStudentZone]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetSchoolsByStudentZone]
GO

CREATE FUNCTION dbo.GetSchoolsByStudentZone (@userId uniqueidentifier)  
	RETURNS @schools table(id uniqueidentifier, name varchar(50)) AS  
BEGIN 
	DECLARE 
		@districtzone	uniqueidentifier,
		@securityzone	uniqueidentifier
	
	SELECT
		@districtzone	= 'CAC5D55A-794F-4FBE-9D91-8B9E2CE13DD2',
		@securityzone	= SZ.ID
	FROM	
		UserProfile UP JOIN
		SecurityRole SR ON UP.RoleID = SR.ID JOIN
		SecurityRoleZone SRZ ON SR.ID = SRZ.SecurityRoleID JOIN
		SecurityZone SZ ON SRZ.SecurityZoneID = SZ.ID
	WHERE	
		UP.ID = @userId AND
		SZ.ContextTypeID = 'F069CEA9-B0F4-44E2-AD7D-EE03E3F7C0D4'


	-- district zone
	IF @securityzone = @districtzone
	BEGIN
		insert @schools 
		select id, name 
		from School
	END
	
	-- limit by current school
	ELSE
	BEGIN	
		insert @schools

		select s.id, s.name
		from
			UserProfile u join
			Teacher t on t.UserProfileID = u.ID join
			School s on t.CurrentSchoolID = s.ID
		where u.ID = @userId
		
		union
		
		select s.id, s.name
		from
			UserProfile u join
			School s on u.SchoolID = s.ID
		where u.ID = @userId
	END

	return
END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO