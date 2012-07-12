IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.IEP_LOCAL') AND type in (N'U'))
DROP TABLE LEGACYSPED.IEP_LOCAL
GO


CREATE TABLE LEGACYSPED.IEP_LOCAL(
IepRefID	varchar(150),
StudentRefID	varchar(150),
IEPMeetDate	varchar(10),
IEPStartDate	varchar(10),
IEPEndDate	varchar(10),
NextReviewDate	varchar(10),
InitialEvaluationDate	varchar(10),
LatestEvaluationDate	varchar(10),
NextEvaluationDate	varchar(10),
EligibilityDate varchar(10),
ConsentForServicesDate	varchar(10),
LREAgeGroup varchar(3),
LRECode	varchar(150),
MinutesPerWeek	varchar(4),
ServiceDeliveryStatement	varchar(8000),
)
GO


IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'LEGACYSPED.IEP'))
DROP VIEW LEGACYSPED.IEP
GO

CREATE VIEW LEGACYSPED.IEP
AS
 SELECT * FROM LEGACYSPED.IEP_LOCAL
GO
--