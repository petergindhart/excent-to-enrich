if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgItemForm_GetRecordsByCreatedBy]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgItemForm_GetRecordsByCreatedBy]
GO

/*
<summary>
Gets records from the PrgItemForm table
	and inherited data from:FormInstance
with the specified ids
</summary>
<param name="ids">Ids of the UserProfile(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgItemForm_GetRecordsByCreatedBy]
	@ids	uniqueidentifierarray
AS
	SELECT
		p.CreatedBy,
		p1.*,
		p.*, 
		t.TypeId
	FROM
		PrgItemForm p INNER JOIN
		FormInstance p1 ON p.ID = p1.Id INNER JOIN 
		FormTemplate t on t.ID = p1.TemplateID INNER JOIN 
		GetUniqueidentifiers(@ids) Keys ON p.CreatedBy = Keys.Id
GO