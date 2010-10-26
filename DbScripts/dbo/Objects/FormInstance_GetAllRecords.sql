/****** Object:  StoredProcedure [dbo].[FormInstance_GetAllRecords]    Script Date: 05/13/2008 09:51:35 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FormInstance_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FormInstance_GetAllRecords]
GO

/****** Object:  StoredProcedure [dbo].[FormInstance_GetAllRecords]    Script Date: 04/22/2008 14:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*
<summary>
Gets all records from the FormInstance table
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[FormInstance_GetAllRecords]
AS
	SELECT
		f.*,
		ft.TypeId
	FROM
		FormInstance f join
		FormTemplate ft on f.TemplateId = ft.Id