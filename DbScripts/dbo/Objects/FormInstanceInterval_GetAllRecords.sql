/****** Object:  StoredProcedure [dbo].[FormInstanceInterval_GetAllRecords]    Script Date: 04/22/2008 15:14:05 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FormInstanceInterval_GetAllRecords]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[FormInstanceInterval_GetAllRecords]
GO

/****** Object:  StoredProcedure [dbo].[FormInstanceInterval_GetAllRecords]    Script Date: 04/22/2008 15:13:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*
<summary>
Gets all records from the FormInstanceInterval table
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInstanceInterval_GetAllRecords]
AS
	SELECT
		f.*,
		ft.TypeId
	FROM
		FormInstanceInterval f JOIN
		FormInterval fii on f.IntervalID = fii.ID join
		FormInstance fi on f.InstanceId = fi.Id JOIN
		FormTemplate ft on fi.TemplateId = ft.Id
	order by
		fii.Sequence asc