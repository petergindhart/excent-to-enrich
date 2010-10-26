if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[School_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[School_GetAllRecords]
GO

/*
<summary>
Gets all records from the School table that excludes non local schools
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.School_GetAllRecords 
AS
	SELECT s.*
	FROM
		School s
	WHERE
		IsLocalOrg = 1
	ORDER BY Name
GO
