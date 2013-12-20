IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'dbo.Goal_Enrich'))
DROP VIEW dbo.Goal_Enrich
GO

CREATE VIEW dbo.Goal_Enrich
AS
SELECT GoalRefID, IepRefID, Sequence, GoalAreaCode, PSEducation, PSEmployment, PSIndependent, IsEsy, UnitOfMeasurement, BaselineDataPoint, EvaluationMethod, GoalStatement FROM x_DATAVALIDATION.Goal