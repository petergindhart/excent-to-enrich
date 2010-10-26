SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Report_StudentPerformanceGroupsSql]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Report_StudentPerformanceGroupsSql]
GO



CREATE PROCEDURE dbo.Report_StudentPerformanceGroupsSql
	@group uniqueidentifier, @groupType char, @user uniqueidentifier, @testScore uniqueidentifier, @administration uniqueidentifier, @sql varchar(8000) output
AS

-- Constants
declare @crlf varchar(2);				set @crlf = char(13) + char(10)

declare @Numeric uniqueidentifier;		set @Numeric='35DD056B-E9DD-4DF7-B9C8-21B289D5588D'
declare @GradeLevel uniqueidentifier;	set @GradeLevel='22D3B947-5C40-4B35-86B0-2BA98D53BD83'
declare @Bit uniqueidentifier;			set @Bit='64DAD8FF-4408-47F5-AC6A-4CD891B2E581'
declare @EnumValue uniqueidentifier;	set @EnumValue='F415D55D-D901-46F5-8F64-B86A4DFA3A23'
--declare @DateTime uniqueidentifier;		set @DateTime='BAD958F8-B314-41C2-AF5A-D39BE608803B'

declare @now datetime; set @now = getdate()


-- Get test score metadata
declare @table			varchar(8000)
declare @column			varchar(8000)
declare @dataType		uniqueidentifier
declare @enumType		uniqueidentifier
declare @minValue		float
declare @maxValue		float
declare @catInterval	int

select
	@table			= TableName,
	@column			= ColumnName,
	@dataType		= DataTypeID,
	@minValue		= MinValue,
	@maxValue		= MaxValue,
	@enumType		= EnumType,
	@catInterval	= CategorizationInterval
from
	TestScoreDefinition scr join
	TestSectionDefinition sec on scr.TestSectionDefinitionID = sec.ID join
	TestDefinition t on sec.TestDefinitionID = t.ID
where
	scr.Id = @testScore


-- Build SQL to retrieve raw scores
declare @scores		varchar(8000)

set @scores 	= '(select StudentID=stu.Id, FirstName, LastName, RawScore=t.' + @column + ', TestID=t.ID' +  @crlf +
					'from Student stu left join ' + @crlf + 
					@table + ' t on stu.Id = t.StudentID and AdministrationID=''' + cast(@administration as varchar(36)) + '''' + @crlf +
					'where stu.Id in (' + @crlf +
						case @groupType
						when 'G' then 'select StudentID from StudentGroupStudentView where GroupID=''' + cast(@group as varchar(36)) + ''''
						when 'C' then 'select StudentID from StudentClassRosterHistory where ClassRosterID=''' + cast(@group as varchar(36)) + ''''
						end + ') ' +
						isnull( ' and ' + dbo.GetSecurityZoneFilter('stu', @user, @now), '' ) + ')'


-- Add Category columns to query based on the score's datatype
declare @select		varchar(8000)
declare @from		varchar(8000)
declare @where		varchar(8000)

if @dataType = @Numeric
begin
		-- Determine min/max from data if not in the test metadata, but if a specific interval is not given
		if (@minValue is null or @maxValue is null) AND @catInterval is null
		begin
			declare @temp varchar(8000)
			set nocount on
			set @temp = 'select min(' + @column + ') MinValue, max(' + @column + ') MaxValue from ' + @table

			create table #range (MinValue float, MaxValue float)
			insert into #range exec(@temp)
		
			DECLARE @recCount int
			select @recCount = count(*) from #range

			-- Ensure they are not null
			select
				@minValue = coalesce(@minValue, MinValue, 0),
				@maxValue = coalesce(@maxValue, MaxValue, 100) 
			from #range
		
			drop table #range
			set nocount off
		end

		-- Ensure min < max
		if @minValue = @maxValue
			set @maxValue = @minValue + 1
		else if @minValue > @maxValue
			select @minValue=@maxValue, @maxValue=@minValue 
		
		-- If the categorization interval is not null, then the min/max values should reflect the actual data, this will often result in a far narrower dataset then the whole table
		if(@catInterval is not null)
		BEGIN
			DECLARE @minMaxSql varchar(5000) 
			SET @minMaxSql = 
			'select MIN(t.' + @column + ') AS minScore, MAX(t.'+ @column + ') AS maxScore ' + @crlf +
			' from Student stu left join ' + @crlf + 
			@table + ' t on stu.Id = t.StudentID and AdministrationID=''' + cast(@administration as varchar(36)) + '''' + @crlf +
			'where stu.Id in (' + @crlf +
				case @groupType
				when 'G' then 'select StudentID from StudentGroupStudentView where GroupID=''' + cast(@group as varchar(36)) + ''''
				when 'C' then 'select StudentID from StudentClassRosterHistory where ClassRosterID=''' + cast(@group as varchar(36)) + ''''
				end + ') ' +
				isnull( ' and ' + dbo.GetSecurityZoneFilter('stu', @user, @now), '' ) 
			
			CREATE TABLE #minMaxValues (minScore real, maxScore real)
			
			INSERT #minMaxValues
				EXEC (@minMaxSql)

			SELECT @minValue = isnull(minScore, @minValue), @maxValue = isnull(maxScore, @maxValue)
			FROM #minMaxValues	

			DROP TABLE #minMaxValues
		END

		set @select	= 'Category=c.Name, CategorySequence=c.Sequence, Score=t.RawScore'
		set @from	= 'dbo.CategoriesFromRange(' + cast(@minValue as varchar(20)) + ', ' + cast(@maxValue as varchar(20)) + ', 5, 7,' + cast(IsNull(@catInterval,-1) as varchar(5)) + ') c full outer join
						' + @scores + ' t on t.RawScore >= c.LowerBound and t.RawScore <= c.UpperBound'
end

else if @dataType = @EnumValue
begin
	set @select	= 'Category=e.DisplayValue, CategorySequence= case when ISNULL(e.Sequence, -1) = -1 AND IsNumeric(e.Code) = 1 then cast(e.Code as float) else e.Sequence end , Score=case when t.RawScore is null then null else e.DisplayValue end'
	set @from	= '(select * from EnumValue where Type = ''' + cast(@enumType as varchar(36)) + ''') e full outer join
					' + @scores + ' t on t.RawScore = e.Id'
end


else if @dataType = @GradeLevel
begin
	set @select	= 'Category=gl.Name, CategorySequence=gl.Name, Score=case when t.RawScore is null then null else gl.Name end'
	set @from	= 'GradeLevel gl right join
					' + @scores + ' t on t.RawScore = gl.Id'
end

else if @dataType = @Bit
begin
	set @select	= 'Category=c.Name, CategorySequence=c.Score, Score=case when t.RawScore is null then null when t.RawScore=1 then ''Yes'' else ''No'' end'
	set @from	= '(select Name=''Yes'', Score=cast(1 as bit) union all select Name=''No'', Score=cast(0 as bit)) c full outer join
					' + @scores + ' t on t.RawScore = c.Score'
end


-- Return final SQL
set @sql =	'select ' + @select + ', t.StudentID, t.FirstName, t.LastName, t.TestID' + @crlf +
			'from ' + @from + @crlf +
			isnull('where ' + @where, '')


