-- populate IepDistrict table with hard record, get name from SystemSettings
IF NOT EXISTS (SELECT * FROM IepDistrict WHERE ID = '2A54E70F-9673-4DE7-BCAC-2C100D68DFBE')
	INSERT IepDistrict
	SELECT '2A54E70F-9673-4DE7-BCAC-2C100D68DFBE', DistrictName, 0, 2200 
	FROM SystemSettings

-- populate the IepSchool table with complimentary records to School
INSERT IepSchool
SELECT s.ID, '2A54E70F-9673-4DE7-BCAC-2C100D68DFBE', s.Name, NULL
FROM School s
WHERE s.ID NOT IN (SELECT ID FROM IepSchool)
ORDER BY Name

-- associate all IepGoalArea records with all ProbeType records
INSERT IepGoalAreaProbeType
SELECT p.ID [ProbeTypeID], a.ID [GoalAreaID]
FROM IepGoalArea a CROSS JOIN
	ProbeType p
WHERE
	p.ID NOT IN (SELECT ProbeTypeID FROM IepGoalAreaProbeType WHERE GoalAreaID = a.ID)
