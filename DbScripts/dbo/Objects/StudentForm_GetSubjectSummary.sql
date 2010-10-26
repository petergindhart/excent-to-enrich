SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[StudentForm_GetSubjectSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[StudentForm_GetSubjectSummary]
GO


 /*
<summary>
Gets a summary of SBRC status by batch, school, and template
</summary>
<model isGenerated="False" returnType="System.Data.IDataReader" />
*/
CREATE PROCEDURE dbo.StudentForm_GetSubjectSummary
	@batchID			uniqueidentifier, 		
	@schoolID			uniqueidentifier,
	@formTemplateId		uniqueidentifier
AS

declare @results table(
	StudentId uniqueidentifier,
	FormInstanceId uniqueidentifier,
	StatusAll bit,	
	StatusEla bit,
	StatusMat bit,
	StatusSci bit,
	StatusSoc bit,
	TeacherAll varchar(255),
	TeacherEla varchar(255),
	TeacherMat varchar(255),
	TeacherSci varchar(255),
	TeacherSoc varchar(255),
	FormInstanceIntervalId uniqueidentifier
)

-- record form status, default all subs to 1
insert @results
select
	sf.StudentId,
	f.Id [FormInstanceId],
	cast(case when fii.CompletedDate is not null then 1 else 0 end as bit) [StatusAll],
	1 [StatusEla],
	1 [StatusMat],
	1 [StatusSci],
	1 [StatusSoc],
	dbo.StudentForm_GetSubjectTeacherList(sf.StudentId, sb.RosterYearId, null) [TeacherAll],
	null [TeacherEla],
	null [TeacherMat],
	null [TeacherSci],
	null [TeacherSoc],
	fii.Id [FormInstanceIntervalId]
from
	FormInstanceBatch b join
	StudentFormInstanceBatch sb on sb.Id = b.Id join
	FormInstance f on f.FormInstanceBatchId = b.Id join
	StudentForm sf on sf.Id = f.Id join
	Student s on sf.StudentId = s.Id left join
	FormInstanceInterval fii on fii.InstanceId = f.Id and fii.IntervalId = b.CurrentIntervalId
where
	b.Id = @batchId and
	f.TemplateId = @formTemplateId and
	s.CurrentSchoolId = @schoolID

-- if any subjects exist for this template
if exists 
	(	select *
		from 
			FormTemplateLayout ftl join
			FormTemplateControl con on ftl.ControlId = con.Id join
			SubjectFormInputArea sfia on sfia.Id = con.Id
		where
			ftl.TemplateId = @formTemplateId
	)
	begin

		declare
			@rosterYearId uniqueidentifier,
			@elaId uniqueidentifier,
			@matId uniqueidentifier,
			@sciId uniqueidentifier,
			@socId uniqueidentifier


		select
			@rosterYearId = RosterYearId,
			@elaId = 'DF2274C7-1714-44C1-A8FC-61F29D5504AC',
			@matId = '7BC1F354-2787-4C88-83F1-888D93F0E71E',
			@sciId = '0351CAC6-40EE-479C-A506-DC84E77C6665',
			@socId = 'C90E81B1-30CB-4D2D-B301-F4AB6A1F5E75'
		from
			StudentFormInstanceBatch
		where
			Id = @batchId

		-- update Ela status
		update r
		set StatusEla = cast(case when s.CompletedDate is not null then 1 else 0 end as bit)
		from
			@results r join
			SubjectFormInputStatus s on s.IntervalId = r.FormInstanceIntervalId and
			s.SubjectId = @elaId
		
		-- update Mat status
		update r
		set StatusMat = cast(case when s.CompletedDate is not null then 1 else 0 end as bit)
		from
			@results r join
			SubjectFormInputStatus s on s.IntervalId = r.FormInstanceIntervalId and
			s.SubjectId = @matId
		
		-- update Sci status
		update r
		set StatusSci = cast(case when s.CompletedDate is not null then 1 else 0 end as bit)
		from
			@results r join
			SubjectFormInputStatus s on s.IntervalId = r.FormInstanceIntervalId and
			s.SubjectId = @sciId
		
		-- update Soc status
		update r
		set StatusSoc = cast(case when s.CompletedDate is not null then 1 else 0 end as bit)
		from
			@results r join
			SubjectFormInputStatus s on s.IntervalId = r.FormInstanceIntervalId and
			s.SubjectId = @socId

		-- aggregate subject status
		update @results set StatusAll = StatusEla & StatusMat & StatusSci & StatusSoc

		-- update teachers
		update r
		set r.TeacherEla = dbo.StudentForm_GetSubjectTeacherList(r.StudentId, @rosterYearId, @elaId)
		from @results r
		
		update r
		set r.TeacherMat = dbo.StudentForm_GetSubjectTeacherList(r.StudentId, @rosterYearId, @matId)
		from @results r
		
		update r
		set r.TeacherSci = dbo.StudentForm_GetSubjectTeacherList(r.StudentId, @rosterYearId, @sciId)
		from @results r
		
		update r
		set r.TeacherSoc = dbo.StudentForm_GetSubjectTeacherList(r.StudentId, @rosterYearId, @socId)
		from @results r
	end

select * from @results

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO