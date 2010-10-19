

-- Change RosterYearID to ry.ID to fix syntax error
update VC3Reporting.ReportSchemaTable
set TableExpression='(select sglh.StudentID, sglh.GradeLevelID, ry.ID RosterYearID from StudentGradeLevelHistory sglh join RosterYear ry on dbo.DateRangesOverlap(ry.StartDate, ry.EndDate, sglh.StartDate, sglh.EndDate, @now) = 1 where ry.ID={Roster Year} or {Roster Year} is null)'
where ID='FF6328F5-2C8D-462A-949C-2FED8D735BD0'