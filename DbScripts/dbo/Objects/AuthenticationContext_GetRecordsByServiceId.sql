SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AuthenticationContext_GetRecordsByServiceId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AuthenticationContext_GetRecordsByServiceId]
GO

/*
<summary>
Gets records from the AuthenticationContext table for the specified ids 
</summary>
<param name="ids">Ids of the AuthenticationService's </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.AuthenticationContext_GetRecordsByServiceId 
	@ids uniqueidentifierarray
AS
	SELECT a.ServiceID, a.*
	FROM
		TestViewAuthenticationContextView a INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON a.ServiceID = Keys.Id

	SELECT a.ServiceID, a.*
	FROM
		LdapAuthenticationContextView a INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON a.ServiceID = Keys.Id
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

