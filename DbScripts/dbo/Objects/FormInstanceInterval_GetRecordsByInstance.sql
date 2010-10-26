/****** Object:  StoredProcedure [dbo].[FormInstanceInterval_GetRecordsByInstance]    Script Date: 04/22/2008 15:16:42 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FormInstanceInterval_GetRecordsByInstance]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FormInstanceInterval_GetRecordsByInstance]
GO

/****** Object:  StoredProcedure [dbo].[FormInstanceInterval_GetRecordsByInstance]    Script Date: 04/22/2008 15:16:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*
<summary>
Gets records from the FormInstanceInterval table
with the specified ids
</summary>
<param name="ids">Ids of the FormInstance(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInstanceInterval_GetRecordsByInstance]
	@ids	uniqueidentifierarray
AS
	SELECT
		f.InstanceId,
		f.*,
		ft.TypeId
	FROM
		FormInstanceInterval f JOIN
		FormInterval fii on f.IntervalID = fii.ID join
		FormInstance fi on f.InstanceId = fi.Id JOIN
		FormTemplate ft on fi.TemplateId = ft.Id INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON f.InstanceId = Keys.Id
	order by
		fii.Sequence asc