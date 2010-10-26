IF EXISTS (SELECT name
		FROM sysobjects
		WHERE name = N'LdapAuthenticationService_GetRecords'
		AND type = 'P')
	DROP PROCEDURE dbo.LdapAuthenticationService_GetRecords

GO

/*
<summary>
Gets records from the LdapAuthenticationService table with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.LdapAuthenticationService_GetRecords 
	@ids uniqueidentifierarray
AS
	SELECT l.*
	FROM
		LdapAuthenticationServiceView l INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON l.ID = Keys.Id

GO
