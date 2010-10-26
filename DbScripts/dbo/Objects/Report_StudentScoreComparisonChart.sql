if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Report_StudentScoreComparisonChart]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Report_StudentScoreComparisonChart]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
SET NOCOUNT ON
GO


/* 
<summary>
Create a Stored proceedure that is used by reporting 
services to map goals against A student's score
</summary>
<param name="testScoreID">GUID for the row in the test table</param>
<param name="scoreDef">GUID for testScoreDefinition</param>

<model isGenerated="False" returnType="System.Void" />

*/
CREATE PROCEDURE dbo.Report_StudentScoreComparisonChart
	@testScoreID 		uniqueidentifier,
	@scoreDef 		uniqueidentifier, 
	@goalType		uniqueidentifier
AS

declare @scoreName varchar(128)
declare @tableName varchar(128)
declare @sql varchar(8000)
declare @goalID uniqueidentifier
declare @testid uniqueidentifier
declare @tempgoal uniqueidentifier

select @tablename = d.tablename, @testid = d.id, @scorename = s.columnname
	from 
		testdefinition d join
		testsectiondefinition c on c.testdefinitionid = d.id join
		testscoredefinition s on c.id = s.testsectiondefinitionid
	where
		s.id = @scoredef 


--Average score for the school for this administration
set @sql='
declare @testDate datetime
declare @admin uniqueidentifier
declare @school uniqueidentifier
declare @gradelevel uniqueidentifier

select
	@testDate = datetaken,
	@admin = AdministrationID,
	@school = SchoolID,
	@gradelevel = GradeLevelID
from '+@tableName+' 
where id = '''+cast(@testScoreID as varchar(36))+'''

-- Determine goals
declare @goals table (YSeriesValue varchar(1000), YSeriesLabel varchar(1000), YValue real)
declare @scores table (XValue varchar(500), XLabel varchar(500), XOrder int, YSeriesValue varchar(1000), YSeriesLabel varchar(1000), YValue real)

declare @goalName varchar(100)
declare @YSeriesVal varchar(10)
declare @goalValue int
declare @counter int

declare @testAdministrationType uniqueidentifier

select @testAdministrationType = TypeID
From 
	TestAdministration ta join
	'+@tableName+' m on ta.ID = m.AdministrationID 
where
	m.ID = '''+cast(@testScoreID as varchar(36))+'''
' 

if @goalType is not null
begin
	set @sql = @sql +
		'
		insert into @goals
		select
			YSeriesValue	= '''',
			YSeriesLabel	= goal.name,
			YValue		= tsgv.value
		from
			TestGoalType type join
			TestGoal goal on goal.typeid = type.id join
			TestScoreGoal tsg on tsg.testgoalid = goal.id join
			TestScoreGoalValue tsgv on tsgv.testscoregoalid = tsg.id join
			TestScoreDefinition score on score.id = tsg.testscoredefinitionid 
		where 
			score.id = '''+cast(@scoreDef as varchar(36))+''' and
			dbo.DateInRange(@testDate, tsg.StartDate, tsg.EndDate) = 1 and
			(tsgv.gradelevelid in(select gradelevelid from '+@tableName+' 
				where id = '''+cast(@testScoreID as varchar(36))+''') or tsgv.gradelevelid is null) and
			type.id = '''+cast(@goalType as varchar(36))+''' and
			(
				tsgv.TestAdministrationTypeID1 is null or tsgv.TestAdministrationTypeID1 = @testAdministrationType		
			)	

		declare @sequence int
		set @sequence = 0

		update @goals
		set
			YSeriesValue = ''Goal'' + cast(@sequence as varchar(10)),
			@sequence = @sequence + 1
		'
end

set @sql = @sql +
	'-- Student
	insert into @scores
	select 
		XValue		= ''Student'',
		XLabel		= FirstName,
		XOrder		= 1,
		YSeriesValue	= cast('''+cast(@scoreDef as varchar(36))+''' as varchar(36)),
		YSeriesLabel	= ''Score'',
		YValue		= t.'+@scoreName+'
	FROM
		'+@tableName+' t join
		student s on t.studentid = s.id
	WHERE
		t.id = '''+cast(@testScoreID as varchar(36))+'''
	union all

	-- School avg
	select 
		XValue		= cast(@school as varchar(36)),
		XLabel		= (select Abbreviation + '' Average'' from School where ID = @school),
		XOrder		= 2,
		YSeriesValue	= cast('''+cast(@scoreDef as varchar(36))+''' as varchar(36)),
		YSeriesLabel	= ''Score'',
		YValue		= round(avg('+@scoreName+'),0)
	FROM
		'+@tableName+'
	where
		AdministrationId = @admin and 
		GradeLevelID = @gradelevel and
		SchoolId = @school and
		'+@scoreName+' is not null
	group by Administrationid
	union all

	-- District Avg
	select 
		XValue		= ''District Average'',
		XLabel		= ''District Average'',
		XOrder		= 3,
		YSeriesValue	= cast('''+cast(@scoreDef as varchar(36))+''' as varchar(36)),
		YSeriesLabel	= ''Score'',
		YValue		= round(avg('+@scoreName+'),0)
	FROM
		'+@tableName+'
	where
		AdministrationId = @admin and 
		GradeLevelID = @gradelevel and
		'+@scoreName+' is not null
	group by Administrationid


-- Return all results
select	*
from	@scores
union all

select	s.XValue, s.XLabel, s.XOrder, g.*
from	@scores s cross join @goals g'

if @goalType is not null
begin
	set @sql = @sql + '
		union all

		select	''Footer'', '' '', 100, g.*
		from	@goals g
		order by XValue, XLabel	'
end

exec(@sql)