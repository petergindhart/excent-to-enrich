if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrgItemForm_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[PrgItemForm_GetAllRecords]
GO

/*
<summary>
Gets all records from the PrgItemForm table
	and inherited data from:FormInstance
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[PrgItemForm_GetAllRecords]
AS
	SELECT
		p1.*,
		p.*, 
		t.TypeId
	FROM
		PrgItemForm p INNER JOIN 
		FormInstance p1 ON p.ID = p1.Id INNER JOIN 
		FormTemplate t on t.ID = p1.TemplateID
		
GO