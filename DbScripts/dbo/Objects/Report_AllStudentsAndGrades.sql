if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Report_AllStudentsAndGrades]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Report_AllStudentsAndGrades]
GO

CREATE PROCEDURE [dbo].[Report_AllStudentsAndGrades]
	@classRoster	varchar(36),	
	@students		uniqueidentifierarray,
	@colors			varchar(400),
	@highlightedItem	varchar(36)
AS

DECLARE @classRosterGUID uniqueidentifier
SET @classRosterGUID = cast(@classRoster as uniqueidentifier)

select 
	Xvalue =  rci.ShortName,
	XLabel = rci.ShortName,
	XOrder =  rci.Sequence,
	YSeriesValue = stu.ID,
	YSeriesLabel = stu.FirstName + ' ' + stu.LastName,
	YValue = rcs.PercentageScore,
	Highlight =  case 
					when @highlightedItem is not null AND LEN(@highlightedItem) > 0
						then 
							case when @highlightedItem = stu.ID then 1 else -1 end
						else
							0
					end,
	Color = colors.Id
FROM
	ReportCardScore rcs INNER join
	ReportCardItem rci on rcs.ReportCardItem = rci.Id INNER JOIN
	GetSequencedIds(@students) students ON rcs.Student = students.ID join
	GetSequencedVarchar20s(@colors) colors on colors.position = students.position join
	Student stu on stu.Id = students.ID
where
	rcs.ClassRoster = @classRosterGUID
order by
	YSeriesValue, XOrder

--	exec sp_procedure_params_rowset @procedure_name = N'Report_ClassReportCardChart'
--	exec Report_ClassReportCardChart 'BB0FC68B-71E4-4F52-97B5-F0BEBF8B5D09', '969175E7-26C8-4C99-B490-C2E8835F24F0|D23F702E-8277-4A35-83B7-343A6A7C49C1', '#c0c0c0|#990000|#333366|#9999cc|#ccccff|#86bD86', 'D23F702E-8277-4A35-83B7-343A6A7C49C1'
--	exec Report_StudentScoreComparisonChart '4f0fc5f1-bf8f-4ecb-a181-5c8325467c28', 'fb6a3aae-1a02-4c29-9501-3e803833e3fa', '93E1A84C-84DB-4F2E-BB1A-C8484E4C45A9'
--	exec Report_ReportCardScoreChart '96fa1aee-f910-42a0-8d34-821bbc7aee91', '6791403B-1414-4972-BC9D-ADE2ED9D33EA','7ef277e1-9cf7-41a5-b6ae-2d95560a2fe7', 'CR'
--	exec Report_ReportCardScoreChart '96fa1aee-f910-42a0-8d34-821bbc7aee91', '6791403B-1414-4972-BC9D-ADE2ED9D33EA','1FBDF42E-D65A-425C-A833-091F2E38832C', 'RC'
