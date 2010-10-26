if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetSecurityZoneFilter]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetSecurityZoneFilter]
GO

/*
<summary>
Returns the sql used to filter based on a 
Security Zone
</summary>
*/
CREATE FUNCTION dbo.GetSecurityZoneFilter(@tableAlias VARCHAR(64), @userId UNIQUEIDENTIFIER, @currentDate DATETIME)
	RETURNS varchar(8000)
AS
BEGIN

	DECLARE @districtzone UNIQUEIDENTIFIER
	DECLARE @schoolzone UNIQUEIDENTIFIER
	DECLARE @studentszone UNIQUEIDENTIFIER
	DECLARE @recentstudentszone UNIQUEIDENTIFIER
	DECLARE @recentschoolszone UNIQUEIDENTIFIER

	SET @districtzone = 'CAC5D55A-794F-4FBE-9D91-8B9E2CE13DD2'
	SET @schoolzone = '8ED30018-EFEC-4D22-9E46-8C72EB22AF5A'
	SET @studentszone = 'B46252C8-FE46-423A-ACB7-13A1753C04CE'
	SET @recentstudentszone = 'ED8587DF-06A3-48A2-BEB6-BC84D42BB77C'
	SET @recentschoolszone = '308E1B1B-DB6C-47EF-B4BD-690D1645ABDE'

	DECLARE @sql varchar(8000)

	-- figure out the users security zone
	-- this is now context type specific
	DECLARE @securityzone as UNIQUEIDENTIFIER
	
	SELECT
		TOP 1 @securityzone = sz.ID
	FROM
		UserProfile u JOIN
		SecurityRole sr ON u.RoleID = sr.ID JOIN
		SecurityRoleZone srz ON srz.SecurityRoleID = sr.ID JOIN
		SecurityZone sz ON srz.SecurityZoneID = sz.ID
	WHERE	
		u.ID = @userId AND 
		sz.ContextTypeID = 'F069CEA9-B0F4-44E2-AD7D-EE03E3F7C0D4' -- student context type

	-- district zone
	IF @securityzone = @districtzone
	BEGIN
		SET @sql = null
		return @sql
	END

	-- school and student zones
	ELSE IF @securityzone = @schoolzone OR
		@securityzone = @recentschoolszone OR 
		@securityzone = @studentszone OR
		@securityZone = @recentstudentszone
	BEGIN
		DECLARE @udf VARCHAR(50)
		SET @udf = CASE WHEN @securityzone = @schoolzone THEN 'CurrentSchoolZoneStudents'
						WHEN @securityzone = @recentschoolszone THEN 'RecentSchoolZoneStudents'
						WHEN @securityzone = @studentszone THEN 'CurrentStudentsZoneStudents'
						WHEN @securityZone = @recentstudentszone THEN 'RecentStudentsZoneStudents' 
					END
		
		SET @sql = @tableAlias + '.Id IN (SELECT StudentID FROM dbo.' + @udf + '(''' + cast(@userId as varchar(50)) + ''',''' + cast(@currentDate as varchar) + '''))'
		return @sql
	END

	RETURN @sql
END

/*
select dbo.GetSecurityZoneFilter('s', 'EEE133BD-C557-47E1-AB67-EE413DD3D1AB', '1/1/2005')
*/
