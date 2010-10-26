
-- =============================================
-- Create procedure basic template
-- =============================================
-- creating the store procedure
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'Util_CreateLdapContext' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.Util_CreateLdapContext
GO

CREATE PROCEDURE dbo.Util_CreateLdapContext (
	@ServiceID uniqueidentifier,			--from AuthenticationService
	@DefaultTeacherRole varchar(100),	
	@DefaultUnknownRole varchar(100),	
	@Name varchar(100),
	@SchoolAbbr varchar(20),				
	@UserContainer varchar(1000),
	@SearchSubContainers bit,
	@UserGroup varchar(1000)
)
AS
	declare @id uniqueidentifier
	set @id = newid()

	declare @SchoolID uniqueidentifier
	SELECT @SchoolID=Id FROM School where Abbreviation = @SchoolAbbr

	declare @DefaultUnknownRoleID uniqueidentifier
	SELECT @DefaultUnknownRoleID=Id FROM SecurityRole where Name=@DefaultUnknownRole
	
	declare @DefaultTeacherRoleID uniqueidentifier
	SELECT @DefaultTeacherRoleID=Id FROM SecurityRole where Name=@DefaultTeacherRole

	insert into AuthenticationContext values(
		@id, --ID
		@ServiceID, --ServiceID
		@DefaultTeacherRoleID, --DefaultTeacherRoleID
		@DefaultUnknownRoleID, --DefaultUnknownRoleID
		@Name, --Name
		1, --IsEnabled
		@SchoolID --SchoolID
	)

	insert into LdapAuthenticationContext values (
		@ID,
		@UserContainer,
		@SearchSubContainers,
		@UserGroup
	)

GO

-- =============================================
-- example to execute the store procedure
-- =============================================
--exec Util_CreateLdapContext '9386BA79-5B28-49C3-B350-576018CF48C0', 'Teacher', 'No Access', 'Some context', 'HOUS', 'container', 0, null

GO

