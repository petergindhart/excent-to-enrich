
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].UserProfile_GetRecordsBySchool') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].UserProfile_GetRecordsBySchool
GO

 /*
<summary>
Gets records from the UserProfile table with the specified ids
</summary>
<param name="ids">Ids of the School(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.UserProfile_GetRecordsBySchool
	@ids	uniqueidentifierarray
AS
	SELECT u.SchoolId, u.*
	FROM
		UserProfileView u INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON u.SchoolId = Keys.Id