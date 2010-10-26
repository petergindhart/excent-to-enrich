
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'LdapSchemaType_GetAllRecords' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.LdapSchemaType_GetAllRecords
GO

/*
<summary>
Gets all LdapSchemaType records, ordered by name
</summary>

<returns></returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.LdapSchemaType_GetAllRecords 
AS
	SELECT *
	FROM LdapSchemaType
	ORDER BY Name
GO
