IF object_id(N'dbo.ProbeScoreView', 'V') IS NOT NULL
	DROP VIEW dbo.ProbeScoreView
GO

CREATE VIEW ProbeScoreView
AS
SELECT s.*,
	CASE
		WHEN s.RubricValueID IS NOT NULL THEN r.Sequence +1
		WHEN s.NumericValue IS NOT NULL THEN s.NumericValue
		WHEN s.RatioPartValue IS NOT NULL AND s.RatioOutOfValue IS NOT NULL AND s.RatioOutOfValue <> 0 THEN (s.RatioPartValue/CAST(s.RatioOutOfValue AS FLOAT)) 
	END AS Value,
	CASE
		WHEN s.RubricValueID IS NOT NULL THEN r.Name
		WHEN s.NumericValue IS NOT NULL THEN CAST(s.NumericValue AS VARCHAR)
		WHEN s.RatioPartValue IS NOT NULL AND s.RatioOutOfValue IS NOT NULL THEN (CAST(s.RatioPartValue AS VARCHAR) + ' out of ' + CAST(s.RatioOutOfValue AS VARCHAR))
	END AS ValueDescription,
	CASE
		WHEN s.RubricValueID IS NOT NULL THEN r.Name
		WHEN s.NumericValue IS NOT NULL THEN CAST(s.NumericValue AS VARCHAR)
		WHEN s.RatioPartValue IS NOT NULL AND s.RatioOutOfValue IS NOT NULL THEN (CAST(s.RatioPartValue AS VARCHAR) + '/' + CAST(s.RatioOutOfValue AS VARCHAR))
	END AS ValueShortDescription
FROM ProbeScore s LEFT JOIN
	ProbeRubricValue r ON r.ID = s.RubricValueID