if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[StudentForm_GetRecordsByClassRoster]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[StudentForm_GetRecordsByClassRoster]
GO

/*
<summary>
Gets records from the StudentForm table
	and inherited data from:FormInstance
with the specified ids
</summary>
<param name="ids">Ids of the ClassRosters(s) to retrieve</param>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE [dbo].[StudentForm_GetRecordsByClassRoster]
	@ids	uniqueidentifierarray
AS
	SELECT
		s1.*,
		s.RosterYearId,
		s.StudentId,
		ft.TypeId
	FROM
		StudentClassRosterHistory hist join
		ClassRoster cr on hist.ClassRosterId = cr.Id join
		GetUniqueidentifiers(@ids) Keys ON cr.Id = Keys.Id join

		StudentForm s on
			s.RosterYearId = cr.RosterYearId and
			s.StudentId = hist.StudentId join

		FormInstance s1 ON s.Id = s1.Id join
		FormTemplate ft on s1.TemplateId = ft.Id

GO
