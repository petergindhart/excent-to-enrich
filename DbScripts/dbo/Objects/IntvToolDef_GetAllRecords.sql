IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IntvToolDef_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IntvToolDef_GetAllRecords]
GO

/*
<summary>
Gets all records from the IntvToolDef table
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[IntvToolDef_GetAllRecords]
AS
	SELECT
		i.*
	FROM
		IntvToolDef i
	WHERE 
		i.DeletedDate IS NULL 
	ORDER BY 
		i.Name