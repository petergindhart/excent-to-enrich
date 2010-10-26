
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UserProfile_GetRecordsByPrgResponsibility]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].UserProfile_GetRecordsByPrgResponsibility
GO



/*
<summary>
Gets records from the UserProfile table
with the specified ids
</summary>
<param name="ids">Ids of the PrgResponsibility(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.UserProfile_GetRecordsByPrgResponsibility
	@ids	uniqueidentifierarray
AS
	SELECT
		u.PrgResponsibilityId,
		u.*
	FROM
		UserProfileView u INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON u.PrgResponsibilityId = Keys.Id