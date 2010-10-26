IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[IntvToolDef_GetRecordsForPrgToolDefSubVariantAssociation]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[IntvToolDef_GetRecordsForPrgToolDefSubVariantAssociation]
GO

/*
<summary>
Gets records from the IntvToolDef table for the specified association 
</summary>
<param name="ids">Ids of the PrgSubVariant(s) </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[IntvToolDef_GetRecordsForPrgToolDefSubVariantAssociation]
	@ids uniqueidentifierarray
AS
	SELECT 
		ab.SubVariantId, 
		a.*
	FROM
		PrgToolDefSubVariant ab INNER JOIN
		GetUniqueidentifiers(@ids) AS Keys ON ab.SubVariantId = Keys.Id INNER JOIN
		IntvToolDef a ON ab.ToolDefId = a.Id
	WHERE 
		a.DeletedDate IS NULL 