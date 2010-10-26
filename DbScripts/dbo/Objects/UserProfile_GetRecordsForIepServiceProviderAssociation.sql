/****** Object:  StoredProcedure [dbo].[UserProfile_GetRecordsForIepServiceProviderAssociation]    Script Date: 02/17/2010 08:23:14 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[UserProfile_GetRecordsForIepServiceProviderAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[UserProfile_GetRecordsForIepServiceProviderAssociation]
GO

 /*
<summary>
Gets records from the UserProfile table for the specified association 
</summary>
<param name="ids">Ids of the IepService(s) </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[UserProfile_GetRecordsForIepServiceProviderAssociation]
	@ids uniqueidentifierarray
AS
	SELECT ab.ServiceId, a.*
	FROM
		IepServiceProvider ab INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON ab.ServiceId = Keys.Id INNER JOIN
		UserProfileView a ON ab.UserProfileId = a.Id
GO


