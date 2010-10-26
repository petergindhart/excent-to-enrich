if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AcademicPlan_GetRecordsBySchoolRosterYear]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AcademicPlan_GetRecordsBySchoolRosterYear]
GO

 /*
<summary>
Gets records from the AcademicPlan table by School and RosterYear
</summary>
<param name="schoolId">id of the specified school</param>
<param name="rosterYearId">id of the specified roster year</param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.AcademicPlan_GetRecordsBySchoolRosterYear
	@schoolId uniqueidentifier,
	@rosterYearId uniqueidentifier
AS
	select
		a.*
	from
		AcademicPlan a
	where
		a.SchoolId = @schoolId and
		a.RosterYearId = @rosterYearId
GO
