SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FormTemplateLayout_GetRecordsByTemplate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FormTemplateLayout_GetRecordsByTemplate]
GO

/*
<summary>
Gets records from the FormTemplateLayout table
with the specified ids
</summary>
<param name="ids">Ids of the FormTemplate(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormTemplateLayout_GetRecordsByTemplate]
	@ids	uniqueidentifierarray
AS
	SELECT
		f.TemplateId,
		f.*
	FROM
		FormTemplateLayout f INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON f.TemplateId = Keys.Id
	ORDER BY
		f.Sequence

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

