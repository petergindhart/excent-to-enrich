IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Report_InterventionSummaryBySchoolAndGrade]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Report_InterventionSummaryBySchoolAndGrade]
GO

CREATE PROCEDURE [dbo].[Report_InterventionSummaryBySchoolAndGrade](
	@programID uniqueidentifier, 
	@startDate datetime,
	@endDate datetime,
	@statusID uniqueidentifier = NULL,
	@toolDefID uniqueidentifier = NULL,
	@schoolID uniqueidentifier = NULL,
	@calculateEnrollment bit = 1
)
AS

-- Calculate totals for each school/grade level combination
declare @served table(SchoolID uniqueidentifier, GradeLevelID uniqueidentifier, Served int, Worse int, Better int)

insert @served
select
	School			= item.SchoolID,
	GradeLevel		= item.GradeLevelID,
	Served			= count(distinct cast(item.StudentID as binary(16))),
	Better			= count(distinct case when item.ItemOutcomeID is not null AND cs.Sequence < isnull(ns.Sequence, -1) then cast(item.StudentID as binary(16)) else null end),
	Worse			= count(distinct case when item.ItemOutcomeID is not null AND cs.Sequence > isnull(ns.Sequence, -1) then cast(item.StudentID as binary(16)) else null end)
from
	PrgItem item JOIN 
	PrgItemDef def ON def.Id = item.DefId JOIN 
	PrgInvolvement inv on inv.ID = item.InvolvementID JOIN 
	PrgStatus cs ON cs.ID = item.StartStatusID LEFT OUTER JOIN 
	PrgStatus ns ON ns.ID = item.EndStatusID 
where
	inv.ProgramID = @programID and 
	dbo.DateRangesOverlap( item.StartDate, item.EndDate, @startDate, @endDate, getdate()) = 1 and
	(@statusID is null OR @statusID = item.StartStatusID) and
	(@toolDefID is null OR item.ID in (select InterventionID from IntvTool where DefinitionID=@toolDefID)) and 
	(@schoolID is null OR @schoolID = item.SchoolID) AND 
	def.TypeID IN ('D7B183D8-5BBD-4471-8829-3C8D82A92478', '03670605-58B2-40B2-99D5-4A1A70156C73')
group by
	item.SchoolID,
	item.GradeLevelID


declare @enrollment table(SchoolID uniqueidentifier, GradeLevelID uniqueidentifier, AverageEnrollment float)

if @calculateEnrollment = 1
begin
	declare @daysInReport float
	set @daysInReport = datediff(d, @startDate, @endDate)

	insert @enrollment
	select
		ssh.SchoolID,
		sglh.GradeLevelID,

		-- calculate average enrollment to accommodate kids that enter and leave a group during the interval.
		-- sum(student*days) / days -> students
		AverageEnrollment = sum( 
			dbo.IntMin(
				dbo.IntMin(
					dbo.DaysDateRangesOverlap(ssh.StartDate, ssh.EndDate, sglh.StartDate, sglh.EndDate, @endDate),
					dbo.DaysDateRangesOverlap(@startDate, @endDate, sglh.StartDate, sglh.EndDate, @endDate)
				),
				dbo.DaysDateRangesOverlap(ssh.StartDate, ssh.EndDate, @startDate, @endDate, @endDate)
			)
		) / @daysInReport
	from
		StudentSchoolHistory ssh join
		StudentGradeLevelHistory sglh on ssh.StudentID = sglh.StudentID
	where
		dbo.DateRangesOverlap(ssh.StartDate, ssh.EndDate, @startDate, @endDate, @endDate) = 1 and
		dbo.DateRangesOverlap(sglh.StartDate, sglh.EndDate, @startDate, @endDate, @endDate) = 1
	group by
		ssh.SchoolID,
		sglh.GradeLevelID
end

-- Fill in missing data
select
	SchoolID = schDim.ID,
	GradeLevelID = glDim.ID,
	AverageEnrollment = sum(isnull(en.AverageEnrollment, 0)),
	Served = sum(isnull(served.Served, 0)),
	Better = sum(isnull(served.Better, 0)),
	Worse = sum(isnull(served.Worse, 0))
from
	(
		(select distinct ID=SchoolID from @served) schDim cross join
		(select distinct ID=GradeLevelID from @served) glDim
	) left join
	@enrollment en on en.SchoolID = schDim.ID and en.GradeLevelID = glDim.ID left join
	@served served on served.SchoolID = schDim.ID and served.GradeLevelID = glDim.ID
group by
	glDim.ID,
	schDim.ID
	with cube
GO

--exec Report_InterventionSummaryBySchoolAndGrade @programID='7de3b3d7-b60f-48ac-9681-78d46a5e74d4', @startDate = '8/15/2008', @endDate = '3/23/2009'
--exec Report_InterventionSummaryBySchoolAndGrade @programID='7de3b3d7-b60f-48ac-9681-78d46a5e74d4', @startDate = '1/1/2005', @endDate = '3/23/2009', @calculateEnrollment=0

