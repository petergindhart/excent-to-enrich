/****** Object:  StoredProcedure [dbo].[StudentForm_GetRecordsByRosterYear]    Script Date: 05/13/2008 09:53:35 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[StudentForm_GetRecordsByRosterYear]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[StudentForm_GetRecordsByRosterYear]
GO

/****** Object:  StoredProcedure [dbo].[StudentForm_GetRecordsByRosterYear]    Script Date: 04/22/2008 15:03:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*
<summary>
Gets records from the StudentForm table
	and inherited data from:FormInstance
with the specified ids
</summary>
<param name="ids">Ids of the RosterYear(s) to retrieve</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[StudentForm_GetRecordsByRosterYear]
	@ids	uniqueidentifierarray
AS
	SELECT
		s.RosterYearId,
		s1.*,
		s.*,
		ft.TypeId
	FROM
		StudentForm s INNER JOIN
		FormInstance s1 ON s.Id = s1.Id INNER JOIN
		FormTemplate ft ON s1.TemplateId = ft.Id JOIN
		GetUniqueidentifiers(@ids) Keys ON s.RosterYearId = Keys.Id