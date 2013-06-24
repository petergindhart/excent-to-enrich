IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'dbo.IEP_Enrich'))
DROP VIEW dbo.IEP_Enrich
GO

CREATE VIEW dbo.IEP_Enrich
AS
SELECT
    IepRefId, 
	StudentRefId , 
	IEPMeetDate , 
	IEPStartDate, 
	IEPEndDate ,
	NextReviewDate,
	InitialEvaluationDate , 
	LatestEvaluationDate , 
	NextEvaluationDate , 
	EligibilityDate ,
	ConsentForServicesDate , 
	ConsentForEvaluationDate,
	LREAgeGroup,
	LRECode ,
	MinutesPerWeek,
	ServiceDeliveryStatement 
FROM Datavalidation.IEP