IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IntvGoalDef_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IntvGoalDef_GetAllRecords]
GO

/*
<summary>
Gets all records from the IntvGoalDef table
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[IntvGoalDef_GetAllRecords]
AS
	SELECT
		i.*
	FROM
		IntvGoalDef i
	WHERE 
		i.DeletedDate IS NULL 
	ORDER BY 
		i.Name