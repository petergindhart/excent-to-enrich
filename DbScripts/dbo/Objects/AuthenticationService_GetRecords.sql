IF EXISTS (SELECT name
		FROM sysobjects
		WHERE name = N'AuthenticationService_GetRecords'
		AND type = 'P')
	DROP PROCEDURE dbo.AuthenticationService_GetRecords

GO

/*
<summary>
Gets records from the AuthenticationService table with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.AuthenticationService_GetRecords 
	@ids uniqueidentifierarray
AS

	SELECT *
	FROM LdapAuthenticationServiceView a join
		GetUniqueidentifiers(@ids) AS Keys on Keys.ID = a.Id

	SELECT *
	FROM
		TestViewAuthenticationServiceView a join
		GetUniqueidentifiers(@ids) AS Keys on Keys.ID = a.Id
GO

