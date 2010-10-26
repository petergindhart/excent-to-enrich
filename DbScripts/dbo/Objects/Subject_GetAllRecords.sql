
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'Subject_GetAllRecords' 
	   AND 	  type = 'P')
    DROP PROCEDURE dbo.Subject_GetAllRecords
GO

/*
<summary>
Retruns all subject records
</summary>

<returns>All Subjects</returns>

<model  isGenerated="false" 
        returnType="System.Data.IDataReader" 
        />
*/
CREATE PROCEDURE dbo.Subject_GetAllRecords 
AS
	SELECT * FROM Subject order by name
GO
