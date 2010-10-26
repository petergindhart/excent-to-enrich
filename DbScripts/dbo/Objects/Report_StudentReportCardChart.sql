if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Report_StudentReportCardChart]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Report_StudentReportCardChart]
GO

CREATE PROCEDURE [dbo].[Report_StudentReportCardChart]
	@student 		uniqueidentifier,
	@rosterYear		uniqueidentifier,
	@filter			varchar(100) = null,
	@filterType		varchar(4)
AS

declare @results table(xvalue varchar(100), XLabel varchar(100), XOrder int, YSeriesValue varchar(100), YSeriesLabel varchar(100), YValue varchar(40), Highlight bit)

declare @filterDataGuid uniqueidentifier
SET @filterDataGuid = cast(@filter as uniqueidentifier)


declare @percentiles int
declare @pctTileFilter varchar(4000); 


--Filter by class, or default filter view
if(@FilterType = 'CR' )
BEGIN
	set @pctTileFilter = 'ClassRoster = ''' + cast(@filterDataGuid as varchar(36)) + ''' and PercentageScore is not null'
	exec CreatePercentiles @csvPercentilesList='.1,.3,.5,.7,.9', @datasetColumn = 'ReportCardItem', @valueColumn = 'PercentageScore', @table = 'ReportCardScore', @filter = @pctTileFilter, @calc=@percentiles output

	insert into @results(xvalue, XLabel, XOrder, YSeriesValue, YSeriesLabel, YValue, Highlight)
	select 
		Xvalue =  rci.ShortName,
		XLabel = rci.ShortName,
		XOrder =  rci.Sequence,
		YSeriesValue = 'Compare' + cast( PctTileIndex as varchar(1)),
		YSeriesLabel = cast(round(t.PctTile * 100, 0) as varchar(10)) + 'th',
		YValue = T.Value,
		Highlight = cast(1 as bit)	
	FROM
		ReportCardItem rci join
		dbo.Percentiles(@percentiles) T  on T.DataSet =  rci.ID

UNION ALL

	select 
		Xvalue =  rci.ShortName,
		XLabel = rci.ShortName,
		XOrder =  rci.Sequence,
		YSeriesValue = 'Student',
		YSeriesLabel = 'Score',
		YValue = rcs.PercentageScore,
		Highlight = cast(1 as bit)
	From 		
		ReportCardScore rcs join
		ReportCardItem rci on rcs.ReportCardItem = rci.Id join
		ClassRoster cr on rcs.ClassRoster = cr.ID
	where
		Student = @student and cr.RosterYearID = @rosterYear and cr.ID = @filterDataGuid and PercentageScore is not null

END
ELSE IF (@FilterType = 'RC')
BEGIN
	set @pctTileFilter = 'ReportCardItem=''' + cast(@filterDataGuid as varchar(36)) + ''' and ClassRoster in (select ClassRoster from ReportCardScore rcs join ClassRoster cr on rcs.ClassRoster = cr.ID where student = ''' + cast(@student as varchar(36)) + ''' and cr.RosterYearID = ''' + cast(@rosterYear as varchar(36)) + ''') and PercentageScore is not null'
	exec CreatePercentiles @csvPercentilesList='.1,.3,.5,.7,.9', @datasetColumn = 'ClassRoster', @valueColumn = 'PercentageScore', @table = 'ReportCardScore', @filter = @pctTileFilter, @calc=@percentiles output

	declare @classIndex table (Idx int identity primary key, classRoster uniqueidentifier) 
	declare @tempClassHolder table (classRoster uniqueidentifier)
	
	INSERT INTO @tempClassHolder
	select 
		rcs.ClassRoster
	from 
		ReportCardScore rcs join 
		ClassRoster cr on rcs.ClassRoster = cr.ID 
	where 
		student = @student and cr.RosterYearID = @rosterYear and rcs.ReportCardITem = @filter
	group by	
		ClassRoster		
	order by
			Max(PercentageScore) asc

	INSERT into @classIndex
	SELECT * From @tempClassHolder


	insert into @results(xvalue, XLabel, XOrder, YSeriesValue, YSeriesLabel, YValue, Highlight)
	select 
			Xvalue =  cr.ClassName,
			XLabel = cr.ClassName,
			XOrder =  (select idx from @classIndex cix where cix.classRoster = cr.ID),
			YSeriesValue = 'Compare' + cast( PctTileIndex as varchar(1)),
			YSeriesLabel = cast(round(t.PctTile * 100, 0) as varchar(10)) + 'th',
			YValue = T.Value,
			Highlight = cast(1 as bit)	
		FROM
			ClassRoster cr join
			dbo.Percentiles(@percentiles) T  on T.DataSet = cr.ID
UNION ALL

	select 
			Xvalue =  cr.ClassName,
			XLabel = cr.ClassName,
			XOrder =  (select idx from @classIndex cix where cix.classRoster = cr.ID),--rci.Sequence / rcs.PercentageScore,
			YSeriesValue = 'Primary',
			YSeriesLabel = 'Score',
			YValue = rcs.PercentageScore,
			Highlight = cast(1 as bit)
		From 
			Student stu join
			ReportCardScore rcs on rcs.Student = stu.Id join
			ReportCardItem rci on rcs.ReportCardItem = rci.Id join
			ClassRoster cr on rcs.ClassRoster = cr.ID
		where
			Student = @student and cr.RosterYearID = @rosterYear and rci.Id = @filter  and PercentageScore is not null

END

exec DeletePercentiles @percentiles


DECLARE @dataSetSize int 

IF (@FilterType = 'RC')
BEGIN
	select 
		@dataSetSize  =  count(*)
	from
		@classIndex ci
END
ELSE
BEGIN
	select @dataSetSize = Max(XOrder)
	from
		@results ru
		
END

INSERT INTO @results
select
	top 5
	Xvalue =  '',
	XLabel = ' ',
	XOrder = Xorder + 50,
	YSeriesValue = YSeriesValue,
	YSeriesLabel = YSeriesLabel,
	YValue = YValue,
	Highlight = cast(0 as bit)	
FROM
	@results
where 
	XOrder = @dataSetSize and YSeriesValue NOT in ('Primary', 'Student')


select * From @results

GO

--exec [Report_StudentReportCardChart] '96fa1aee-f910-42a0-8d34-821bbc7aee91', '6791403B-1414-4972-BC9D-ADE2ED9D33EA','8FCFB081-667C-4B8E-BE51-B566D78DA9BE', 'RC' --Yr Avg
--exec [Report_StudentReportCardChart] '96fa1aee-f910-42a0-8d34-821bbc7aee91', '6791403B-1414-4972-BC9D-ADE2ED9D33EA','7ef277e1-9cf7-41a5-b6ae-2d95560a2fe7', 'CR'

--exec [Report_StudentReportCardChart] '96fa1aee-f910-42a0-8d34-821bbc7aee91', '6791403B-1414-4972-BC9D-ADE2ED9D33EA','7ef277e1-9cf7-41a5-b6ae-2d95560a2fe7', 'CR'

--	exec [Report_StudentReportCardChart] '96fa1aee-f910-42a0-8d34-821bbc7aee91', '6791403B-1414-4972-BC9D-ADE2ED9D33EA','7ef277e1-9cf7-41a5-b6ae-2d95560a2fe7', 'CR'
--	exec [Report_StudentReportCardChart] '96fa1aee-f910-42a0-8d34-821bbc7aee91', '6791403B-1414-4972-BC9D-ADE2ED9D33EA','1FBDF42E-D65A-425C-A833-091F2E38832C', 'RC' --2nd Int
--	exec [Report_StudentReportCardChart] '96fa1aee-f910-42a0-8d34-821bbc7aee91', '6791403B-1414-4972-BC9D-ADE2ED9D33EA','8FCFB081-667C-4B8E-BE51-B566D78DA9BE', 'RC' --Yr Avg

--	exec [Report_StudentReportCardChart] '96fa1aee-f910-42a0-8d34-821bbc7aee91', '6791403B-1414-4972-BC9D-ADE2ED9D33EA','7E6E69D9-6BAB-4FBD-972A-5DB17907F9BF', 'RC' --Sem ex

--  exec [Report_StudentReportCardChart] '96fa1aee-f910-42a0-8d34-821bbc7aee91', '04A76EEE-64BD-4D93-ABB8-531B2DF59117','F644EDC1-3998-40C9-BC09-B689889289F6', 'RC'
--  exec [Report_StudentReportCardChart] '96fa1aee-f910-42a0-8d34-821bbc7aee91', '04A76EEE-64BD-4D93-ABB8-531B2DF59117','4E6140FD-CDA1-44FE-B599-5BCDBEBF0331', 'CR'

