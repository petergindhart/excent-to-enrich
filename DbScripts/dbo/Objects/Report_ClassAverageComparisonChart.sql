if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Report_ClassAverageComparisonChart]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Report_ClassAverageComparisonChart]
GO

CREATE PROCEDURE [dbo].[Report_ClassAverageComparisonChart]
	@classRoster	uniqueidentifier,
	@filterType		varchar(10)
AS


declare @results table(xvalue varchar(100), XLabel varchar(100), XOrder int, YSeriesValue varchar(100), YSeriesLabel varchar(100), YValue varchar(40), Highlight bit)

declare @pctTileFilter varchar(4000); 
declare @percentiles int


--Control class, needs to be calculated away from the other datasets
set @pctTileFilter = 'ClassRoster = ''' + cast(@classRoster as varchar(36)) + ''' and PercentageScore is not null'

exec CreatePercentiles	@csvPercentilesList='.5', @datasetColumn = 'ReportCardItem', @valueColumn = 'PercentageScore', @table = 'ReportCardScore', @filter = @pctTileFilter, @calc=@percentiles output


insert into @results(xvalue, XLabel, XOrder, YSeriesValue, YSeriesLabel, YValue, Highlight)
select 
	Xvalue =  rci.ShortName,
	XLabel = rci.ShortName,
	XOrder =  rci.Sequence,
	YSeriesValue = 'Average',
	YSeriesLabel = 'ControlMedian',
	YValue = T.Value,
	Highlight = cast(1 as bit)	
FROM
	ReportCardItem rci join
	dbo.Percentiles(@percentiles) T  on T.DataSet =  rci.ID

exec DeletePercentiles @percentiles
--END control calculation region



-- store the chosen percentiles
DECLARE @school uniqueidentifier
select @school = SchoolID from ClassRoster where id = @classRoster

DECLARE @rosterYear uniqueidentifier
select @rosterYear = RosterYearID from ClassRoster where id = @classRoster

DECLARE @courseCode varchar(10)
select @courseCode = CourseCode from ClassRoster where id = @classRoster


declare @percentilesStr varchar(50)

if(@filterType != 'CLASS')
	set @percentilesStr = '.1,.3,.5,.7,.9'
else
	set @percentilesStr = '.1,.3,.7,.9'


--90th Pctl
set @pctTileFilter = null

if (@filterType = 'CLASS')
	set @pctTileFilter = 'ClassRoster = ''' + cast(@classRoster as varchar(36)) + ''' AND PercentageScore Is not NULL'
ELSE IF (@filterType = 'school')
	set @pctTileFilter = isnull('(ClassRoster IN
		(
			select ID 
			From ClassRoster 
			where SchoolID = ''' + cast(@school as varchar(36)) + ''' and CourseCode =''' + cast(@courseCode as varchar(36)) + ''' and RosterYearID = ''' + cast(@rosterYear as varchar(36)) + '''
		) or ', '(') + 'ClassRoster = ''' + cast(@classRoster as varchar(36)) + ''') AND PercentageScore Is not NULL'
ELSE IF (@filterType = 'district')
		set @pctTileFilter = isnull('(ClassRoster IN
		(
			select ID 
			From ClassRoster 
			where CourseCode =''' + cast(@courseCode as varchar(36)) + ''' and RosterYearID = ''' + cast(@rosterYear as varchar(36)) + '''
		) or ', '(') + 'ClassRoster = ''' + cast(@classRoster as varchar(36)) + ''') AND PercentageScore Is not NULL'


--if none, don't populate vals table, and the other query will just return zero, and the only data will be the control
if @pctTileFilter is not null
	exec CreatePercentiles @csvPercentilesList=@percentilesStr, @datasetColumn = 'ReportCardItem', @valueColumn = 'PercentageScore', @table = 'ReportCardScore', @filter = @pctTileFilter, @calc=@percentiles output

insert into @results(xvalue, XLabel, XOrder, YSeriesValue, YSeriesLabel, YValue, Highlight)
select 
	Xvalue =  rci.ShortName,
	XLabel = rci.ShortName,
	XOrder =  rci.Sequence,
	YSeriesValue = 'Compare' + cast(T.PctTileIndex as varchar(1)),
	YSeriesLabel = cast(round(t.PctTile * 100, 0) as varchar(10)) + 'th Pctl',
	YValue = T.Value,
	Highlight = cast(1 as bit)	
FROM
	ReportCardItem rci join
	dbo.Percentiles(@percentiles) T on T.DataSet = rci.ID


-- Repeat the last data point so the labels will not overlap the bars in the chart
INSERT INTO @results
select
	Xvalue =  ' ',
	XLabel = ' ',
	XOrder =  MaxVals.Xorder + 1,
	YSeriesValue = MaxVals.YSeriesValue,
	YSeriesLabel = MaxVals.YSeriesLabel,
	YValue = MaxVals.YValue,
	Highlight = cast(0 as bit)	
FROM
(
	select 
		Xorder,
		YSeriesValue,
		YSeriesLabel,
		YValue = MAX(YValue) 
	From @results
	where
		YSeriesLabel != 'ControlMedian' and
		Xorder = (select max(XOrder) from @results where YSeriesLabel != 'ControlMedian')
	group by 
		Xorder,
		YSeriesValue,
		YSeriesLabel
) MaxVals


select * From @results

exec DeletePercentiles @percentiles

GO

--exec [Report_ClassAverageComparisonChart] '7bc2050d-e68d-4594-8f5a-a43f55a3cd91', 'None'
--exec [Report_ClassAverageComparisonChart] '7bc2050d-e68d-4594-8f5a-a43f55a3cd91', 'School' 
--exec [Report_ClassAverageComparisonChart] '7bc2050d-e68d-4594-8f5a-a43f55a3cd91', 'Class'
--exec [Report_ClassAverageComparisonChart] '7bc2050d-e68d-4594-8f5a-a43f55a3cd91', 'District'

--exec [Report_ClassAverageComparisonChart] 'AE6287A6-FFDF-4755-9B4D-947047553AF1', 'None'
--exec [Report_ClassAverageComparisonChart] 'AE6287A6-FFDF-4755-9B4D-947047553AF1', 'School'
--exec [Report_ClassAverageComparisonChart] 'AE6287A6-FFDF-4755-9B4D-947047553AF1', 'District'
--exec [Report_ClassAverageComparisonChart] 'AE6287A6-FFDF-4755-9B4D-947047553AF1', 'class'


--	exec sp_procedure_params_rowset @procedure_name = N'Report_ClassReportCardChart'
--	exec Report_ClassReportCardChart 'BB0FC68B-71E4-4F52-97B5-F0BEBF8B5D09', '969175E7-26C8-4C99-B490-C2E8835F24F0|D23F702E-8277-4A35-83B7-343A6A7C49C1', '#c0c0c0|#990000|#333366|#9999cc|#ccccff|#86bD86'
--	exec Report_StudentScoreComparisonChart '4f0fc5f1-bf8f-4ecb-a181-5c8325467c28', 'fb6a3aae-1a02-4c29-9501-3e803833e3fa', '93E1A84C-84DB-4F2E-BB1A-C8484E4C45A9'
--	exec Report_ReportCardScoreChart '96fa1aee-f910-42a0-8d34-821bbc7aee91', '6791403B-1414-4972-BC9D-ADE2ED9D33EA','7ef277e1-9cf7-41a5-b6ae-2d95560a2fe7', 'CR'
--	exec Report_ReportCardScoreChart '96fa1aee-f910-42a0-8d34-821bbc7aee91', '6791403B-1414-4972-BC9D-ADE2ED9D33EA','1FBDF42E-D65A-425C-A833-091F2E38832C', 'RC'

--  exec Report_ClassComparisonReportCardChart '7bc2050d-e68d-4594-8f5a-a43f55a3cd91', '', 'None'
--  exec Report_ClassComparisonReportCardChart '7bc2050d-e68d-4594-8f5a-a43f55a3cd91', '', 'School'
--  exec [Report_ClassAverageComparisonChart] '7bc2050d-e68d-4594-8f5a-a43f55a3cd91', '', 'Class'
--  exec Report_ClassComparisonReportCardChart '7bc2050d-e68d-4594-8f5a-a43f55a3cd91', '', 'District'

--  exec Report_ClassComparisonReportCardChart '8b435a49-9003-4b0a-b4c9-df0208c58d3a', '', 'District'
--  exec Report_ClassComparisonReportCardChart '8b435a49-9003-4b0a-b4c9-df0208c58d3a', '', 'Class'

--select * from ReportCardItem where id='1FBDF42E-D65A-425C-A833-091F2E38832C'

