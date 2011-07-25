IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[AURORAX].[IEP_LOCAL]') AND type in (N'U'))
DROP TABLE [AURORAX].[IEP_LOCAL]
GO


CREATE TABLE [AURORAX].[IEP_LOCAL](
IepRefID	varchar(150),
StudentRefID	varchar(150),
IEPStartDate	varchar(10),
IEPEndDate	varchar(10),
NextReviewDate	varchar(10),
InitialEvaluationDate	varchar(10),
LatestEvaluationDate	varchar(10),
NextEvaluationDate	varchar(10),
ConsentForServicesDate	varchar(10),
LRECode	varchar(150),
MinutesPerWeek	varchar(4),
ServiceDeliveryStatement	varchar(8000),
)
GO


IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[AURORAX].[IEP]'))
DROP VIEW [AURORAX].[IEP]
GO

CREATE VIEW [AURORAX].[IEP]
AS
 SELECT * FROM [AURORAX].[IEP_LOCAL]
GO
--