/* 
<summary>
Create a Stored proceedure that is used by reporting 
services to map goals against A student's score
</summary>
<param name="studentID">GUID for Student</param>
<param name="scoreDef">GUID for testScoreDefinition</param>
<param name="goals">uniqueidentifierarray that specifies the goals that are to be displayed</param>
<param name="maxAdministrations">The maximum number of administrations that are to be displayec</param>
<model isGenerated="False" returnType="System.Void" />

*/

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Report_StudentScoreHistoryChart]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Report_StudentScoreHistoryChart]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
SET NOCOUNT ON
GO

CREATE PROCEDURE dbo.Report_StudentScoreHistoryChart
	@studentID 		uniqueidentifier,
	@scoreDef 		uniqueidentifier,
	@goals 			uniqueidentifierarray,
	@maxAdministrations	int

AS

declare @scoreName varchar(128), @tableName varchar(128), @sql varchar(8000), @goalids varchar(200)
declare @tempGoal uniqueidentifier

select 	@tableName = (select tablename from testDefinition where id in 
		 	(select testdefinitionid from testsectiondefinition where id in 
				(select testsectiondefinitionid from testscoredefinition where id = @scoredef)
			)
		     )
select 	@scoreName = (select columnname from testscoredefinition where id = @scoreDef)

DECLARE tests CURSOR FOR
	SELECT id from getids(@goals)
OPEN tests

FETCH NEXT FROM tests INTO @tempGoal
set @goalids = ''''+cast(@tempGoal as varchar(36))+''''
WHILE @@FETCH_STATUS = 0
BEGIN
	set @goalids = @goalids + ', '''+cast(@tempGoal as varchar(36))+''''
	FETCH NEXT FROM tests INTO @tempGoal	
END

SET NOCOUNT OFF
CLOSE 		tests
DEALLOCATE 	tests

set @sql = '
declare @tests table (TestID uniqueidentifier, XValue varchar(36), XLabel varchar(50), XOrder DateTime, YSeriesValue varchar(36), YSeriesLabel varchar(200), YValue Real)

insert into @tests
select top ' + cast(@maxAdministrations as varchar(10)) + '
	t.Id,
	XValue		= cast(t.Id as varchar(36)),
	XLabel		= admin.Name + ''\nGrade ''+g.Name,
	XOrder		= t.DateTaken,
	YSeriesValue	= cast('''+cast(@scoreDef as varchar(36))+''' as varchar(36)),
	YSeriesLabel	= s.FirstName + '' '' + s.LastName,
	YValue		= t.'+@scoreName+'
from 
	Student s join
	'+cast(@tableName as varchar(36))+' t on t.StudentID = s.ID join
	TestAdministration admin on admin.Id = t.AdministrationID join
	GradeLevel g on g.id = t.GradeLevelID
where
	StudentId = '''+cast(@studentID as varchar(36))+''' and
	t.'+@scoreName+' is not null
order by
	admin.StartDate desc


select XValue, XLabel, XOrder, YSeriesValue, YSeriesLabel, YValue
from @tests'

if @goalids is not null
begin
	set @sql = @sql + '
	union all
	
	select
		XValue		= cast(t.Id as varchar(36)),
		XLabel		= admin.Name,
		XOrder		= t.DateTaken,
		YSeriesValue	= cast(tsg.TestGoalID as varchar(36)),
		YSeriesLabel	= tg.Name,
		YValue		= tsgv.Value
	from
		'+@tableName+' t join
		TestAdministration admin on admin.Id = t.AdministrationID join
		TestScoreGoalValue tsgv on
			tsgv.GradeLevelID = t.GradeLevelID join
		TestScoreGoal tsg on
			dbo.DateInRange(t.DateTaken, tsg.StartDate, tsg.EndDate) = 1 and
			tsg.ID = tsgv.TestScoreGoalID join
		TestGoal tg on
			tg.Id = tsg.TestGoalID
	where
		t.StudentId = '''+cast(@studentID as varchar(36))+''' and
		tsg.TestGoalID in('+@goalids+') and
		tsg.TestScoreDefinitionID = '''+cast(@scoreDef as varchar(36))+''' and
		t.'+@scoreName+' is not null and
		t.Id in (select TestID from @tests)
	'
end

exec(@sql)
