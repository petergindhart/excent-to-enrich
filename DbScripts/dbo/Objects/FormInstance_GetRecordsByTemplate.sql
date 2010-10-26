/****** Object:  StoredProcedure [dbo].[FormInstance_GetRecordsByTemplate]    Script Date: 05/13/2008 09:52:10 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInstance_GetRecordsByTemplate]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormInstance_GetRecordsByTemplate]
GO

/****** Object:  StoredProcedure [dbo].[FormInstance_GetRecordsByTemplate]    Script Date: 04/22/2008 14:59:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*
<summary>
Gets records from the FormInstance table
with the specified ids
</summary>
<param name="ids">Ids of the FormTemplate(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInstance_GetRecordsByTemplate]
	@ids	uniqueidentifierarray
AS
	SELECT
		f.TemplateId,
		f.*,
		ft.TypeId
	FROM
		FormInstance f INNER JOIN
		FormTemplate ft on f.TemplateId = ft.Id JOIN
		GetUniqueidentifiers(@ids) Keys ON f.TemplateId = Keys.Id