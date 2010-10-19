-- Meeting type reports are now tied to the speced feature
update dbo.ReportType
set ViewFeatureId = '426D5613-B398-4556-BF3F-765040E5617F' -- Programs.SpecEd
where ID = 'M' -- Meetings