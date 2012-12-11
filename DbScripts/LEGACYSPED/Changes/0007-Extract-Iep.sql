IF  EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'LEGACYSPED.IEP_LOCAL') AND type in (N'U'))
DROP TABLE LEGACYSPED.IEP_LOCAL
GO


CREATE TABLE LEGACYSPED.IEP_LOCAL(

IepRefID	varchar(150) not null,
StudentRefID	varchar(150) not null,
IEPMeetDate	datetime not null,
IEPStartDate	datetime not null,
IEPEndDate	datetime not null,
NextReviewDate	datetime not null,
InitialEvaluationDate	datetime null,
LatestEvaluationDate	datetime not null,
NextEvaluationDate	datetime not null,
EligibilityDate datetime null,
ConsentForServicesDate	datetime not null,
ConsentForEvaluationDate	datetime null,
LREAgeGroup varchar(3) null,
LRECode	varchar(150) not null,
MinutesPerWeek	int not null,
ServiceDeliveryStatement	varchar(8000) null

)
GO
Alter table LEGACYSPED.IEP_LOCAL
add constraint PK_LEGACYSPED_IEP_LOCAL_IepRefID primary key (IepRefID)
GO


IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'LEGACYSPED.IEP'))
DROP VIEW LEGACYSPED.IEP
GO

CREATE VIEW LEGACYSPED.IEP
AS
 SELECT * FROM LEGACYSPED.IEP_LOCAL
GO
--