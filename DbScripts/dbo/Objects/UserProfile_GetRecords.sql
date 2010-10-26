IF EXISTS (SELECT name
		FROM sysobjects
		WHERE name = N'UserProfile_GetRecords'
		AND type = 'P')
	DROP PROCEDURE dbo.UserProfile_GetRecords

GO

/*
<summary>
Gets records from the UserProfile table with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="false" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.UserProfile_GetRecords 
	@ids uniqueidentifierarray
AS
	SELECT u.*
	FROM
		UserProfileView u INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON u.ID = Keys.Id
GO

