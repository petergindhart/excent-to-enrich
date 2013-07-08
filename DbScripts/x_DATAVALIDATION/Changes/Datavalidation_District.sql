IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'dbo.District_Enrich'))
DROP VIEW dbo.District_Enrich
GO

CREATE VIEW dbo.District_Enrich
AS
SELECT DistrictCode,DistrictName 
FROM Datavalidation.District