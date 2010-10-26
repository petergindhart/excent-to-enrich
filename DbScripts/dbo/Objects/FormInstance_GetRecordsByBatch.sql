SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FormInstance_GetRecordsByBatch]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FormInstance_GetRecordsByBatch]
GO

 /*
<summary>
Gets records from the FormInstance table
with the specified ids
</summary>
<param name="ids">Ids of the FormInstanceBatch(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.FormInstance_GetRecordsByBatch
	@ids	uniqueidentifierarray
AS
	SELECT
		f.FormInstanceBatchId,
		f.*,
		ft.TypeId
	FROM
		FormInstance f join
		FormTemplate ft on f.TemplateId = ft.Id INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON f.FormInstanceBatchId = Keys.Id
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

