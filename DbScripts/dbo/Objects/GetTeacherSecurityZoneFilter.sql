SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetTeacherSecurityZoneFilter]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetTeacherSecurityZoneFilter]
GO



/*
<summary>
Returns the sql used to filter based on a 
Security Zone
</summary>
*/

CREATE FUNCTION dbo.GetTeacherSecurityZoneFilter
(
@tableAlias 		varchar(64), 
@userId		  	uniqueidentifier,
@currentDate		datetime
)
RETURNS varchar(8000)
AS
BEGIN

	DECLARE @districtzone		uniqueidentifier
	DECLARE @schoolzone 		uniqueidentifier
	DECLARE @selfzone 		uniqueidentifier
	DECLARE @none		 	uniqueidentifier
	DECLARE @sql 			varchar(8000)

	SET @districtzone 		= '26990B93-F0C8-419D-86AC-202A4873CBA6'
	SET @schoolzone			= 'DF72823A-CB12-4AE5-B894-EF1BFE50C46F'
	SET @selfzone			= '056B63E9-434E-4CE5-ADE1-3812157825B8'
	SET @none			= '3A887A6D-69DF-4E02-B0F5-89AAEBBC2E92'
	
	-- figure out the users security zone
	-- this is now context type specific
	DECLARE @securityzone as uniqueidentifier
	
	SELECT	TOP 1 @securityzone = SZ.ID
	FROM	UserProfile UP JOIN
		SecurityRole SR ON UP.RoleID = SR.ID JOIN
		SecurityRoleZone SRZ ON SRZ.SecurityRoleID = SR.ID JOIN
		SecurityZone SZ ON SRZ.SecurityZoneID = SZ.ID
	WHERE	UP.ID = @userId
	AND	SZ.ContextTypeID = 'FD1C4A90-0AB0-4D47-9A6B-6DA442C35086' -- teacher context type

	-- no filter
	IF @securityzone = @districtzone
	BEGIN
		SET @sql = null
		return @sql
	END
	
	-- may access other teachers at my current school
	ELSE IF @securityzone = @schoolzone
	BEGIN
		SET @sql = @tableAlias + '.CurrentSchoolId IN (SELECT id FROM dbo.GetTeacherContextIdentifiers(''' + cast(@userId as varchar(50)) + ''',''' + cast(@currentDate as varchar) + '''))'
		return @sql
	END
	
	-- may access only myself
	ELSE IF @securityzone = @selfzone
	BEGIN
		SET @sql = @tableAlias + '.UserProfileID = '''+ cast(@userId as varchar(50)) +''''
		return @sql	
	END
	
	--  may not access any teacher data
	ELSE IF @securityzone = @none
	BEGIN
		SET @sql = '1 = 0' -- match nobody
		return @sql	
	END
	
	RETURN @sql
END







GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO