SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FormTemplateInputItem_GetRecordsByParent]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FormTemplateInputItem_GetRecordsByParent]
GO

/*
<summary>
Gets records from the FormTemplateInputItem table
with the specified ids
</summary>
<param name="ids">Ids of the FormTemplateInputItem(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormTemplateInputItem_GetRecordsByParent]
	@ids	uniqueidentifierarray
AS
	SELECT
		f.ParentId,
		f.*
	FROM
		FormTemplateInputItem f INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON f.ParentId = Keys.Id
	ORDER BY
		f.Sequence

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

