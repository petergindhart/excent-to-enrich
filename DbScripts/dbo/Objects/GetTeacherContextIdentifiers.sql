if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetTeacherContextIdentifiers]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetTeacherContextIdentifiers]
GO

CREATE FUNCTION dbo.GetTeacherContextIdentifiers (@userid uniqueidentifier, @currentDate datetime)  
	RETURNS @idTable table(id uniqueidentifier) AS  
BEGIN 
	
	DECLARE @districtzone 		uniqueidentifier
	DECLARE @schoolzone 		uniqueidentifier
	DECLARE @selfzone 		uniqueidentifier
	DECLARE @nonezone	 	uniqueidentifier

	DECLARE @teacherid 		uniqueidentifier
	DECLARE @startDate		datetime
	DECLARE @endDate		datetime
	DECLARE @securityzone 		uniqueidentifier
	
	SET @districtzone 		= '26990B93-F0C8-419D-86AC-202A4873CBA6'
	SET @schoolzone			= 'DF72823A-CB12-4AE5-B894-EF1BFE50C46F'
	SET @selfzone			= '056B63E9-434E-4CE5-ADE1-3812157825B8'
	SET @nonezone			= '3A887A6D-69DF-4E02-B0F5-89AAEBBC2E92'
	
	SELECT	@securityzone = SZ.ID
	FROM	UserProfile UP JOIN
		SecurityRole SR ON UP.RoleID = SR.ID JOIN
		SecurityRoleZone SRZ ON SR.ID = SRZ.SecurityRoleID JOIN
		SecurityZone SZ ON SRZ.SecurityZoneID = SZ.ID
	WHERE	UP.ID = @userId AND
		SZ.ContextTypeID = 'FD1C4A90-0AB0-4D47-9A6B-6DA442C35086'

	-- district zone
	IF @securityzone = @districtzone
	BEGIN
		return
	END
	
	-- school zone
	ELSE IF @securityzone = @schoolzone
	BEGIN
		-- insert the current school id of the user into 
		-- the idTable
		INSERT @idTable SELECT schoolid FROM UserProfile WHERE 
			ID = @userid
		return
	END
	
	-- self zone
	ELSE IF @securityzone = @selfzone
	BEGIN
		-- insert the class roster identifies in the idTable
		INSERT @idTable 
			SELECT Id from Teacher WHERE UserProfileID = @userid
		return
	END
	
	-- none zone
	ELSE IF @securityzone = @nonezone
	BEGIN
		return
	END
	
	return
END
GO
