--LEGACYSPED.Transform_PrgInvolvement 19
DELETE LEGACYSPED.MAP_PrgInvolvementID
FROM (select * from LEGACYSPED.Transform_PrgInvolvement where Touched = 0) AS s RIGHT OUTER JOIN 
	LEGACYSPED.MAP_PrgInvolvementID as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

UPDATE STATISTICS LEGACYSPED.MAP_PrgInvolvementID

--LEGACYSPED.Transform_PrgInvolvement 21
DELETE FROM PrgInvolvementStatus
 WHERE InvolvementID not in (select ID from PrgInvolvement)

UPDATE STATISTICS PrgInvolvementStatus

--LEGACYSPED.Transform_IepServices  26
DELETE LEGACYSPED.MAP_FormInstanceInterval_Services
FROM (select * from LEGACYSPED.Transform_IepServices where DoNotTouch = 0) AS s RIGHT OUTER JOIN 
	LEGACYSPED.MAP_FormInstanceInterval_Services as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

UPDATE STATISTICS LEGACYSPED.MAP_FormInstanceInterval_Services

--LEGACYSPED.Transform_PrgItemTeamMember 33
DELETE FROM PrgItemTeamMember
 WHERE ItemID in (select DestID from LEGACYSPED.MAP_IEPStudentRefID)

UPDATE STATISTICS PrgItemTeamMember

--LEGACYSPED.Transform_IepDisabilityEligibility 40
DELETE LEGACYSPED.MAP_IepDisabilityEligibilityID 
FROM (select * from LEGACYSPED.Transform_IepDisabilityEligibility where DoNotTouch = 0) AS s RIGHT OUTER JOIN 
	LEGACYSPED.MAP_IepDisabilityEligibilityID  as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

UPDATE STATISTICS LEGACYSPED.MAP_IepDisabilityEligibilityID 

-- 55-57 Import Type issue
--LEGACYSPED.Transform_PrgGoalObjective  58
DELETE LEGACYSPED.MAP_PrgGoalObjectiveID
FROM LEGACYSPED.Transform_PrgGoalObjective AS s RIGHT OUTER JOIN 
	LEGACYSPED.MAP_PrgGoalObjectiveID as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)

UPDATE STATISTICS LEGACYSPED.MAP_PrgGoalObjectiveID

--LEGACYSPED.Transform_PrgItemOutcome

DELETE LEGACYSPED.MAP_OutcomeID
FROM LEGACYSPED.Transform_PrgItemOutcome AS s RIGHT OUTER JOIN 
	LEGACYSPED.MAP_OutcomeID as d ON s.DestID = d.DestID
WHERE (s.DestID IS NULL)
