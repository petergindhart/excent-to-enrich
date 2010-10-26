IF EXISTS (SELECT name
		FROM sysobjects
		WHERE name = N'LdapAuthenticationContext_InsertRecord'
		AND type = 'P')
	DROP PROCEDURE dbo.LdapAuthenticationContext_InsertRecord

GO

/*
<summary>
Inserts a new record into the LdapAuthenticationContext table with the specified values
</summary>
<param name="userContainer">Value to assign to the UserContainer field of the record</param>
<param name="searchSubContainers">Value to assign to the SearchSubContainers field of the record</param>
<param name="userGroup">Value to assign to the UserGroup field of the record</param>
<param name="id">Value to assign to the ID field of the record</param>
<returns>The identifiers for the inserted record</returns>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.LdapAuthenticationContext_InsertRecord 
	@userContainer varchar(1000),
	@searchSubContainers bit,
	@userGroup varchar(1000),
	@id uniqueidentifier
AS
INSERT INTO LdapAuthenticationContext
	(

		UserContainer,
		SearchSubContainers,
		UserGroup,
		ID
	)
	VALUES
	(

		@userContainer,
		@searchSubContainers,
		@userGroup,
		@id
	)

GO
