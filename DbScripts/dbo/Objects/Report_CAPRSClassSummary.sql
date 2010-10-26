IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[Report_CAPRSClassSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Report_CAPRSClassSummary]
GO

-- exec Report_CAPRSClassSummary 'ce73ac87-39ff-4a30-9be7-849863ac877b'

create Procedure [dbo].[Report_CAPRSClassSummary]
	@group uniqueidentifier = null
AS

if @group is null
	set @group = 'D616D7B5-5438-484F-9502-E44ED9150828'
	
declare @bmScoreDefs varchar(8000)
declare @pmScoreDefs varchar(8000)
declare @bmScoreIndex int
declare @pmScoreIndex int
declare @bmScoreIndexID uniqueidentifier
declare @subject varchar(20)
declare @subjectID uniqueidentifier

declare @bm varchar(50)					-- the table name of the benchmark test
declare @bmName varchar(50)				-- the formal name of the table corresponding to the test
declare @bmID uniqueidentifier			-- the GUID for the testDefinition
declare @bmSection varchar(50)
declare @bm1 uniqueidentifier		-- The GUID for the most recent TestAdministration
declare @bm2 uniqueidentifier		-- The GUID for the 2nd most recent TestAdministration
declare @bmAdminName1 varchar(50)		-- The Year for the most recent TestAdministration
declare @bmAdminName2 varchar(50)		-- The Year for the 2nd most recent TestAdministration
declare @bmDate datetime					-- Datetime for the most recent TestAdmin 

declare @bmAdminType1 uniqueidentifier
declare @bmAdminType2 uniqueidentifier
declare @bmAdminTypeName1 varchar(40)


declare @pm varchar(50)				-- the table name of the table corresponding to the test
declare @pmName varchar(50)			-- the formal name of the table corresponding to the test
declare @pmID uniqueidentifier			-- the GUID for the testDefinition
declare @pmSection varchar(50)
declare @pm1 uniqueidentifier	-- The GUID for the most recent TestAdministration
declare @pm2 uniqueidentifier	-- The GUID for the 2nd most recent TestAdministration
declare @pmAdminName1 varchar(40)		-- The Year for the most recent TestAdministration
declare @pmAdminName2 varchar(40)		-- The Year for the 2nd most recent TestAdministration
declare @pmScore varchar(50)			-- The Primary Score that is used to generate the school and district summaries

declare @historicalMode bit					-- Is the classRoster Roster Year the current Roster Year
declare @courseCode varchar(10)
declare @sql varchar(8000)
declare @rosterYear uniqueidentifier		-- ry of the class
declare @startYear int
declare @testGoalID uniqueidentifier		-- Test goal ID-- TODO: Unhard code it. place in CaprParams
set @testGoalID = '8BDCDDED-42DB-4477-A310-86B9B6B15902'

declare @pm1Required bit
SET @pm1Required = 1

-- Determine subject area
select 
	@subject		= sub.Name,
	@subjectID		= sub.ID,
	@rosterYear		= cr.RosterYearID,
	@startYear		= ry.StartYear
from 
	ClassRoster cr join
	ContentArea ca on cr.ContentAreaID = ca.ID join
	Subject sub on ca.SubjectID = sub.ID join
	ROsterYear ry on ry.ID = cr.RosterYearID 
where 
	cr.id= @group

-- Determine which test scores to show
select 
	@pmScoreDefs = cast(cp.PrimaryScoreDef1 as varchar(36)) + isnull('|' + cast(cp.PrimaryScoreDef2 as varchar(36)), '') + isnull('|' + cast(cp.PrimaryScoreDef3 as varchar(36)), ''),
	@bmScoreDefs = cast(cp.bmarkScoreDef1 as varchar(36)) + isnull('|' + cast(cp.bmarkScoreDef2 as varchar(36)), '') + isnull('|' + cast(cp.bmarkScoreDef3 as varchar(36)), ''),
	@bmScoreIndex = cp.bmarkScoreIndex,
	@pmScoreIndex = cp.PrimaryScoreIndex,
	@bmScoreIndexID =	case when cp.BmarkScoreIndex = '3' then cp.BmarkScoreDef3
								when cp.BmarkScoreIndex = '2' then cp.BmarkScoreDef2
								else cp.BmarkScoreDef1
								end,
	@pm1Required = case when ValidGradeRangeBitMask & dbo.GetClassRosterGradeBitMask(@group) <> 0 then 1 else 0 end
from
	CaprParameters cp
where
	SubjectID = @subjectID AND
	@startYear between cp.StartYear and cp.EndYear

-- Determine the primary and benchmark tests
declare @parent uniqueidentifier

select
	@bm = td.TableName,
	@bmName = td.Name,
	@bmID = td.ID,
	@parent = tsect.Parent,
	@bmSection = tsect.Name
from 
	TestScoreDefinition tsd join
	TestSectionDefinition tsect on tsd.TestSectionDefinitionID = tsect.ID join
	TestDefinition td on tsect.TestDefinitionID = td.ID
where 
	tsd.id = (select top 1 * from GetUniqueIdentifiers(@bmScoreDefs))

-- Find root section
while @parent is not null
	select
		@parent = Parent,
		@bmSection = Name
	from
		TestSectionDefinition
	where
		ID = @parent


select
	@pm = td.TableName,
	@pmName = td.Name,
	@pmID = td.ID,
	@parent = tsect.Parent,
	@pmSection = tsect.Name
from 
	TestScoreDefinition tsd join
	TestSectionDefinition tsect on tsd.TestSectionDefinitionID = tsect.ID join
	TestDefinition td on tsect.TestDefinitionID = td.ID
where 
	tsd.id = (select top 1 * from GetUniqueIdentifiers(@pmScoreDefs))


-- Find root section
while @parent is not null
	select
		@parent = Parent,
		@pmSection = Name
	from
		TestSectionDefinition
	where
		ID = @parent


-- Primary admin 1 - must be in class's roster year
select top 1
	@pm1 = ta.ID,
	@pmAdminName1 = ta.Name
from
	RosterYear ry join
	TestAdministration ta on dbo.DateInRange(ta.StartDate, ry.StartDate, ry.EndDate) = 1
where
	TestDefinitionID = @pmID  AND 
	ry.id = @rosterYear AND
	@pm1Required = 1
order by
	ta.StartDate DESC

-- Primary admin 2 - admin given before pm1
select top 1
	@pm2 = ta.ID,
	@pmAdminName2 = ta.Name
from
	RosterYear ry join
	TestAdministration ta on ta.StartDate < ry.EndDate
where
	TestDefinitionID = @pmID  AND 
	ry.id = @rosterYear AND
	(@pm1 is null OR ta.id <> @pm1)
order by
	ta.StartDate DESC


set	@historicalMode = case when @pm1 is not null then 1 else 0 end


-- Need to get two most recent benchmark administrations but only
-- consider those that have projections and that are in the class' roster year
select top 1
	@bm1 = ta1.ID,
	@bmAdminName1 = ta1.Name,
	@bmDate = ta1.StartDate,
	@bmAdminType1 = tat1.ID,
	@bmAdminTypeName1 = tat1.Name,
	@bm2 = ta2.ID,
	@bmAdminName2 = ta2.Name,
	@bmAdminType2 = tat2.ID
from 
	TestAdministrationType tat1 join
	TestAdministrationType tat2 on
			tat2.Sequence < tat1.Sequence and
			tat1.TestDefinitionID = tat2.TestDefinitionID join
	TestScoreGoalValue tsgv on
			tsgv.TestAdministrationTypeID2 = tat1.ID AND
			tsgv.TestAdministrationTypeID1 = tat2.ID join
	TestScoreGoal tsg on
			tsgv.TestScoreGoalID = tsg.ID join
	RosterYear ry on
			dbo.DateInRange(ry.EndDate, tsg.StartDate, tsg.EndDate) = 1 left join
	TestAdministration ta1 on
			ta1.TypeID = tat1.ID and
			dbo.DateInRange(ta1.StartDate, ry.StartDate, ry.EndDate) = 1 left join
	TestAdministration ta2 on
			ta2.TypeID = tat2.ID AND
			dbo.DateInRange(ta2.StartDate, ry.StartDate, ry.EndDate) = 1
where
	ry.ID = @rosterYear AND
	tat1.TestDefinitionID = @bmID AND
	tsg.TestGoalID = @testGoalID


order by
	tat2.Sequence ASC, tat1.Sequence DESC



 
-- Return the student-level data

set @sql = '
select 
	details.*,' + 
	case when @historicalMode = 1
		then	'PrimaryLevelChange_Name	= details.Primary1Score' + cast(@pmScoreIndex as varchar(10)) + '_Name,
				PrimaryLevelChange_Value =
				case when IsNumeric(details.Primary1Score' + cast(@pmScoreIndex as varchar(10)) + '_Value) = 1 then
					cast(details.Primary1Score' + cast(@pmScoreIndex as varchar(10)) + '_Value as int)
					- cast(details.Primary2Score' + cast(@pmScoreIndex as varchar(10)) + '_Value as int) 
				else null
				end,'
		else	''
		end + '

	BenchmarkTargetGrowth = 
		' + case when @bm2 is null
		then 'null' 
		else
			'(select 
				tsgv.Value
			from
				TestScoreGoalValue tsgv join
				TestScoreGoal tsg on tsgv.TestScoreGoalID = tsg.ID join
				TestGoal tg on tsgv.TestGoalID = tg.ID
			where
				BenchmarkDateTaken2 is not null AND
				tsgv.GradeLevelID = details.BenchmarkGradeLevel2 AND
				tsgv.InputScore = details.benchmark2Score' + cast(@bmScoreIndex as varchar(10)) + '_Value AND
				tsg.TestScoreDefinitionID=''' + cast(@bmScoreIndexID as varchar(36)) + ''' AND
				tsgv.TestAdministrationTypeID1=''' + cast(@bmAdminType2 as varchar(36)) + ''' AND
				tsgv.TestAdministrationTypeID2=''' + cast(@bmAdminType1 as varchar(36)) + ''' AND
				dbo.DateInRange(BenchmarkDateTaken2, tsg.StartDate, tsg.EndDate) = 1
			)
			- cast(details.benchmark2Score' + cast(@bmScoreIndex as varchar(10)) + '_Value as int)'
		end + ',

	BenchmarkTargetGrowthAdmin = ' + isnull('''' + @bmAdminTypeName1 + '''', 'null') +',

	BenchmarkGrowthIndex =		
		' + case when @bm1 is null OR @bm2 is null
		then 'null' 
		else
				'cast(details.benchmark1Score' + cast(@bmScoreIndex as varchar(10)) + '_Value as int)
			- (select 
				tsgv.Value
			from
				TestScoreGoalValue tsgv join
				TestScoreGoal tsg on tsgv.TestScoreGoalID = tsg.ID join
				TestGoal tg on tsgv.TestGoalID = tg.ID
			where	
				BenchmarkDateTaken2 is not null AND
				tsgv.GradeLevelID = details.BenchmarkGradeLevel2 AND
				tsgv.InputScore=details.benchmark2Score' + cast(@bmScoreIndex as varchar(10)) + '_Value AND
				tsg.TestScoreDefinitionID=''' + cast(@bmScoreIndexID as varchar(36)) + ''' AND
				tsgv.TestAdministrationTypeID1=''' + cast(@bmAdminType2 as varchar(36)) + ''' AND
				tsgv.TestAdministrationTypeID2=''' + cast(@bmAdminType1 as varchar(36)) + ''' AND
				dbo.DateInRange(BenchmarkDateTaken2, tsg.StartDate, tsg.EndDate) = 1
			)'
		end +
'
from
	(select distinct
		stu.ID,
		stu.FirstName,
		stu.LastName,
		stu.Number,
		Subject					= ''' + @subject + ''',
		PrimaryTest				= ''' + @pmName + ''',
		PrimaryScoreSection		= ''' + @pmSection + ''',

		PrimaryAdmin2			= ' + isnull('''' + @pmAdminName2 + '''', 'null') + ',		
		Primary2ID				= ' + case when @pm2 is null then 'null' else 'pm2.ID' end + ',
		' + dbo.CAPRS_GetScoreSQL(@pmID, @pmScoreDefs, 'pm2', 'Primary2Score', @pm2) + ',

		PrimaryAdmin1			= ' + isnull('''' + @pmAdminName1 + '''', 'null') + ',
		Primary1ID				= ' + case when @pm1 is null then 'null' else 'pm1.ID' end + ',
		' + dbo.CAPRS_GetScoreSQL(@pmID, @pmScoreDefs, 'pm1', 'Primary1Score', @pm1) + ',	
		
		Score =	rcs.percentagescore,

		BenchmarkTest			= ''' + @bmName + ''',
		BenchmarkScoreSection	= ''' + @bmSection + ''', 
		BenchmarkAdmin2			= ' + isnull('''' + @bmAdminName2 + '''', 'null') + ',
		Benchmark2ID			= ' + case when @bm2 is null then 'null' else 'bm2.ID' end + ',
		BenchmarkGradeLevel2	= ' + case when @bm2 is null then 'null' else 'bm2.GradeLevelID' end + ',
		BenchmarkDateTaken2		= ' + case when @bm2 is null then 'null' else 'bm2.DateTaken' end + ',

		' + dbo.CAPRS_GetScoreSQL(@bmID, @bmScoreDefs, 'bm2', 'Benchmark2Score', @bm2) + ',
		BenchmarkAdmin1			= ' + isnull('''' + @bmAdminName1 + '''', 'null') + ',
						
		Benchmark1ID			= ' + case when @bm1 is null then 'null' else 'bm1.ID' end + ',
		' + dbo.CAPRS_GetScoreSQL(@bmID, @bmScoreDefs, 'bm1', 'Benchmark1Score', @bm1) + ',

		HistoricalNote			= ' + case when @historicalMode = 1
									then 'convert(varchar, pm1.DateTaken,101)'
									else 'null'
									end + '
	from
		Student stu join
		StudentClassRosterHistory scrh on stu.ID = scrh.StudentId join
		ClassRoster cr on scrh.ClassRosterID = cr.ID ' +
		
		case when @historicalMode = 1
			then 'join '
			else 'left join '
		end + '
		' + isnull(@pm + ' pm1 on stu.ID = pm1.StudentID and pm1.AdministrationID= ''' + cast(@pm1 as varchar(36)) + ''' left join', '') + '
		' + isnull(@pm + ' pm2 on stu.ID = pm2.StudentID and pm2.AdministrationID= ''' + cast(@pm2 as varchar(36)) + ''' left join', '') + '
		' + isnull(@bm + ' bm1 on stu.ID = bm1.StudentID and bm1.AdministrationID= ''' + cast(@bm1 as varchar(36)) + ''' left join', '') + '
		' + isnull(@bm + ' bm2 on stu.ID = bm2.StudentID and bm2.AdministrationID= ''' + cast(@bm2 as varchar(36)) + ''' left join', '') + '
		(ReportCardScore rcs join
		ReportCardItem rci on rcs.ReportCardItem = rci.ID AND rci.IsFinal = 1 AND rcs.PercentageScore is not null)
			on rcs.ClassRoster = cr.ID AND rcs.Student = stu.ID
	where
		cr.Id = ''' + cast(@group as varchar(36)) + '''' +
			case 
			when @historicalMode = 1
			then ' AND
				dbo.DateInRange(pm1.DateTaken, scrh.StartDate, scrh.EndDate) = 1'
			else
				''
			end + ' AND
			(rci.IsFinal = 1 or rcs.ID is null)
	) details
order by LastName
'			
print @sql
exec(@sql)
