IF  EXISTS (SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'dbo.Objective_Enrich'))
DROP VIEW dbo.Objective_Enrich
GO

CREATE VIEW dbo.Objective_Enrich
AS
SELECT ObjectiveRefID, GoalRefID, Sequence, ObjText 
FROM x_DATAVALIDATION.Objective