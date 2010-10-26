SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AuthenticationContext_GetRecordsByDefaultRoleId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AuthenticationContext_GetRecordsByDefaultRoleId]
GO


/*
<summary>
Gets records from the AuthenticationContext table for the specified ids 
</summary>
<param name="ids">Ids of the SecurityRole's </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE  PROCEDURE dbo.AuthenticationContext_GetRecordsByDefaultRoleId 
	@ids uniqueidentifierarray
AS
	SELECT a.DefaultTeacherRoleID, a.*
	FROM
		TestViewAuthenticationContextView a WHERE  a.DefaultTeacherRoleID IN
		(SELECT ID FROM GetUniqueidentifiers(@ids) ) 
	UNION
	SELECT a.DefaultUnknownRoleID, a.*
	FROM
		TestViewAuthenticationContextView a WHERE  a.DefaultUnknownRoleID IN
		(SELECT ID FROM GetUniqueidentifiers(@ids) ) 

		
	SELECT  a.DefaultTeacherRoleID, a.*
	FROM
		LdapAuthenticationContextView a WHERE a.DefaultTeacherRoleID IN
		(SELECT ID FROM GetUniqueidentifiers(@ids) )
	UNION
		SELECT a.DefaultUnknownRoleID, a.*
		FROM
		LdapAuthenticationContextView a WHERE a.DefaultUnknownRoleID IN
		(SELECT ID FROM GetUniqueidentifiers(@ids) )
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

