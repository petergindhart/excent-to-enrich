
UPDATE VC3Reporting.ReportSchemaTable
SET TableExpression='
(SELECT i.*, d.ProgramID, m.PersonID AS TeamLeaderID, 
	CASE 
		WHEN ItemOutcomeId is null THEN 1 
		ELSE 0 
	END AS IsActive,
	DATEDIFF(DAY,GETDATE(),StartDate) AS TimeUntilStartDays,
	DATEDIFF(WEEK,GETDATE(),StartDate) AS TimeUntilStartWeeks,
	DATEDIFF(DAY,EndDate,GETDATE()) AS TimeSinceEndDays,
	DATEDIFF(WEEK,EndDate,GETDATE()) AS TimeSinceEndWeeks
FROM PrgItem i JOIN 
	PrgItemDef d ON d.ID = i.DefID LEFT JOIN 
	PrgItemTeamMember m ON (m.ItemID = i.ID AND m.IsPrimary = 1)
)'
WHERE Id='CA58AA53-C0AB-4326-AA35-6D74695596A7' 