/****** Object:  StoredProcedure [dbo].[FormInstanceInterval_GetRecordsByInterval]    Script Date: 04/22/2008 15:17:44 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FormInstanceInterval_GetRecordsByInterval]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FormInstanceInterval_GetRecordsByInterval]
GO


/****** Object:  StoredProcedure [dbo].[FormInstanceInterval_GetRecordsByInterval]    Script Date: 04/22/2008 15:17:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*
<summary>
Gets records from the FormInstanceInterval table
with the specified ids
</summary>
<param name="ids">Ids of the FormInterval(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInstanceInterval_GetRecordsByInterval]
	@ids	uniqueidentifierarray
AS
	SELECT
		f.IntervalId,
		f.*,
		ft.TypeId
	FROM
		FormInstanceInterval f JOIN
		FormInterval fii on f.IntervalID = fii.ID join
		FormInstance fi on f.InstanceId = fi.Id JOIN
		FormTemplate ft on fi.TemplateId = ft.Id INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON f.IntervalId = Keys.Id
	order by
		fii.Sequence asc