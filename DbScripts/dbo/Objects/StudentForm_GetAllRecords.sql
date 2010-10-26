/****** Object:  StoredProcedure [dbo].[StudentForm_GetAllRecords]    Script Date: 05/13/2008 09:52:51 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[StudentForm_GetAllRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[StudentForm_GetAllRecords]
GO

/****** Object:  StoredProcedure [dbo].[StudentForm_GetAllRecords]    Script Date: 04/22/2008 15:01:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*
<summary>
Gets all records from the StudentForm table
	and inherited data from:FormInstance
</summary>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[StudentForm_GetAllRecords]
AS
	SELECT
		s1.*,
		s.*,
		ft.TypeId
	FROM
		StudentForm s INNER JOIN
		FormInstance s1 ON s.Id = s1.Id JOIN
		FormTemplate ft on s1.TemplateId = ft.Id