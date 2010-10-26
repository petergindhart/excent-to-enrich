/****** Object:  StoredProcedure [dbo].[StudentForm_GetRecords]    Script Date: 05/13/2008 09:53:11 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[StudentForm_GetRecords]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[StudentForm_GetRecords]
GO

/****** Object:  StoredProcedure [dbo].[StudentForm_GetRecords]    Script Date: 04/22/2008 15:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*
<summary>
Gets records from the StudentForm table
	and inherited data from:FormInstance
with the specified id's
</summary>
<param name="ids">Ids of the records to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[StudentForm_GetRecords]
	@ids	uniqueidentifierarray
AS
	SELECT	
		s1.*,
		s.*,
		ft.TypeId
	FROM
		StudentForm s INNER JOIN
		FormInstance s1 ON s.Id = s1.Id INNER JOIN
		FormTemplate ft on s1.TemplateId = ft.Id JOIN
		GetUniqueidentifiers(@ids) Keys ON s.Id = Keys.Id