IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'dbo.SelectLists_Enrich'))
DROP VIEW dbo.SelectLists_Enrich
GO


CREATE VIEW dbo.SelectLists_Enrich
AS
SELECT Type, SubType, EnrichID, StateCode, LegacySpedCode, EnrichLabel 
FROM x_DATAVALIDATION.Selectlists