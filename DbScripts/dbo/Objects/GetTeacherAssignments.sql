if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GetTeacherAssignments]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[GetTeacherAssignments]
GO
/*
<summary>
Gets details on teacher course and class assignments>
<param name="Date">Status date input by user. </param>
<returns>An <see cref="IDataReader"/> containing the requested data</returns>
<model isGenerated="False" returnType="System.Data.IDataReader" />
<test GetTeacherAssignments '1-1-2007' />
*/
CREATE   function [dbo].[GetTeacherAssignments]
(@Date datetime)
Returns table 
As
Return
(
	Select
		crth.TeacherID,
		cr.ContentAreaID,
		cr.SchoolId,
		cr.Id 'ClassRosterId'
	From 
		ClassRosterTeacherHistory crth join
		ClassRoster cr on crth.ClassRosterID = cr.ID
	Where
		dbo.DateInRange(@Date, crth.StartDate, crth.EndDate) = 1
		-- this date check may appear invalid due to crth.EndDate being
		-- null, however crth.EndDate will be set at the end of the 
		-- roster year.
)
