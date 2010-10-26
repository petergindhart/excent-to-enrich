/****** Object:  StoredProcedure [dbo].[FormInstance_GetRecords]    Script Date: 05/13/2008 09:51:52 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInstance_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormInstance_GetRecords]
GO

/****** Object:  StoredProcedure [dbo].[FormInstance_GetRecords]    Script Date: 04/22/2008 14:57:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*
<summary>
Gets records from the FormInstance table
with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInstance_GetRecords]
	@ids	uniqueidentifierarray
AS
	SELECT	
		f.*,
		ft.TypeId	
	FROM
		FormInstance f INNER JOIN 
		FormTemplate ft on f.TemplateId = ft.Id join
		GetUniqueidentifiers(@ids) Keys ON f.Id = Keys.Id