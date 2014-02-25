IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'dbo.Service_Enrich'))
DROP VIEW dbo.Service_Enrich
GO

CREATE VIEW dbo.Service_Enrich
AS
SELECT ServiceType, ServiceRefId, IepRefId, ServiceDefinitionCode, BeginDate, EndDate, IsRelated, IsDirect, ExcludesFromGenEd, ServiceLocationCode, ServiceProviderTitleCode, Sequence, IsESY, ServiceTime, ServiceFrequencyCode, ServiceProviderSSN, StaffEmail, ServiceAreaText 
FROM x_DATAVALIDATION.Service