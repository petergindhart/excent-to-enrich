IF EXISTS (SELECT name
		FROM sysobjects
		WHERE name = N'LdapAuthenticationService_InsertRecord'
		AND type = 'P')
	DROP PROCEDURE dbo.LdapAuthenticationService_InsertRecord

GO

/*
<summary>
Inserts a new record into the LdapAuthenticationService table with the specified values
</summary>
<param name="server">Value to assign to the Server field of the record</param>
<param name="username">Value to assign to the Username field of the record</param>
<param name="password">Value to assign to the Password field of the record</param>
<param name="id">Value to assign to the ID field of the record</param>
<param name="schemaTypeId">Value to assign to the SchemaTypeID field of the record</param>
<returns>The identifiers for the inserted record</returns>
<model isGenerated="False" returnType="System.Void" />
*/
CREATE PROCEDURE dbo.LdapAuthenticationService_InsertRecord 
	@server varchar(200),
	@username varchar(200),
	@password varchar(50),
	@id uniqueidentifier,
	@schemaTypeId char(1),
	@useEncryption bit
AS
INSERT INTO LdapAuthenticationService
	(

		Server,
		Username,
		Password,
		ID,
		SchemaTypeID,
		UseEncryption
	)
	VALUES
	(

		@server,
		@username,
		@password,
		@id,
		@schemaTypeId,
		@useEncryption
	)

GO

