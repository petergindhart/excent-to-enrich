BEGIN TRAN 
/*
To Clean up the Maptables before sped data import
-- Delete the map table record which is not exist in DestTable
*/
DELETE m
--SELECT *
FROM LEGACYSPED.MAP_OrgUnitID m LEFT JOIN OrgUnit d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_SchoolID m LEFT JOIN School d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_IepServiceCategoryID m LEFT JOIN IepServiceCategory d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_IepPlacementOptionID m LEFT JOIN IepPlacementOption d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_PrgStatusID m LEFT JOIN PrgStatus d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_IepDisabilityID m LEFT JOIN IepDisability d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_GradeLevelID m LEFT JOIN GradeLevel d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_ServiceFrequencyID m LEFT JOIN ServiceFrequency d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_PrgLocationID m LEFT JOIN PrgLocation d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_ServiceProviderTitleID m LEFT JOIN ServiceProviderTitle d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_ServiceDefID m LEFT JOIN ServiceDef d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_StudentRefID m LEFT JOIN Student d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_PrgInvolvementID m LEFT JOIN PrgInvolvement d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_IepStudentRefID m LEFT JOIN PrgItem d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_PrgVersionID m LEFT JOIN PrgVersion d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_FormInstance_Services m LEFT JOIN FormInstance d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_FormInstanceInterval_Services m LEFT JOIN FormInstanceInterval d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_FormInputValue_Services m LEFT JOIN FormInputValue d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_PrgSectionID_NonVersioned m LEFT JOIN PrgSection d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_PrgSectionID m LEFT JOIN PrgSection d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_PrgInvolvementTeamMemberID m LEFT JOIN PrgInvolvementTeamMember d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_IepPlacementID m LEFT JOIN IepPlacement d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_IepDisabilityEligibilityID  m LEFT JOIN IepDisabilityEligibility d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_ScheduleID m LEFT JOIN Schedule d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_ServicePlanID m LEFT JOIN ServicePlan d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_IepGoalAreaDefID m LEFT JOIN IepGoalAreaDef d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_PrgGoalID m LEFT JOIN PrgCrossVersionGoal d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_IepGoalArea m LEFT JOIN IepGoalArea d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
DELETE m 
--select m.* 
FROM LEGACYSPED.MAP_PrgGoalObjectiveID m LEFT JOIN PrgGoal d ON  m.DestID =  d.ID 
WHERE d.ID IS NULL  
--DELETE m 
----select m.* 
--FROM LEGACYSPED.MAP_OutcomeID m LEFT JOIN PrgItemOutcome d ON  m.DestID =  d.ID 
--WHERE d.ID IS NULL  
--ROLLBACK TRAN 
COMMIT TRAN 