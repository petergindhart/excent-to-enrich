IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'dbo.School_Enrich'))
DROP VIEW dbo.School_Enrich
GO


CREATE VIEW dbo.School_Enrich
AS
SELECT SchoolCode, SchoolName, DistrictCode, MinutesPerWeek 
FROM x_DATAVALIDATION.School