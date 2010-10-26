IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[Report_CAPRSTestScoreSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Report_CAPRSTestScoreSummary]
GO

create Procedure [dbo].[Report_CAPRSTestScoreSummary]
	@group uniqueidentifier
AS

if @group is null
	set @group = '2f35c8a3-72d4-40df-ae95-f96f43119f2c'

declare @test varchar(50)				-- the TABLE name of the table corresponding to the test
declare @testName varchar(50)			-- The formal name of the test
declare @testID uniqueidentifier		-- the GUID for the testDefinition
declare @testScore varchar(50)			-- The Primary Score that is used to generate the  summaries
declare @testSchool uniqueidentifier		-- The school where the class was taken
declare @pm1 uniqueidentifier
declare @pm2 uniqueidentifier
declare @pmAdminName1 varchar(40)		-- The Year for the most recent TestAdministration
declare @pmAdminName2 varchar(40)		-- The Year for the 2nd most recent TestAdministration

declare @rosterYear uniqueidentifier
declare @courseCode varchar(20)
declare @sql varchar(8000)

declare @subject varchar(20)
declare @subjectID uniqueidentifier
declare @levelType uniqueidentifier
declare @primaryScoreIndexID uniqueidentifier

declare @pm1Required bit
SET @pm1Required = 1

select 
	@subject = sub.Abbreviation,
	@subjectID = sub.ID,
	@rosterYear = cr.RosterYearID,
	@courseCode = cr.CourseCode,
	@testSchool = cr.SchoolID	
from 
	ClassRoster cr join
	ContentArea ca on cr.ContentAreaID = ca.ID join
	Subject sub on ca.SubjectID = sub.ID	
where 
	cr.id = @group

select
	@primaryScoreIndexID =	case when cp.PrimaryScoreIndex = 3 then cp.PrimaryScoreDef3
								when cp.PrimaryScoreIndex = 2 then cp.PrimaryScoreDef2
								else cp.PrimaryScoreDef1
								end,
	@pm1Required = case when ValidGradeRangeBitMask & dbo.GetClassRosterGradeBitMask(@group) <> 0 then 1 else 0 end
from
	CaprParameters cp
where
	cp.SubjectID = @subjectID

-- gets the name and GUID of the primary and benchmark tests
select 
	@test =  td.TableName,
	@testID =  td.ID,
	@testScore = tsd.ColumnName,
	@testName = td.Name,
	@levelType = tsd.EnumType 
from 
	TestScoreDefinition tsd join
	TestSectionDefinition tsect on tsd.TestSectionDefinitionID = tsect.ID join
	TestDefinition td on tsect.TestDefinitionID = td.ID
where 
	tsd.id= @primaryScoreIndexID


-- Primary admin 1 - must be in class's roster year
select top 1
	@pm1 = ta.ID,
	@pmAdminName1 = ta.Name
from
	RosterYear ry join
	TestAdministration ta on dbo.DateInRange(ta.StartDate, ry.StartDate, ry.EndDate) = 1
where
	TestDefinitionID = @testID  AND 
	ry.id = @rosterYear  AND
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
	TestDefinitionID = @testID  AND 
	ry.id = @rosterYear AND
	(@pm1 is null OR ta.id <> @pm1)
order by
	ta.StartDate DESC

set @testScore = 'pm1.' + @testScore

set @sql ='
declare @admins table(Id uniqueidentifier, Name varchar(40), Sequence int) 
' + isnull('insert into @admins values(''' + cast(@pm1 as varchar(36)) + ''', ''' + @pmAdminName1 + ''', 1)', '') + '
' + isnull('insert into @admins values(''' + cast(@pm2 as varchar(36)) + ''', ''' + @pmAdminName2 + ''', 2)', '') + '

select 
	''' + @testName + ''' as Test,
	groupings.Administration,
	groupings.AdministrationNumber,
	groupings.InSchool,
	groupings.InClass,
	groupings.Level,
	groupings.Code,
	Count = isnull(tests.Count, 0)
from
	(	select
			x.InSchool,
			x.InClass,
			ScoreID = ev.Id,
			Level = dbo.CreateAcronym(ev.DisplayValue),
			ev.Code,
			AdministrationID = admins.Id,
			AdministrationNumber = admins.Sequence,
			Administration = admins.Name
		from
			(
				select *
				from
				(
					select InSchool = cast(1 as bit), InClass = cast(1 as bit) union all
					select InSchool = cast(1 as bit), InClass = cast(0 as bit) union all
					select InSchool = cast(0 as bit), InClass = cast(0 as bit)
				) x
			) x	 cross join
			EnumValue ev cross join
			@admins admins
		where
			ev.Type = ''' + cast(@levelType as varchar(36)) + '''
	) groupings left join
	(
		select
			InSchool = case when cr.SchoolID = ''' + cast(@testSchool as varchar(36)) + ''' then 1 else 0 end,
			InClass = case when cr.Id = ''' + cast(@group as varchar(36)) + ''' then 1 else 0 end,
			ScoreID = ' + @testScore + ',
			AdministrationID = admins.ID,
			count(*) as Count
		from 
			ClassRoster cr join
			StudentClassRosterHistory scrh on cr.ID = scrh.ClassRosterID join
			Student stu on scrh.StudentID = stu.ID join
			' + @test + ' pm1 on pm1.StudentID = stu.ID join
			@admins admins on admins.Id = pm1.AdministrationID	
		where 	
			cr.CourseCode = ''' + @courseCode + ''' AND
			cr.RosterYearID = '''  + cast(@rosterYear as varchar(36)) + '''
		group by
			case when cr.SchoolID = ''' + cast(@testSchool as varchar(36)) + ''' then 1 else 0 end,
			case when cr.Id = ''' + cast(@group as varchar(36)) + ''' then 1 else 0 end,
			admins.ID,
			' + @testScore + '
	) tests on
			tests.ScoreID = groupings.ScoreID and
			tests.InSchool = groupings.InSchool and
			tests.InClass = groupings.InClass and
			tests.AdministrationID = groupings.AdministrationID
'
--
--print '@test = ' + isnull(cast(@test as varchar(1000)), '<null>')
--print '@testName = ' + isnull(cast(@testName as varchar(1000)), '<null>')
--print '@testID = ' + isnull(cast(@testID as varchar(1000)), '<null>')
--print '@testScore = ' + isnull(cast(@testScore as varchar(1000)), '<null>')
--print '@testSchool = ' + isnull(cast(@testSchool as varchar(1000)), '<null>')
--print '@pm1 = ' + isnull(cast(@pm1 as varchar(1000)), '<null>')
--print '@pm2 = ' + isnull(cast(@pm2 as varchar(1000)), '<null>')
--print '@pmAdminName1 = ' + isnull(cast(@pmAdminName1 as varchar(1000)), '<null>')
--print '@pmAdminName2 = ' + isnull(cast(@pmAdminName2 as varchar(1000)), '<null>')
--
--print '@rosterYear = ' + isnull(cast(@rosterYear as varchar(1000)), '<null>')
--print '@courseCode = ' + isnull(cast(@courseCode as varchar(1000)), '<null>')
--print '@sql = ' + isnull(cast(@sql as varchar(1000)), '<null>')
--
--print '@subject = ' + isnull(cast(@subject as varchar(1000)), '<null>')
--print '@subjectID = ' + isnull(cast(@subjectID as varchar(1000)), '<null>')
--print '@levelType = ' + isnull(cast(@levelType as varchar(1000)), '<null>')
--print '@primaryScoreIndexID = ' + isnull(cast(@primaryScoreIndexID as varchar(1000)), '<null>')

print @sql
exec(@sql)
