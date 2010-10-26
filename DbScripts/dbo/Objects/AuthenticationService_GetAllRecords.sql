
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'AuthenticationService_GetAllRecords' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.AuthenticationService_GetAllRecords
GO

/*
<summary>
Gets all AuthenticationService records
</summary>

<returns>All AuthenticationService</returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.AuthenticationService_GetAllRecords 
AS
	SELECT *
	FROM LdapAuthenticationServiceView
	ORDER BY Server

	SELECT *
	FROM TestViewAuthenticationServiceView
GO
