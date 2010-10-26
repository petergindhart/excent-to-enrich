/****** Object:  StoredProcedure [dbo].[FormInstanceInterval_GetRecords]    Script Date: 04/22/2008 15:15:16 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FormInstanceInterval_GetRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FormInstanceInterval_GetRecords]
GO

/****** Object:  StoredProcedure [dbo].[FormInstanceInterval_GetRecords]    Script Date: 04/22/2008 15:15:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*
<summary>
Gets records from the FormInstanceInterval table
with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInstanceInterval_GetRecords]
	@ids	uniqueidentifierarray
AS
	SELECT	
		f.*,
		ft.TypeId
	FROM
		FormInstanceInterval f JOIN
		FormInterval fii on f.IntervalID = fii.ID join
		FormInstance fi on f.InstanceId = fi.Id JOIN
		FormTemplate ft on fi.TemplateId = ft.Id INNER JOIN
		GetUniqueidentifiers(@ids) Keys ON f.Id = Keys.Id
	order by
		fii.Sequence asc