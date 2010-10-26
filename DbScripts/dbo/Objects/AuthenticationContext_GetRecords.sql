IF EXISTS (SELECT name
		FROM sysobjects
		WHERE name = N'AuthenticationContext_GetRecords'
		AND type = 'P')
	DROP PROCEDURE dbo.AuthenticationContext_GetRecords

GO

/*
<summary>
Gets records from the AuthenticationContext table with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.AuthenticationContext_GetRecords 
	@ids uniqueidentifierarray
AS
	SELECT a.*
	FROM
		TestViewAuthenticationContextView a INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON a.ID = Keys.Id

	SELECT a.*
	FROM
		LdapAuthenticationContextView a INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON a.ID = Keys.Id
GO

