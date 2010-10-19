--#ASSUME VC3Reporting:15

UPDATE vt
SET vt.Description = t.Description
FROM ReportType t JOIN
VC3Reporting.ReportType vt ON vt.Id = t.Id

ALTER TABLE ReportType
DROP COLUMN Description